import 'package:expiry_deals/app/modules/choose_role/views/choose_role_view.dart';
import 'package:expiry_deals/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:expiry_deals/app/modules/favorites/views/favorites_view.dart';
import 'package:expiry_deals/app/modules/my_orders/views/my_orders_view.dart';
import 'package:expiry_deals/app/modules/change_password/views/change_password_view.dart';
import 'package:expiry_deals/app/modules/terms_conditions/views/terms_conditions_view.dart';
import 'package:expiry_deals/app/modules/privacy_policy/views/privacy_policy_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
   ProfileView({super.key});

  @override
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.bgColor,
        title: Text('Profile', style: h2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: RefreshIndicator(
            onRefresh: ()async{
              await controller.fetchProfile();
            },
            child: Column(
              children: [
                /// Profile Image & Name
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
            
                  final user = controller.profileData.value.data;
                  return Column(
                    children: [
                      // Profile Image
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          user?.profile ?? AppImages.noImage
                        ),
                      ),
                      sw10,
            
                      // User Name & Email
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(user?.name ?? 'No Name', style: h2),
                          Text(user?.email ?? 'No Email', style: h3),
                        ],
                      ),
                    ],
                  );
                }),
            
                sh30,
            
                // Edit Profile, Orders, Change Password, etc.
                Column(
                  children: [
                    _buildListTile(
                      title: "Edit Profile",
                      subtitle: "Change profile picture, name, email",
                      icon: AppImages.profile,
                      onTap: () => Get.to(() => EditProfileView()),
                    ),
                    _buildListTile(
                      title: "My Orders",
                      subtitle: "View your order history",
                      icon: AppImages.order,
                      onTap: () => Get.to(() => MyOrdersView()),
                    ),
                    _buildListTile(
                      title: "Saved",
                      subtitle: "Products you liked",
                      leadingIcon: Icons.favorite_outline_rounded,
                      onTap: () => Get.to(() => const FavoritesView()),
                    ),
                    _buildListTile(
                      title: "Change Password",
                      subtitle: "Update your account password",
                      icon: AppImages.password,
                      onTap: () => Get.to(() => ChangePasswordView()),
                    ),
                    _buildListTile(
                      title: "Terms & Conditions",
                      subtitle: "Understand the terms and conditions",
                      icon: AppImages.folder,
                      onTap: () => Get.to(() => TermsConditionsView()),
                    ),
                    _buildListTile(
                      title: "Privacy & Policy",
                      subtitle: "Understand the privacy policy",
                      icon: AppImages.policy,
                      onTap: () => Get.to(() => PrivacyPolicyView()),
                    ),
                    _buildListTile(
                      title: "Delete Account",
                      subtitle: "Delete your account",
                      icon: AppImages.logout,
                      onTap: () {
                        Get.dialog(
                            Dialog(
                              child: Container(
                                height: Get.height / 2.5,
                                width: Get.width / 1.2,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: Image.asset(
                                            AppImages.logoutTag,
                                            scale: 4,
                                          )),
                                      sh20,
                                      Text(
                                        "Are you sure you want to delete your account?",
                                        style: h2.copyWith(
                                          color: AppColors.black.withValues(alpha: 0.6),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      sh10,
                                      GestureDetector(
                                        onTap: () {
                                          controller.deleteProfile();
                                        },
                                        child: Container(
                                          height: 50,
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: AppColors.red,
                                          ),
                                          child: Center(
                                            child: Text(
                                              controller.isLoading.value ? "Deleting...":  "Confirm Delete",
                                              style: h2.copyWith(color: AppColors.white),
                                            ),
                                          ),
                                        ).animate().scaleXY(
                                          begin: 0.8,
                                          end: 1.0,
                                          duration: 500.ms,
                                          curve: Curves.bounceOut,
                                        ),
                                      ),
                                      sh5,
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 50,
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: AppColors.hintColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Cancel",
                                              style: h2.copyWith(color: AppColors.white),
                                            ),
                                          ),
                                        ).animate().scaleXY(
                                          begin: 0.8,
                                          end: 1.0,
                                          duration: 500.ms,
                                          curve: Curves.bounceOut,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      },
                    ),
                    _buildListTile(
                      title: "Log Out",
                      subtitle: "Securely log out of your account",
                      icon: AppImages.logout,
                      onTap: () {
                        Get.dialog(
                          Dialog(
                            child: Container(
                              height: Get.height / 2.5,
                              width: Get.width / 1.2,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: Image.asset(
                                      AppImages.logoutTag,
                                      scale: 4,
                                    )),
                                    sh20,
                                    Text(
                                      "Are you sure you want to log out of your account?",
                                      style: h2.copyWith(
                                        color: AppColors.black.withValues(alpha: 0.6),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    sh10,
                                    GestureDetector(
                                      onTap: () {
                                        LocalStorage.removeData(key: AppConstant.token);
                                        LocalStorage.removeData(key: AppConstant.role);
                                        Get.offAll(() => ChooseRoleView());
                                      },
                                      child: Container(
                                        height: 50,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: AppColors.red,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Confirm Log Out",
                                            style: h2.copyWith(color: AppColors.white),
                                          ),
                                        ),
                                      ).animate().scaleXY(
                                        begin: 0.8,
                                        end: 1.0,
                                        duration: 500.ms,
                                        curve: Curves.bounceOut,
                                      ),
                                    ),
                                    sh5,
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: AppColors.hintColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Cancel",
                                            style: h2.copyWith(color: AppColors.white),
                                          ),
                                        ),
                                      ).animate().scaleXY(
                                        begin: 0.8,
                                        end: 1.0,
                                        duration: 500.ms,
                                        curve: Curves.bounceOut,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                      },
                    ),
                  ],
                ),
            
                sh100,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build each ListTile
  Widget _buildListTile({
    required String title,
    required String subtitle,
    String? icon,
    IconData? leadingIcon,
    required Function onTap,
  }) {
    assert(leadingIcon != null || icon != null);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          onTap: () => onTap(),
          leading: leadingIcon != null
              ? Icon(leadingIcon, color: AppColors.mainColor, size: 26)
              : Image.asset(icon!, scale: 4, color: AppColors.mainColor),
          trailing: Icon(Icons.arrow_forward_ios),
          title: Text(title, style: h2),
          subtitle: Text(subtitle, style: h3.copyWith(color: AppColors.gray, fontSize: 12)),
        ),
      ).animate().fadeIn(
        duration: 600.ms,
        delay: 100.ms,
        curve: Curves.easeInOut,
      ).slideY(
        begin: 0.3,
        end: 0.0,
        duration: 600.ms,
        delay: 100.ms,
        curve: Curves.easeInOut,
      ).shake(
        duration: 800.ms,
        delay: 100.ms,
        hz: 2,
        rotation: 0.05,
      ),
    );
  }
}
