import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_profile/controllers/vendor_profile_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';


// ── View ────────────────────────────────────────────────────────────────
class EditShopView extends GetView {
  EditShopView({super.key});

  final EditShopController controller = Get.put(EditShopController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          "Edit Shop",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),

      ),
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(),
                const SizedBox(height: 32),
                _buildCard(child: _buildBasicInfo()),
                const SizedBox(height: 24),
                _buildCard(child: _buildOpeningSection()),
                const SizedBox(height: 24),
                _buildCard(child: _buildLocationSection()),
                const SizedBox(height: 40),
              ],
            ),
          ),

          // ── Fixed Save button at bottom ───────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Obx(() => controller.isLoading.value ? CustomLoaderButton() : CustomCenterButton(onTap: controller.updateShop,title: "SAVE CHANGES", width: Get.width),)
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => controller.pickImage(true),
          child: Obx(() => Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.grey.shade50,
              image: controller.bannerImage.value != null || controller.myShop.value.data?.banner != null
                  ? DecorationImage(
                image: controller.bannerImage.value != null
                    ? FileImage(controller.bannerImage.value!)
                    : NetworkImage(controller.myShop.value.data?.banner ?? ''),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: controller.bannerImage.value == null && controller.myShop.value.data?.banner == null
                ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text("Banner", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
                : const Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  radius: 18,
                  child: Icon(Icons.edit, size: 20, color: Colors.white),
                ),
              ),
            ),
          )),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            GestureDetector(
              onTap: () => controller.pickImage(false),
              child: Obx(() => Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.grey.shade50,
                  image: controller.logoImage.value != null || controller.myShop.value.data?.logo != null
                      ? DecorationImage(
                    image: controller.logoImage.value != null
                        ? FileImage(controller.logoImage.value!)
                        : NetworkImage(controller.myShop.value.data?.logo ?? ''),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: controller.logoImage.value == null && controller.myShop.value.data?.logo == null
                    ? const Icon(Icons.add_business, size: 36, color: Colors.grey)
                    : Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 18,
                      child: Icon(Icons.edit, size: 20, color: Colors.white),
                    ),
                  ),
                ),
              )),
            ),
            const SizedBox(width: 20),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shop Logo",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "1:1 ratio • min 512×512 px",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Basic Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
        _buildTextField(controller.nameController, "Shop Name", Icons.store),
        const SizedBox(height: 20),
        _buildTextField(controller.descController, "Description", Icons.description, maxLines: 4),
        const SizedBox(height: 20),
        _buildTextField(controller.addressController, "Full Address", Icons.location_on),
      ],
    );
  }

  Widget _buildOpeningSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Opening Time", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        Obx(() => _buildDropdown(
          value: controller.selectedOpeningHours.value,
          items: const [
            "8:00 AM - 9:00 PM",
            "9:00 AM - 10:00 PM",
            "10:00 AM - 11:00 PM",
            "11:00 AM - 12:00 AM",
            "Custom hours...",
          ],
          label: "Select Hours",
        )),
        const SizedBox(height: 28),
        const Text("Open Days", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Obx(() => Wrap(
          spacing: 10,
          runSpacing: 12,
          children: controller.daysOfWeek.map((day) {
            final selected = controller.selectedDays.contains(day);
            return FilterChip(
              label: Text(day),
              selected: selected,
              selectedColor: Colors.black87,
              backgroundColor: Colors.grey.shade100,
              labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
              checkmarkColor: Colors.white,
              onSelected: (_) {
                if (selected) {
                  controller.selectedDays.remove(day);
                } else {
                  controller.selectedDays.add(day);
                }
              },
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Shop Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 240,
            child: Obx(
                  () => GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: controller.shopLocation.value,
                  zoom: 15.5,
                ),
                onMapCreated: controller.onMapCreated,
                markers: {
                  Marker(
                    markerId: const MarkerId("shop"),
                    position: controller.shopLocation.value,
                  ),
                },
                onTap: controller.updateLocation,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
              () => Text(
            "Lat: ${controller.shopLocation.value.latitude.toStringAsFixed(6)}    Lng: ${controller.shopLocation.value.longitude.toStringAsFixed(6)}",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController ctrl,
      String label,
      IconData icon, {
        int maxLines = 1,
      }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      minLines: maxLines > 1 ? 3 : 1,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black87, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String label,
  }) {
    return DropdownButtonFormField<String?>(
      value: value,
      hint: const Text("Select opening hours"), // shown when value == null
      items: items.map((e) => DropdownMenuItem<String?>(
        value: e,
        child: Text(e),
      )).toList(),
      onChanged: (v) {
        controller.selectedOpeningHours.value = v;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black87, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}