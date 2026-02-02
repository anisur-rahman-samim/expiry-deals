import 'dart:io';

import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_loader.dart';
import 'package:expiry_deals/common/widgets/custom_snackbar.dart';
import 'package:expiry_deals/common/widgets/custom_textfelid.dart';
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
                Padding(
                  padding: const EdgeInsets.all(50),
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
                  sh8,
                  GestureDetector(
                    onTap: () async {
                      LatLng? initialPos;

                      if (controller.latitude.value != 0.0 && controller.longitude.value != 0.0) {
                        initialPos = LatLng(
                          controller.latitude.value,   // ← latitude first
                          controller.longitude.value,  // ← longitude second
                        );
                      }

                      final LatLng? picked = await Get.to(
                            () => LocationPickerPage(initialPosition: initialPos),
                      );

                      if (picked != null) {
                        controller.selectLocation(picked);
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

                        return GoogleMap(
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

                  sh30,

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