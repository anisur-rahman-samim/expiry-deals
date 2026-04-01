import 'dart:async';

import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/helper/google_places_client.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

/// Returned when user confirms a shop location.
class LocationPickResult {
  const LocationPickResult({
    required this.latLng,
    this.formattedAddress,
  });

  final LatLng latLng;
  /// From Places or reverse-geocode; may be null if user only tapped the map.
  final String? formattedAddress;
}

class LocationPickerPage extends StatefulWidget {
  final LatLng? initialPosition;
  final String? initialAddress;

  const LocationPickerPage({
    super.key,
    this.initialPosition,
    this.initialAddress,
  });

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  GoogleMapController? _mapController;
  late LatLng _selectedPosition;
  String? _addressLabel;
  Timer? _debounce;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  List<PlaceSuggestion> _suggestions = [];
  bool _searchLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedPosition =
        widget.initialPosition ?? const LatLng(23.8103, 90.4125);
    _addressLabel = widget.initialAddress;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final q = value.trim();
      if (q.length < 2) {
        if (mounted) setState(() => _suggestions = []);
        return;
      }
      setState(() => _searchLoading = true);
      try {
        final list = await GooglePlacesClient.autocomplete(input: q);
        if (mounted) setState(() => _suggestions = list);
      } catch (e) {
        if (mounted) setState(() => _suggestions = []);
      } finally {
        if (mounted) setState(() => _searchLoading = false);
      }
    });
  }

  Future<void> _applySuggestion(PlaceSuggestion s) async {
    _searchFocus.unfocus();
    setState(() {
      _suggestions = [];
      _searchLoading = true;
    });
    try {
      final details = await GooglePlacesClient.placeDetails(placeId: s.placeId);
      if (!mounted || details == null) return;
      setState(() {
        _selectedPosition = details.latLng;
        _addressLabel = details.formattedAddress ?? s.description;
        _searchController.text = details.formattedAddress ?? s.description;
      });
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(details.latLng, 17),
      );
    } finally {
      if (mounted) setState(() => _searchLoading = false);
    }
  }

  Future<void> _movePinToMyLocation() async {
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        Get.snackbar(
          'Location',
          'Allow location to move the pin to where you are.',
        );
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      final latLng = LatLng(pos.latitude, pos.longitude);
      if (!mounted) return;
      setState(() => _selectedPosition = latLng);
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 16),
      );
      await _reverseGeocode(latLng);
    } catch (e) {
      Get.snackbar('Location', 'Could not get your current location.');
    }
  }

  Future<void> _reverseGeocode(LatLng p) async {
    try {
      final marks = await geo.placemarkFromCoordinates(
        p.latitude,
        p.longitude,
      );
      if (!mounted || marks.isEmpty) return;
      final m = marks.first;
      final parts = <String>[
        if ((m.street ?? '').isNotEmpty) m.street!,
        if ((m.locality ?? '').isNotEmpty) m.locality!,
        if ((m.administrativeArea ?? '').isNotEmpty) m.administrativeArea!,
        if ((m.postalCode ?? '').isNotEmpty) m.postalCode!,
      ];
      if (parts.isEmpty) return;
      setState(() {
        _addressLabel = parts.join(', ');
        _searchController.text = _addressLabel!;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _addressLabel = 'Custom pin — drag map and tap to place';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('Select shop location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Use this location',
            onPressed: () {
              Get.back(
                result: LocationPickResult(
                  latLng: _selectedPosition,
                  formattedAddress: _addressLabel,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              decoration: InputDecoration(
                hintText: 'Search address (Google suggestions)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _suggestions = []);
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.grayLight.withValues(alpha: 0.15),
              ),
              textInputAction: TextInputAction.search,
              onChanged: _onSearchChanged,
            ),
          ),
          if (_suggestions.isNotEmpty)
            Material(
              elevation: 2,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _suggestions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final s = _suggestions[i];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.place_outlined, size: 22),
                      title: Text(
                        s.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => _applySuggestion(s),
                    );
                  },
                ),
              ),
            ),
          if (_addressLabel != null && _addressLabel!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                _addressLabel!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Tap the map to move the pin and fine-tune.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedPosition,
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              markers: {
                Marker(
                  markerId: const MarkerId('selected_location'),
                  position: _selectedPosition,
                  draggable: true,
                  onDragEnd: (LatLng p) {
                    setState(() => _selectedPosition = p);
                    _reverseGeocode(p);
                  },
                  infoWindow: InfoWindow(
                    title: _addressLabel ?? 'Shop location',
                  ),
                ),
              },
              onTap: (LatLng position) {
                setState(() => _selectedPosition = position);
                _reverseGeocode(position);
              },
              // Keep only the shop pin — "my location" draws a second marker/dot.
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: true,
              zoomControlsEnabled: true,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Move pin to my current location',
        onPressed: _movePinToMyLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
