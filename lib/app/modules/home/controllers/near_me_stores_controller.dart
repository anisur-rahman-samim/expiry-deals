import 'package:expiry_deals/app/modules/home/model/near_me_stores_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/search_radius_miles.dart';

import '../../../../common/helper/current_location.dart';

/// UI state for the Near Me section on home and the full map screen.
enum NearMeDisplayStatus {
  loading,
  needsAuth,
  locationDenied,
  noShopsNearby,
  loadFailed,
  ready,
}

class NearMeStoresController extends GetxController {
  static const int _shopLimit = 50;

  /// Loading state for the home Near Me section only (true until first fetch finishes).
  var isHomeNearMeLoading = true.obs;
  /// Loading state for browse-all fetch (map / browse flow).
  var isBrowseLoading = false.obs;

  var nearMeStores = <NearMeStores>[].obs;
  /// Filled when user opens "Browse all stores" flow (does not replace [nearMeStores]).
  var browseAllStores = <NearMeStores>[].obs;
  var mapUsesBrowseAll = false.obs;

  /// Set only by [fetchNearMeStores] — drives home section empty / error UI.
  var homeNearMeStatus = NearMeDisplayStatus.loading.obs;
  var userLatitude = Rxn<double>();
  var userLongitude = Rxn<double>();
  var lastErrorMessage = ''.obs;

  /// Current search radius (miles) — Home, Browse, map. Synced with storage.
  final searchRadiusMiles = SearchRadiusMiles.get().obs;

  /// Browse tab: list all stores (no geo), like TGTG “everywhere”. Nearby uses radius + location.
  final browseEverywhere = false.obs;

  static bool _readBrowseEverywhereFromStorage() {
    final v = LocalStorage.getData(key: AppConstant.browseEverywhereMode);
    if (v is bool) return v;
    if (v is String) return v == 'true';
    return false;
  }

  @override
  void onInit() {
    super.onInit();
    searchRadiusMiles.value = SearchRadiusMiles.get();
    browseEverywhere.value = _readBrowseEverywhereFromStorage();
    fetchNearMeStores();
  }

  Future<void> setBrowseEverywhere(bool value) async {
    browseEverywhere.value = value;
    await LocalStorage.saveData(
      key: AppConstant.browseEverywhereMode,
      data: value,
    );
    await fetchBrowseAllStores();
  }

  Future<void> applySearchRadiusMiles(double miles) async {
    await SearchRadiusMiles.set(miles);
    searchRadiusMiles.value = SearchRadiusMiles.get();
    await fetchNearMeStores();
    await fetchBrowseAllStores();
  }

