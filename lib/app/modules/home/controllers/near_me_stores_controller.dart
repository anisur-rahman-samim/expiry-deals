import 'package:expiry_deals/app/modules/home/model/near_me_stores_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';

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

  /// Client-side cap so the home “near me” list is not dominated by the whole catalog
  /// when the API returns unfiltered results. Adjust if your backend adds a radius filter.
  static const double _nearbyRadiusKm = 50.0;

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

  @override
  void onInit() {
    super.onInit();
    fetchNearMeStores();
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
      dynamic response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api:
              "${Api.allShop}?latitude=${position.latitude}&longitude=${position.longitude}&limit=$_shopLimit",
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        final list = NearMeStoresModel.fromJson(response).data?.data ?? [];
        nearMeStores.assignAll(list);
        _keepOnlyNearby(nearMeStores);
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

  /// Load up to [_shopLimit] shops without geo filter (browse all).
  Future<void> fetchBrowseAllStores() async {
    mapUsesBrowseAll.value = true;
    try {
      isBrowseLoading(true);

      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        browseAllStores.clear();
        return;
      }

      try {
        final p = await getCurrentLocation();
        userLatitude.value = p.latitude;
        userLongitude.value = p.longitude;
      } catch (_) {
        // Optional: distances may be unavailable
      }

      final headers = {'Authorization': 'Bearer $token'};
      dynamic response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: "${Api.allShop}?limit=$_shopLimit",
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

  /// Drops shops farther than [_nearbyRadiusKm] or without coordinates.
  void _keepOnlyNearby(RxList<NearMeStores> list) {
    final ulat = userLatitude.value;
    final ulng = userLongitude.value;
    if (ulat == null || ulng == null) return;
    final maxM = _nearbyRadiusKm * 1000;
    final filtered = list.where((s) {
      final m = distanceMeters(s);
      return m != null && m <= maxM;
    }).toList();
    list.assignAll(filtered);
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
    if (m < 1000) return '${m.round()} m away';
    return '${(m / 1000).toStringAsFixed(1)} km away';
  }
}
