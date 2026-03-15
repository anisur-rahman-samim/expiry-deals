

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FullScreenLocationPicker extends StatefulWidget {
  final LatLng initialPosition;

  const FullScreenLocationPicker({super.key, required this.initialPosition});

  @override
  State<FullScreenLocationPicker> createState() => _FullScreenLocationPickerState();
}

class _FullScreenLocationPickerState extends State<FullScreenLocationPicker> {
  GoogleMapController? _mapController;
  late LatLng _currentPosition;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          "Set Shop Location",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: () => Get.back(result: _currentPosition),
              child: const Text(
                "CONFIRM",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition,
              zoom: 15.5,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: {
              Marker(
                markerId: const MarkerId("shop"),
                position: _currentPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            },
            onTap: (LatLng pos) {
              setState(() => _currentPosition = pos);
              _mapController?.animateCamera(CameraUpdate.newLatLng(pos));
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),
          // Center fixed pin (recommended UX)
          // const IgnorePointer(
          //   child: Center(
          //     child: Icon(
          //       Icons.location_pin,
          //       size: 56,
          //       color: Colors.red,
          //       shadows: [Shadow(color: Colors.black45, blurRadius: 8)],
          //     ),
          //   ),
          // ),
          // Bottom hint
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "Tap or drag map to set exact location",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}