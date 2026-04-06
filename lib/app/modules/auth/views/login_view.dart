import 'package:expiry_deals/app/modules/auth/controllers/auth_controller.dart';
import 'package:expiry_deals/app/modules/auth/views/vendor_request_view.dart';
import 'package:expiry_deals/app/routes/app_pages.dart';
import 'package:expiry_deals/common/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:expiry_deals/app/modules/auth/views/signup_view.dart';
import 'package:expiry_deals/app/modules/forget/views/forget_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_textfield.dart';

class LoginView extends StatelessWidget {
  final bool? isVendor;
   LoginView({super.key, this.isVendor = false});

  // Controllers are class members — created only once
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: Colors.white,
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
                          onPressed: () {
                            if (Navigator.of(context).canPop()) {
                              Get.back();
                            } else {
                              Get.offNamed(Routes.CHOOSE_ROLE);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(50),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        sh30,
                        Image.asset(AppImages.logoIcon, height: 70),
                        sh30,
                        Text(
                          "Welcome Back!",
                          style: h1.copyWith(color: AppColors.white, fontSize: 34),
                        ),
                        sh10,
                        Text(
                          "Sign in to browse nearby deals and manage your account.",
                          textAlign: TextAlign.center,
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
                  Text("Email Address", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh8,
                  CustomTextField(
                    controller: emailController, // ← now using persistent controller
                    hintText: "Enter Your Email",
                    width: Get.width,
                  ),
                  sh20,

                  Text("Password", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh8,
                  CustomTextField(
                    controller: passwordController, // ← persistent controller
                    hintText: "Enter Your Password",
                    width: Get.width,
                    obscureText: true,
                  ),
                  sh10,
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Get.to(() => ForgetView()),
                      child: Text(
                        "Forgot Password?",
                        style: h3.copyWith(color: AppColors.gray),
                      ),
                    ),
                  ),
                  sh30,

                  Obx(() {
                    return CustomCenterButton(
                      title: authController.isLoading.value ? "Logging in..." : "Login",
                      width: double.infinity,
                      onTap: () {
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          kSnackBar(message: 'Please fill in all fields', bgColor: AppColors.failedColor);
                        } else {
                          authController.login(email: email, password: password);
                        }
                      },
                    );
                  }),

                  sh30,

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

                  isVendor == true
                      ? Center(
                    child: TextButton(
                      onPressed: () => Get.to(() => VendorRequestView()),
                      child: RichText(
                        text: TextSpan(
                          style: h3,
                          children: [
                            const TextSpan(text: "Become a Vendor, "),
                            TextSpan(
                              text: "Apply",
                              style: h3.copyWith(
                                color: AppColors.mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      : Center(
                    child: TextButton(
                      onPressed: () => Get.to(() => SignupView()),
                      child: RichText(
                        text: TextSpan(
                          style: h3,
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: "Sign up",
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