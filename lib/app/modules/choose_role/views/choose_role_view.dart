// app/modules/choose_role/views/choose_role_view.dart
import 'package:expiry_deals/app/modules/auth/views/login_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_sizes/app_sizes.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseRoleView extends StatelessWidget {
  const ChooseRoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Top Orange Section with Logo + Illustration
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [

                  // Main Illustration
                  Image.asset(
                    AppImages.roleSelect,
                   // height: 320,
                    fit: BoxFit.contain,
                  ),

                  sh40,
                ],
              ),
            ),


            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
              child: Text(
                "Choose Your Role",
                textAlign: TextAlign.center,
                style: h1.copyWith(
                  fontSize: 32,
                  height: 1.2,
                ),
              ),
            ),

            sh20,

            // Subtitle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
              child: Text(
                "Use our map view to find stores and products near you, or browse by categories.",
                textAlign: TextAlign.center,
                style: h4.copyWith(
                  color: Colors.black54,
                  height: 1.6,
                ),
              ),
            ),

            const Spacer(),

            // User Button (Gradient Orange)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
              child: CustomCenterButton(
                title: "User",
                width: double.infinity,
                onTap: () {
                             LocalStorage.saveData(key: AppConstant.role, data: "User");
                  Get.to(() => LoginView(role: "User",));
                },
              ),
            ),

            sh20,

            // Vendor Button (White with border)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
              child: CustomCenterButton(
                title: "Vendor",
                width: double.infinity,
                bgColor: Colors.white,
                textColor: AppColors.mainColor,
                onTap: () {
                  LocalStorage.saveData(key: AppConstant.role, data: "Vendor");
                   Get.to(() => LoginView(role: "Vendor",));
                },
              ),
            ),

            sh50,
            sh30,
          ],
        ),
      ),
    );
  }
}