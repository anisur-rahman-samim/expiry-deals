// app/modules/auth/login/views/login_view.dart
import 'package:expiry_deals/app/modules/auth/views/signup_view.dart';
import 'package:expiry_deals/app/modules/dashboard/views/dashboard_view.dart';
import 'package:expiry_deals/app/modules/forget/views/forget_view.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/views/vendor_dashboard_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_textfelid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginView extends StatelessWidget {
  final String role;
  const LoginView({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

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
                        "Welcome Back!",
                        style: h1.copyWith(color: AppColors.white, fontSize: 34)
                      ),
                      sh10,

                      // Subtitle
                      Text(
                        "Sign in to continue your journey with Trusten.",
                          style: h2.copyWith(color: AppColors.white, fontSize: 14)
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
                  // Email Field
                  Text("Email Address", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh8,
                  CustomTextField(hintText: "Enter Your Email",width: Get.width),
                  sh20,

                  // Password Field
                  Text("Password", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh8,
                  CustomTextField(hintText: "Enter Your Email",width: Get.width,obscureText: true,),
                  sh10,
                  Align(
                    alignment: Alignment.topRight,
                    
                    child: GestureDetector(
                        onTap: () => Get.to(() => ForgetView()),
                        child: Text("Forget Password?",style: h3.copyWith(color: AppColors.gray),)),
                  ),
                  sh30,

                  // Login Button
                  CustomCenterButton(
                    title: "Login",
                    width: double.infinity,
                    onTap: () {
                      String? role =     LocalStorage.getData(key: AppConstant.role);
                      debugPrint("Role:::::::::::: $role");
                      if(role == "User"){
                         Get.offAll(() => DashboardView());

                      }else{
                        Get.offAll(() => VendorDashboardView());
                      }
                   
                    },
                  ),

                  sh30,

                  // Or Divider
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

                  // Sign Up Link
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => SignupView());
                      },
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