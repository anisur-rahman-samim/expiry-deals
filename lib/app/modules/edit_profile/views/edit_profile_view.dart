import 'dart:io';
import 'package:expiry_deals/app/modules/edit_profile/controllers/edit_profile_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_loader.dart';
import 'package:expiry_deals/common/widgets/custom_textfelid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends GetView {
  EditProfileView({super.key});

  // Controllers
  final nameController    = TextEditingController();
  final emailController   = TextEditingController();
  final phoneController   = TextEditingController();
  final addressController = TextEditingController();

  final EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    // Initialize fields once when profile data is available
    ever(controller.profileData, (_) {
      final data = controller.profileData.value.data;
      if (data != null) {
        nameController.text    = data.name    ?? '';
        emailController.text   = data.email   ?? '';
        phoneController.text   = data.phoneNumber ?? '';
        addressController.text = data.address ?? '';
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        title: Text('Edit Profile', style: h2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Obx(() {
                      final pickedFile = controller.selectedImage.value;
                      final profilePicUrl = controller.profileData.value.data?.profile;

                      ImageProvider? imageProvider;

                      if (pickedFile != null) {
                        imageProvider = FileImage(pickedFile);
                      } else if (profilePicUrl != null && profilePicUrl.isNotEmpty) {
                        imageProvider = NetworkImage(profilePicUrl);
                      } else {
                        imageProvider = const NetworkImage(AppImages.noImage);
                      }

                      return Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),

                    // Camera / Edit button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _showImagePickerBottomSheet(),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.black,
                          child: const Icon(
                            Icons.camera_alt,
                            color: AppColors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              sh20,

              // ── Full Name ────────────────────────────────────────
              Text("Full Name", style: h3),
              sh5,
              CustomTextField(
                width: Get.width,
                hintText: "Enter your Name",
                controller: nameController,
              ),

              sh10,

              // ── Email (disabled) ─────────────────────────────────
              Text("Email", style: h3),
              sh5,
              CustomTextField(
                width: Get.width,
                hintText: "Enter your email",
                controller: emailController,
                enabled: false,
              ),

              sh10,

              // ── Phone ────────────────────────────────────────────
              Text("Phone Number", style: h3),
              sh5,
              CustomTextField(
                width: Get.width,
                hintText: "Your phone number",
                controller: phoneController,

              ),

              sh10,

              // ── Address ──────────────────────────────────────────
              Text("Address", style: h3),
              sh5,
              CustomTextField(
                width: Get.width,
                hintText: "Your address",
                controller: addressController,
                maxLines: 3,
              ),

              sh30,

              // ── Save Button ──────────────────────────────────────
              Obx(() => controller.isLoading.value
                  ? const CustomLoaderButton()
                  : CustomCenterButton(
                title: "Save Changes",
                width: Get.width,
                onTap: () {
                  controller.updateProfile(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    phone: phoneController.text.trim(),
                    address: addressController.text.trim(),
                    context: context,
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePickerBottomSheet() {
    Get.bottomSheet(
      Container(
        color: AppColors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                controller.pickImage(ImageSource.camera);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                controller.pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

}