import 'package:expiry_deals/app/modules/auth/controllers/auth_controller.dart';
import 'package:expiry_deals/app/modules/auth/views/login_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_loader.dart';
import 'package:expiry_deals/common/widgets/custom_snackbar.dart';
import 'package:expiry_deals/common/widgets/custom_textfelid.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendorRequestView extends StatelessWidget {
  const VendorRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    // TextEditingControllers for the form fields
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController shopNameController = TextEditingController();

    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Orange Header with Curved Bottom
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
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                    ),
                  ),
                ),
                // Content inside header
                Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sh30,
                      // Logo
                      Image.asset(AppImages.logoIcon, height: 70),
                      sh30,

                      // Title
                      Text(
                        "Apply for vendor",
                        style: h1.copyWith(
                          color: AppColors.white,
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      sh10,

                      // Subtitle
                      Text(
                        "Join smart and secure selling made for you.",
                        style: h2.copyWith(
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            sh30,

            // White Card Form
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Full Name",
                    style: h4.copyWith(fontWeight: FontWeight.w600),
                  ),
                  sh8,
                  CustomTextField(
                    hintText: "Enter Your Name",
                    controller: nameController,
                    width: Get.width,
                  ),
                  sh20,

                  // Email Field
                  Text(
                    "Email Address",
                    style: h4.copyWith(fontWeight: FontWeight.w600),
                  ),
                  sh8,
                  CustomTextField(
                    hintText: "Enter Your Email",
                    controller: emailController,
                    width: Get.width,
                  ),
                  sh20,

                  // Address
                  Text(
                    "Shop Name",
                    style: h4.copyWith(fontWeight: FontWeight.w600),
                  ),
                  sh8,
                  CustomTextField(
                    hintText: "Enter Your Shop Name",
                    controller: shopNameController,
                    width: Get.width,
                  ),

                  sh30,

                  // Sign Up Button
                  Obx(() =>  authController.isLoading.value
                      ? CustomLoaderButton()
                      : CustomCenterButton(
                    title: "Sign Up",
                    width: double.infinity,
                    onTap: () {
                      final name = nameController.text;
                      final email = emailController.text;

                    },
                  ),),

                  sh30,




                  sh50,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
