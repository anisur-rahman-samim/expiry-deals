import 'package:expiry_deals/app/modules/auth/controllers/vendor_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';

class LocationPickerView extends StatefulWidget {
  @override
  _LocationPickerViewState createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {
  late GoogleMapController mapController;
  late LatLng _pickedLocation;

  @override
  void initState() {
    super.initState();
    _pickedLocation = LatLng(23.780803, 90.407960);  // Default Location (Bangladesh)
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onTap(LatLng latLng) {
    setState(() {
      _pickedLocation = latLng;
    });
  }

  void _saveLocation() {
    final vendorRequestController = Get.find<VendorRequestController>();
    vendorRequestController.locationCoordinates.value = [_pickedLocation.longitude, _pickedLocation.latitude];
    Get.back();  // Close the location picker and go back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        title: Text('Select Location', style: h2),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: AppColors.mainColor),
            onPressed: _saveLocation,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _pickedLocation,
          zoom: 14.0,
        ),
        onMapCreated: _onMapCreated,
        onTap: _onTap,
        markers: {
          Marker(
            markerId: MarkerId('selected_location'),
            position: _pickedLocation,
          ),
        },
      ),
    );
  }
}
