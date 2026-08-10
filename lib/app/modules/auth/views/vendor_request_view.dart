import 'dart:io';

import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_loader.dart';
import 'package:expiry_deals/common/widgets/custom_textfield.dart';
import 'package:expiry_deals/app/routes/app_pages.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/vendor_request_controller.dart';
import 'location_picker_view.dart';

class VendorRequestView extends StatelessWidget {
  VendorRequestView({super.key});

  final VendorRequestController controller = Get.put(VendorRequestController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header (unchanged)
            Stack(
              children: [
                Container(
                  height: height * 0.38,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.mainColor, AppColors.secColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Material(
                        color: Colors.black.withValues(alpha: 0.18),
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          color: Colors.white,
                          tooltip: 'Back',
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(50),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        sh30,
                        Image.asset(AppImages.logoIcon, height: 70),
                        sh30,
                        Text(
                          "Apply for Vendor",
                          style: h1.copyWith(color: AppColors.white, fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                        sh10,
                        Text(
                          "Join smart and secure selling made for you.",
                          style: h2.copyWith(color: AppColors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            sh30,

            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Full Name", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh8,
                  CustomTextField(
                    hintText: "Enter Your Name",
                    controller: nameController,
                    width: Get.width,
                  ),
                  sh20,

                  Text("Email Address", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh8,
                  CustomTextField(
                    hintText: "Enter Your Email",
                    controller: emailController,
                    width: Get.width,
                  //  keyboardType: TextInputType.emailAddress,
                  ),
                  sh20,

                  Text("Shop Name", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh8,
                  CustomTextField(
                    hintText: "Enter Your Shop Name",
                    controller: shopNameController,
                    width: Get.width,
                  ),
                  sh30,

                  // ──────────────────────────────────────────────
                  // Location section – FIXED logic & LatLng order
                  // ──────────────────────────────────────────────
                  Text("Shop Location", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh5,
                  Text(
                    "Search an address or tap the map to place the pin.",
                    style: h2.copyWith(fontSize: 12, color: Colors.grey[600]),
                  ),
                  sh8,
                  Obx(() {
                    final addr = controller.shopAddressDisplay.value;
                    if (addr.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        addr,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: h2.copyWith(fontSize: 13),
                      ),
                    );
                  }),
                  GestureDetector(
                    onTap: () async {
                      LatLng? initialPos;

                      // Just used to center the map in picker — not blocking the navigation
                      if (controller.latitude.value != 0.0 && controller.longitude.value != 0.0) {
                        initialPos = LatLng(
                          controller.latitude.value,
                          controller.longitude.value,
                        );
                      }

                      final picked = await Get.to<LocationPickResult?>(
                        () => LocationPickerPage(
                          initialPosition: initialPos,
                          initialAddress:
                              controller.shopAddressDisplay.value.isEmpty
                                  ? null
                                  : controller.shopAddressDisplay.value,
                        ),
                      );

                      if (picked != null) {
                        controller.selectLocation(
                          picked.latLng,
                          formattedAddress: picked.formattedAddress,
                        );
                      }
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.grayLight.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.grayLight),
                      ),
                      child: Obx(() {
                        final hasLocation = controller.latitude.value != 0.0 &&
                            controller.longitude.value != 0.0;

                        if (!hasLocation) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on, size: 50, color: AppColors.mainColor),
                                SizedBox(height: 8),
                                Text("Tap to select location"),
                              ],
                            ),
                          );
                        }

                        // ← When location exists → still allow tap to change it
                        return Stack(
                          children: [
                            GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  controller.latitude.value,
                                  controller.longitude.value,
                                ),
                                zoom: 15,
                              ),
                              markers: {
                                Marker(
                                  markerId: const MarkerId('shop'),
                                  position: LatLng(
                                    controller.latitude.value,
                                    controller.longitude.value,
                                  ),
                                ),
                              },
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                            ),
                            // Optional: small overlay hint
                            Positioned(
                              bottom: 12,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Tap to change location",
                                    style: TextStyle(color: Colors.white, fontSize: 13),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),

                  sh20,

                  // Document Upload (unchanged – good)
                  Text("Upload Document", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh8,
                  GestureDetector(
                    onTap: controller.pickDocument,
                    child: Obx(() {
                      final file = controller.documentFile.value;
                      return Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.grayLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.grayLight),
                        ),
                        child: file != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(file, fit: BoxFit.cover),
                        )
                            : const Center(
                          child: Icon(Icons.cloud_upload, size: 50, color: AppColors.mainColor),
                        ),
                      );
                    }),
                  ),

                  Obx(() {
                    final file = controller.documentFile.value;
                    if (file != null) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                file.path.split(Platform.pathSeparator).last,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18, color: Colors.red),
                              onPressed: () => controller.documentFile.value = null,
                              tooltip: 'Remove document',
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  sh20,

                  Obx(
                    () => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: controller.acceptedTerms.value,
                          onChanged: (v) =>
                              controller.acceptedTerms.value = v ?? false,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              children: [
                                Text(
                                  'I have read and agree to the',
                                  style: h2.copyWith(fontSize: 13, height: 1.35),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      Get.toNamed(Routes.TERMS_CONDITIONS),
                                  child: Text(
                                    'Terms & Conditions',
                                    style: h2.copyWith(
                                      fontSize: 13,
                                      color: AppColors.mainColor,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.mainColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  sh20,

                  // Submit Button
                  Obx(
                        () => controller.isLoading.value
                        ? const CustomLoaderButton()
                        : CustomCenterButton(
                      title: "Submit Request",
                      width: double.infinity,
                      onTap: () {
                        final name = nameController.text.trim();
                        final email = emailController.text.trim();
                        final shopName = shopNameController.text.trim();

                        if (name.isEmpty || email.isEmpty || shopName.isEmpty) {
                          Get.snackbar("Error", "Please fill all fields");
                          return;
                        }

                        if (!email.contains('@') || !email.contains('.')) {
                          Get.snackbar("Error", "Please enter a valid email");
                          return;
                        }

                        if (controller.latitude.value == 0.0 || controller.longitude.value == 0.0) {
                          Get.snackbar("Error", "Please select a location");
                          return;
                        }

                        if (controller.documentFile.value == null) {
                          Get.snackbar("Error", "Please upload a document");
                          return;
                        }

                        if (!controller.acceptedTerms.value) {
                          Get.snackbar(
                            'Required',
                            'Please accept the Terms & Conditions to continue.',
                          );
                          return;
                        }

                        controller.submitVendorRequest(
                          name: name,
                          email: email,
                          shopName: shopName,
                        );
                      },
                    ),
                  ),

                  sh40,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}