  Future<void> fetchNearMeStores() async {
    homeNearMeStatus.value = NearMeDisplayStatus.loading;
    lastErrorMessage.value = '';
    mapUsesBrowseAll.value = false;
    try {
      isHomeNearMeLoading(true);

      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        nearMeStores.clear();
        userLatitude.value = null;
        userLongitude.value = null;
        homeNearMeStatus.value = NearMeDisplayStatus.needsAuth;
        return;
      }

      final position = await getCurrentLocation();
      userLatitude.value = position.latitude;
      userLongitude.value = position.longitude;

      final headers = {'Authorization': 'Bearer $token'};
      final r = SearchRadiusMiles.get();
      dynamic response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api:
              "${Api.allShop}?latitude=${position.latitude}&longitude=${position.longitude}&radiusMiles=$r&limit=$_shopLimit",
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        final list = NearMeStoresModel.fromJson(response).data?.data ?? [];
        nearMeStores.assignAll(list);
        _sortByDistance(nearMeStores);
        homeNearMeStatus.value = nearMeStores.isEmpty
            ? NearMeDisplayStatus.noShopsNearby
            : NearMeDisplayStatus.ready;
      } else {
        nearMeStores.clear();
        homeNearMeStatus.value = NearMeDisplayStatus.loadFailed;
        lastErrorMessage.value = 'Failed to fetch shops.';
      }
    } catch (e) {
      final msg = e.toString().toLowerCase();
      nearMeStores.clear();
      if (msg.contains('denied') ||
          msg.contains('permanently') ||
          msg.contains('disabled')) {
        userLatitude.value = null;
        userLongitude.value = null;
        homeNearMeStatus.value = NearMeDisplayStatus.locationDenied;
      } else {
        homeNearMeStatus.value = NearMeDisplayStatus.loadFailed;
        lastErrorMessage.value = e.toString();
      }
    } finally {
      isHomeNearMeLoading(false);
    }
  }

  /// Browse tab: either all stores (no geo) or nearby within [SearchRadiusMiles].
  Future<void> fetchBrowseAllStores() async {
    mapUsesBrowseAll.value = true;
    lastErrorMessage.value = '';
    try {
      isBrowseLoading(true);

      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        browseAllStores.clear();
        return;
      }

      final headers = {'Authorization': 'Bearer $token'};

      if (browseEverywhere.value) {
        dynamic response = await BaseClient.handleResponse(
          await BaseClient.getRequest(
            api: '${Api.allShop}?limit=$_shopLimit',
            headers: headers,
          ),
        );

        if (response != null && response['success'] == true) {
          final list = NearMeStoresModel.fromJson(response).data?.data ?? [];
          browseAllStores.assignAll(list);
          _sortByName(browseAllStores);
        } else {
          browseAllStores.clear();
          lastErrorMessage.value = 'Failed to fetch shops.';
        }
        return;
      }

      double? lat;
      double? lng;
      try {
        final p = await getCurrentLocation();
        lat = p.latitude;
        lng = p.longitude;
      } catch (_) {
        lat = userLatitude.value;
        lng = userLongitude.value;
      }

      if (lat == null || lng == null) {
        browseAllStores.clear();
        lastErrorMessage.value =
            'Location is required to browse nearby stores. Turn on Everywhere to see all locations.';
        return;
      }

      userLatitude.value = lat;
      userLongitude.value = lng;

      final r = SearchRadiusMiles.get();
      dynamic response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api:
              "${Api.allShop}?latitude=$lat&longitude=$lng&radiusMiles=$r&limit=$_shopLimit",
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        final list = NearMeStoresModel.fromJson(response).data?.data ?? [];
        browseAllStores.assignAll(list);
        _sortByDistance(browseAllStores);
      } else {
        browseAllStores.clear();
        lastErrorMessage.value = 'Failed to fetch shops.';
      }
    } catch (e) {
      browseAllStores.clear();
      lastErrorMessage.value = e.toString();
    } finally {
      isBrowseLoading(false);
    }
  }

  void _sortByName(RxList<NearMeStores> list) {
    final sorted = List<NearMeStores>.from(list);
    sorted.sort(
      (a, b) => (a.name ?? '').toLowerCase().compareTo(
            (b.name ?? '').toLowerCase(),
          ),
    );
    list.assignAll(sorted);
  }

  void _sortByDistance(RxList<NearMeStores> list) {
    final ulat = userLatitude.value;
    final ulng = userLongitude.value;
    if (ulat == null || ulng == null) return;
    final sorted = List<NearMeStores>.from(list);
    sorted.sort((a, b) {
      final da = distanceMeters(a) ?? double.infinity;
      final db = distanceMeters(b) ?? double.infinity;
      return da.compareTo(db);
    });
    list.assignAll(sorted);
  }

  double? distanceMeters(NearMeStores store) {
    final c = store.location?.coordinates;
    final ulat = userLatitude.value;
    final ulng = userLongitude.value;
    if (c == null || c.length < 2 || ulat == null || ulng == null) {
      return null;
    }
    final lat = c[1];
    final lng = c[0];
    return Geolocator.distanceBetween(ulat, ulng, lat, lng);
  }

  String distanceLabel(NearMeStores store) {
    final m = distanceMeters(store);
    if (m == null) return '';
    final mi = m / 1609.34;
    if (mi < 0.25) return '${m.round()} m away';
    return '${mi.toStringAsFixed(1)} mi away';
  }
}
