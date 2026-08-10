import 'package:expiry_deals/app/modules/home/controllers/near_me_stores_controller.dart';
import 'package:expiry_deals/app/modules/home/model/near_me_stores_model.dart';
import 'package:expiry_deals/app/modules/home/utils/near_me_stores_geo.dart';
import 'package:expiry_deals/app/modules/store/views/store_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Full-screen map: pins, bottom sheet on marker tap, draggable store list.
class NearMeStoresMapView extends StatefulWidget {
  const NearMeStoresMapView({super.key});

  @override
  State<NearMeStoresMapView> createState() => _NearMeStoresMapViewState();
}

class _NearMeStoresMapViewState extends State<NearMeStoresMapView> {
  late final NearMeStoresController _c;
  GoogleMapController? _map;
  final List<Worker> _workers = [];
  Set<Marker> _markers = {};

  List<NearMeStores> _activeList() {
    return _c.mapUsesBrowseAll.value
        ? _c.browseAllStores.toList()
        : _c.nearMeStores.toList();
  }

  void _syncMarkersAndMaybeRefit() {
    if (!mounted) return;
    final list = _activeList();
    setState(() {
      _markers = _buildMarkers(list);
    });
    if (_map != null && list.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fitAllStores(list));
    }
  }

  @override
  void initState() {
    super.initState();
    _c = Get.isRegistered<NearMeStoresController>()
        ? Get.find<NearMeStoresController>()
        : Get.put(NearMeStoresController());

    final args = Get.arguments;
    final browseAll = args is Map && args['browseAll'] == true;

    _workers.add(ever(_c.nearMeStores, (_) => _syncMarkersAndMaybeRefit()));
    _workers.add(ever(_c.browseAllStores, (_) => _syncMarkersAndMaybeRefit()));
    _workers.add(ever(_c.mapUsesBrowseAll, (_) => _syncMarkersAndMaybeRefit()));
    _workers.add(ever(_c.isBrowseLoading, (_) => setState(() {})));
    _workers.add(ever(_c.isHomeNearMeLoading, (_) => setState(() {})));
    _workers.add(ever(_c.userLatitude, (_) => setState(() {})));
    _workers.add(ever(_c.userLongitude, (_) => setState(() {})));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (browseAll) {
        await _c.fetchBrowseAllStores();
      } else {
        _c.mapUsesBrowseAll.value = false;
        if (_c.nearMeStores.isEmpty) {
          await _c.fetchNearMeStores();
        }
      }
      _syncMarkersAndMaybeRefit();
    });
  }

  @override
  void dispose() {
    for (final w in _workers) {
      w.dispose();
    }
    super.dispose();
  }

  Set<Marker> _buildMarkers(List<NearMeStores> list) {
    final next = <Marker>{};
    for (final store in list) {
      final pos = store.storeLatLng;
      final id = store.id;
      if (pos == null || id == null || id.isEmpty) continue;
      next.add(
        Marker(
          markerId: MarkerId('full_$id'),
          position: pos,
          onTap: () => _showStoreBottomSheet(store),
        ),
      );
    }
    return next;
  }

  void _showStoreBottomSheet(NearMeStores store) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final dist = _c.distanceLabel(store);
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(ctx).viewPadding.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grayLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      store.logo ?? AppImages.noImage,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: AppColors.grayLight,
                        child: const Icon(Icons.store),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.name ?? 'Store',
                          style: GoogleFonts.dmSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (dist.isNotEmpty)
                          Text(
                            dist,
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              color: AppColors.hintColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.star_border, color: Colors.amber[700], size: 22),
                  const SizedBox(width: 6),
                  Text(
                    'No ratings yet',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: AppColors.hintColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Get.to(
                      () => StoreView(
                        shopId: store.id ?? '',
                        authorId: store.author?.id ?? '',
                      ),
                    );
                  },
                  child: Text(
                    'View store',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  LatLng _initialTarget() {
    final ulat = _c.userLatitude.value;
    final ulng = _c.userLongitude.value;
    if (ulat != null && ulng != null) return LatLng(ulat, ulng);
    final list = _activeList();
    if (list.isNotEmpty) {
      final p = list.first.storeLatLng;
      if (p != null) return p;
    }
    return const LatLng(23.8103, 90.4125);
  }

  Future<void> _fitAllStores(List<NearMeStores> list) async {
    if (_map == null) return;
    final points = <LatLng>[];
    final ulat = _c.userLatitude.value;
    final ulng = _c.userLongitude.value;
    if (ulat != null && ulng != null) points.add(LatLng(ulat, ulng));
    for (final s in list) {
      final p = s.storeLatLng;
      if (p != null) points.add(p);
    }
    if (points.isEmpty) return;
    if (points.length == 1) {
      await _map!.animateCamera(CameraUpdate.newLatLngZoom(points.first, 13));
      return;
    }
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    for (final p in points) {
      minLat = minLat < p.latitude ? minLat : p.latitude;
      maxLat = maxLat > p.latitude ? maxLat : p.latitude;
      minLng = minLng < p.longitude ? minLng : p.longitude;
      maxLng = maxLng > p.longitude ? maxLng : p.longitude;
    }
    await _map!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat - 0.03, minLng - 0.03),
          northeast: LatLng(maxLat + 0.03, maxLng + 0.03),
        ),
        64,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loading = _c.isBrowseLoading.value || _c.isHomeNearMeLoading.value;
    final list = _activeList();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Android: myLocationEnabled + denied permission crashes; only enable when we have a fix.
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialTarget(),
              zoom: 12,
            ),
            markers: _markers,
            myLocationEnabled: _c.userLatitude.value != null &&
                _c.userLongitude.value != null,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (c) {
              _map = c;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final l = _activeList();
                if (l.isNotEmpty) _fitAllStores(l);
              });
            },
          ),
          if (loading && list.isEmpty)
            const ColoredBox(
              color: Colors.white54,
              child: Center(child: CircularProgressIndicator()),
            ),
          // Stack defaults to centered alignment — pin header to the top.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: [
                    Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            'Stores near you',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (list.isNotEmpty)
            DraggableScrollableSheet(
              initialChildSize: 0.22,
              minChildSize: 0.12,
              maxChildSize: 0.55,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 12,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.grayLight,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: Row(
                          children: [
                            Text(
                              'Nearest first',
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${list.length} stores',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                color: AppColors.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final store = list[index];
                            final dist = _c.distanceLabel(store);
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  store.logo ?? AppImages.noImage,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 48,
                                    height: 48,
                                    color: AppColors.grayLight,
                                    child: const Icon(Icons.store, size: 22),
                                  ),
                                ),
                              ),
                              title: Text(
                                store.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: dist.isNotEmpty
                                  ? Text(
                                      dist,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        color: AppColors.hintColor,
                                      ),
                                    )
                                  : null,
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Get.to(
                                  () => StoreView(
                                    shopId: store.id ?? '',
                                    authorId: store.author?.id ?? '',
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
