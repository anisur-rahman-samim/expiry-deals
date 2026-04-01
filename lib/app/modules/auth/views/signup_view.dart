import 'package:expiry_deals/app/modules/auth/controllers/auth_controller.dart';
import 'package:expiry_deals/app/modules/auth/views/login_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_loader.dart';
import 'package:expiry_deals/common/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Stack(
              children: [
                Container(
                  height: size.height * 0.38,
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
                          "Create Your Account",
                          style: h1.copyWith(color: AppColors.white, fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                        sh10,
                        Text(
                          "Join smart and secure shopping made for you.",
                          style: h2.copyWith(color: AppColors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            sh30,

            // Form
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Full Name", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh8,
                  CustomTextField(
                    hintText: "Enter Your Name",
                    controller: auth.nameController,
                    width: Get.width,
                  ),
                  sh20,

                  Text("Email Address", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh8,
                  CustomTextField(
                    hintText: "Enter Your Email",
                    controller: auth.emailController,
                    width: Get.width,
                  ),
                  sh20,

              

                  Text("Address", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh8,
                  Text(
                    "Search with Google, then move the pin if needed — same as vendor signup. You can still edit the text after.",
                    style: h2.copyWith(fontSize: 12, color: Colors.black54, height: 1.35),
                  ),
                  sh8,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => auth.openSignupAddressPicker(),
                      icon: Icon(Icons.location_on, color: AppColors.mainColor, size: 22),
                      label: Text(
                        'Pick on map / search',
                        style: h3.copyWith(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  sh8,
                  CustomTextField(
                    hintText: "Address appears here — or type manually",
                    controller: auth.addressController,
                    width: size.width * 0.8,
                  ),
                  sh20,

                  Text("Password", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh8,
                  CustomTextField(
                    hintText: "Enter Your Password",
                    controller: auth.passwordController,
                    width: Get.width,
                    obscureText: true,
                  ),
                  sh20,

                  Text("Confirm Password", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh8,
                  CustomTextField(
                    hintText: "Enter Your Confirm Password",
                    controller: auth.confirmPasswordController,
                    width: Get.width,
                    obscureText: true,
                  ),
                  sh30,

                  // Sign Up Button
                  Obx(() => auth.isLoading.value
                      ? const CustomLoaderButton()
                      : CustomCenterButton(
                          title: "Sign Up",
                          width: double.infinity,
                          onTap: () => auth.registration(),
                        )),

                  sh30,

                  // Divider + Sign in link
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Or", style: TextStyle(color: Colors.grey[600])),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),

                  sh30,

                  Center(
                    child: TextButton(
                      onPressed: () => Get.to(() =>  LoginView()),
                      child: RichText(
                        text: TextSpan(
                          style: h3,
                          children: [
                            const TextSpan(text: "Already have an account? "),
                            TextSpan(
                              text: "Sign in",
                              style: h3.copyWith(
                                color: AppColors.mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

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