import 'package:expiry_deals/app/modules/home/controllers/near_me_stores_controller.dart';
import 'package:expiry_deals/app/modules/home/model/near_me_stores_model.dart';
import 'package:expiry_deals/app/modules/home/utils/near_me_stores_geo.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// ~180px map with pins for nearby stores (home section).
class NearMeMapPreview extends StatefulWidget {
  const NearMeMapPreview({
    super.key,
    required this.controller,
    required this.stores,
  });

  final NearMeStoresController controller;
  final List<NearMeStores> stores;

  @override
  State<NearMeMapPreview> createState() => _NearMeMapPreviewState();
}

class _NearMeMapPreviewState extends State<NearMeMapPreview> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void didUpdateWidget(NearMeMapPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stores.length != widget.stores.length ||
        !_sameStoreIds(oldWidget.stores, widget.stores)) {
      _buildMarkers();
    }
  }

  bool _sameStoreIds(List<NearMeStores> a, List<NearMeStores> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _buildMarkers();
  }

  void _buildMarkers() {
    final markers = <Marker>{};
    for (final store in widget.stores) {
      final pos = store.storeLatLng;
      final id = store.id;
      if (pos == null || id == null || id.isEmpty) continue;
      markers.add(
        Marker(
          markerId: MarkerId('preview_$id'),
          position: pos,
          consumeTapEvents: true,
        ),
      );
    }
    setState(() => _markers = markers);
  }

  LatLng _initialTarget() {
    final ulat = widget.controller.userLatitude.value;
    final ulng = widget.controller.userLongitude.value;
    if (ulat != null && ulng != null) {
      return LatLng(ulat, ulng);
    }
    final first = widget.stores.isNotEmpty
        ? widget.stores.first.storeLatLng
        : null;
    if (first != null) return first;
    return const LatLng(23.8103, 90.4125);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 180,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialTarget(),
            zoom: 13,
          ),
          markers: _markers,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: false,
          liteModeEnabled: false,
          onMapCreated: (c) {
            _mapController = c;
            _fitBounds();
          },
        ),
      ),
    );
  }

  Future<void> _fitBounds() async {
    if (_mapController == null || widget.stores.isEmpty) return;
    final points = <LatLng>[];
    final ulat = widget.controller.userLatitude.value;
    final ulng = widget.controller.userLongitude.value;
    if (ulat != null && ulng != null) {
      points.add(LatLng(ulat, ulng));
    }
    for (final s in widget.stores) {
      final p = s.storeLatLng;
      if (p != null) points.add(p);
    }
    if (points.length < 2) {
      if (points.length == 1) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(points.first, 13),
        );
      }
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
    await _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat - 0.02, minLng - 0.02),
          northeast: LatLng(maxLat + 0.02, maxLng + 0.02),
        ),
        48,
      ),
    );
  }

}
