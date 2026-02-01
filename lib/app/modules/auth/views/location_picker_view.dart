import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class LocationPickerPage extends StatefulWidget {
  final LatLng? initialPosition;

  const LocationPickerPage({
    super.key,
    this.initialPosition,
  });

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  late GoogleMapController _mapController;
  LatLng? _selectedPosition;

  @override
  void initState() {
    super.initState();
    // Default to Dhaka if no initial position
    _selectedPosition = widget.initialPosition ?? const LatLng(23.8103, 90.4125);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Shop Location"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: "Confirm location",
            onPressed: () {
              if (_selectedPosition != null) {
                Get.back(result: _selectedPosition);
              } else {
                Get.snackbar("No location", "Please tap on the map to select a location");
              }
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _selectedPosition!,
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: {
          if (_selectedPosition != null)
            Marker(
              markerId: const MarkerId('selected_location'),
              position: _selectedPosition!,
              infoWindow: const InfoWindow(title: "Selected Location"),
            ),
        },
        onTap: (LatLng position) {
          setState(() {
            _selectedPosition = position;
          });
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapToolbarEnabled: true,
        zoomControlsEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // You can add geolocator here later to go to current location
          // For now just center on selected if exists
          if (_selectedPosition != null) {
            _mapController.animateCamera(
              CameraUpdate.newLatLng(_selectedPosition!),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}