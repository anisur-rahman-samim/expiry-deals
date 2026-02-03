import 'package:expiry_deals/app/modules/auth/views/verify_view.dart';
import 'package:expiry_deals/app/modules/forget/controllers/forget_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_loader.dart';
import 'package:expiry_deals/common/widgets/custom_textfelid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetView extends StatelessWidget {
  const ForgetView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final TextEditingController emailController = TextEditingController();

    final ForgetController forgetController = Get.put(ForgetController());

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
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        sh30,
                        // Logo
                        Image.asset(AppImages.logoIcon, height: 70),
                        sh30,

                        // Title
                        Text(
                          "Verify It's You",
                          style: h1.copyWith(color: AppColors.white, fontSize: 28),
                          textAlign: TextAlign.center,
                        ),
                        sh10,
                        Text(
                            "Please provide the email address associated with your account.",
                            textAlign: TextAlign.center,
                            style: h3.copyWith(color: AppColors.white, fontSize: 14)
                        ),
                        sh10,

                      ],
                    ),
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
                  CustomTextField(hintText: "Enter Your Email",controller: emailController,width: Get.width),
                  sh20,

                  // Login Button
                 Obx(() => forgetController.isLoading.value? CustomLoaderButton() : CustomCenterButton(
                   title: "Continue",
                   width: double.infinity,
                   onTap: () {
                     forgetController.forgetPassword(email: emailController.text);
                   },
                 ),),


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
