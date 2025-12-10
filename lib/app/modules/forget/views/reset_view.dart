// app/modules/auth/login/views/login_view.dart
import 'package:expiry_deals/app/modules/auth/views/login_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_snackbar.dart';
import 'package:expiry_deals/common/widgets/custom_textfelid.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ResetView extends StatelessWidget {
  const ResetView({super.key});

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
                          "Set New Password",
                          textAlign: TextAlign.center,
                          style: h1.copyWith(color: AppColors.white, fontSize: 30)
                      ),
                      sh10,
                      Text(
                          "Update your password to complete the reset process.",
                          textAlign: TextAlign.center,
                          style: h3.copyWith(color: AppColors.white, fontSize: 14)
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
                  // Password Field
                  Text("Password", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh8,
                  CustomTextField(hintText: "Enter Your Password",width: Get.width,obscureText: true,),
                  sh20,
                  // Password Field
                  Text("Confirm Password", style: h4.copyWith(fontWeight: FontWeight.w600)),
                  sh8,
                  CustomTextField(hintText: "Enter Your Confirm Password",width: Get.width,obscureText: true,),

                  sh30,

                  // Login Button
                  CustomCenterButton(
                    title: "Save",
                    width: double.infinity,
                    onTap: () {
                      kSnackBar(message: "Set New Password Successfully", bgColor: AppColors.green);
                        Get.to(() => LoginView(role: LocalStorage.getData(key: AppConstant.role),));
                    },
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