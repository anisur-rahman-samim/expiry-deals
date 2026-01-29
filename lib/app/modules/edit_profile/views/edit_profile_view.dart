import 'package:expiry_deals/app/modules/edit_profile/controllers/edit_profile_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_loader.dart';
import 'package:expiry_deals/common/widgets/custom_textfelid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends GetView<EditProfileController> {
  EditProfileView({super.key});

  final EditProfileController editProfileController = Get.put(EditProfileController());

  // TextEditingControllers for input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        title: Text('Edit Profile', style: h2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Obx(() {
                    // Check if profile image is updated
                    return Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: editProfileController.selectedImage.value != null
                              ? FileImage(editProfileController.selectedImage.value!)
                              : NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/2048px-No_image_available.svg.png") as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // Show a dialog to choose between camera and gallery
                        Get.bottomSheet(
                          Container(
                            color: AppColors.white,
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera),
                                  title: const Text('Camera'),
                                  onTap: () {
                                    editProfileController.pickImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Gallery'),
                                  onTap: () {
                                    editProfileController.pickImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.black,
                        child: const Center(
                          child: Icon(
                            Icons.camera,
                            color: AppColors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            sh20,
            Text("Full Name", style: h3),
            sh5,
            Obx(() {
              // Check if the name is available, if not leave it empty
              nameController.text = editProfileController.profileData.value.data?.name ?? '';
              return CustomTextField(
                width: Get.width,
                hintText: "Enter your Name",
                controller: nameController,
              );
            }),
            sh10,
            Text("Email", style: h3),
            sh5,
            Obx(() {
              // Check if the email is available, if not leave it empty
              emailController.text = editProfileController.profileData.value.data?.email ?? '';
              return CustomTextField(
                width: Get.width,
                hintText: "Enter your email",
                controller: emailController,
                enabled: false,
              );
            }),
            sh10,
            Text("Phone Number", style: h3),
            sh5,
            Obx(() {
              // Check if the phone number is available, if not leave it empty
              phoneController.text = editProfileController.profileData.value.data?.phoneNumber ?? '';
              return CustomTextField(
                width: Get.width,
                hintText: "Your phone number",
                controller: phoneController,
              );
            }),
            sh10,
            Text("Address", style: h3),
            sh5,
            Obx(() {
              // Check if the phone number is available, if not leave it empty
              addressController.text = editProfileController.profileData.value.data?.address ?? '';
              return CustomTextField(
                width: Get.width,
                hintText: "Your address",
                controller: addressController,
              );
            }),
            sh20,
            Obx(() {
              return editProfileController.isLoading.value
                  ? CustomLoaderButton()
                  : CustomCenterButton(
                      title: "Save Changes",
                      width: Get.width,
                      onTap: () {
                        // Call API or save data logic
                        editProfileController.updateProfile(
                          nameController.text,
                          emailController.text,
                          phoneController.text,
                          addressController.text,
                          context
                        );
                      },
                    );
            }),
          ],
        ),
      ),
    );
  }
}
