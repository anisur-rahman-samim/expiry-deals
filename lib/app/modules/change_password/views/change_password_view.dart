
import 'package:expiry_deals/app/modules/change_password/controllers/change_password_controller.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_textfelid.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: AppColors.bgColor,
          title:  Text('Change Password',style: h2.copyWith(fontSize: 18),),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(image: AssetImage(AppImages.lock))
                  ),
                ),
              ),
              sh20,
              Text("Old Password",style: h3,),
              sh5,
              CustomTextField(width: Get.width, hintText: "Password",obscureText: true,),
              sh10,
              Text("New Password",style: h3,),
              sh5,
              CustomTextField(width: Get.width, hintText: "Password",obscureText: true),
              sh10,
              Text("Confirm Password",style: h3,),
              sh5,
              CustomTextField(width: Get.width, hintText: "Password",obscureText: true),
              sh20,
              CustomCenterButton(onTap: (){
                Get.back();
              },title: "Save Changes", width: Get.width)

            ],
          ),
        )
    );
  }
}
