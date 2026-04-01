import 'package:expiry_deals/app/modules/change_password/views/change_password_view.dart';
import 'package:expiry_deals/app/modules/choose_role/views/choose_role_view.dart';
import 'package:expiry_deals/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:expiry_deals/app/modules/privacy_policy/views/privacy_policy_view.dart';
import 'package:expiry_deals/app/modules/profile/controllers/profile_controller.dart';
import 'package:expiry_deals/app/modules/terms_conditions/views/terms_conditions_view.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_profile/views/bank_details_view.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_profile/views/edit_shop_view.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_profile/views/withdraw_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/app/modules/profile/model/profile_model.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VendorProfileView extends GetView {
   VendorProfileView({super.key});

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
          child: Column(
            children: [
              /// Profile Image & Name
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final user = controller.profileData.value.data;
                // Observe shop banner fields so header updates after fetchProfile / Edit Shop.
                final bannerUrl = controller.vendorShopBannerUrl.value;
                final bannerColorHex = controller.vendorShopBannerColor.value;
                return Column(
                  children: [
                    if (_vendorHasBannerStrip(bannerUrl, bannerColorHex))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _vendorBannerStrip(
                            controller,
                            user,
                            bannerUrl,
                            bannerColorHex,
                          ),
                        ),
                      ),
                    // Prefer shop logo (Edit Shop); fallback to user profile photo.
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        _vendorHeaderImageUrl(controller, user),
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
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        Get.to(() => EditProfileView());
                      },
                      leading: Image.asset(AppImages.profile, scale: 4,color: AppColors.mainColor,),
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text(
                          "Edit Profile",
                          style: h2
                      ),
                      subtitle: Text(
                        "Change profile picture, number",
                        style: h3.copyWith(color: AppColors.gray, fontSize: 12),
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
                  ),

                  sh16,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        Get.to(() => EditShopView())?.then((_) {
                          controller.fetchProfile();
                        });
                      },
                      leading: Image.asset(AppImages.profile, scale: 4,color: AppColors.mainColor,),
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text(
                          "Edit Shop",
                          style: h2
                      ),
                      subtitle: Text(
                        "Change shop picture, number, email",
                        style: h3.copyWith(color: AppColors.gray, fontSize: 12),
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
                  ),

  sh16,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        Get.to(() => BankDetailsView());
                      },
                      leading: Image.asset(AppImages.profile, scale: 4,color: AppColors.mainColor,),
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text(
                          "Bank Details",
                          style: h2
                      ),
                      subtitle: Text(
                        "Setup your bank information",
                        style: h3.copyWith(color: AppColors.gray, fontSize: 12),
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
                  ),

                  sh16,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        Get.to(() => WithdrawalView());
                      },
                      leading: Image.asset(AppImages.profile, scale: 4,color: AppColors.mainColor,),
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text(
                          "Withdraw",
                          style: h2
                      ),
                      subtitle: Text(
                        "Withdraw your payments",
                        style: h3.copyWith(color: AppColors.gray, fontSize: 12),
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
                  ),

                  sh16,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(

                      onTap: () {
                        Get.to(() => ChangePasswordView());
                      },
                      leading: Image.asset(AppImages.password, scale: 4,color: AppColors.mainColor),
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text(
                          "Change Password",
                          style: h2
                      ),
                      subtitle: Text(
                        "Update and strengthen account security",
                        style: h3.copyWith(color: AppColors.gray, fontSize: 12),
                      ),
                    ).animate().fadeIn(
                      duration: 600.ms,
                      delay: 200.ms,
                      curve: Curves.easeInOut,
                    ).slideY(
                      begin: 0.3,
                      end: 0.0,
                      duration: 600.ms,
                      delay: 200.ms,
                      curve: Curves.easeInOut,
                    ).shake(
                      duration: 800.ms,
                      delay: 200.ms,
                      hz: 2,
                      rotation: 0.05,
                    ),
                  ),
                  sh16,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        Get.to(() => TermsConditionsView());
                      },
                      leading: Image.asset(AppImages.folder, scale: 4,color: AppColors.mainColor),
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text(
                          "Terms and conditions",
                          style: h2
                      ),
                      subtitle: Text(
                        "Understand the rules and responsibilities",
                        style: h3.copyWith(color: AppColors.gray, fontSize: 12),
                      ),
                    ).animate().fadeIn(
                      duration: 600.ms,
                      delay: 300.ms,
                      curve: Curves.easeInOut,
                    ).slideY(
                      begin: 0.3,
                      end: 0.0,
                      duration: 600.ms,
                      delay: 300.ms,
                      curve: Curves.easeInOut,
                    ).shake(
                      duration: 800.ms,
                      delay: 300.ms,
                      hz: 2,
                      rotation: 0.05,
                    ),
                  ),
                  sh16,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        Get.to(() => PrivacyPolicyView());
                      },
                      leading: Image.asset(AppImages.policy, scale: 4,color: AppColors.mainColor),
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text(
                          "Privacy and Policy",
                          style: h2
                      ),
                      subtitle: Text(
                        "Learn how your data is collected",
                        style: h3.copyWith(color: AppColors.gray, fontSize: 12),
                      ),
                    ).animate().fadeIn(
                      duration: 600.ms,
                      delay: 400.ms,
                      curve: Curves.easeInOut,
                    ).slideY(
                      begin: 0.3,
                      end: 0.0,
                      duration: 600.ms,
                      delay: 400.ms,
                      curve: Curves.easeInOut,
                    ).shake(
                      duration: 800.ms,
                      delay: 400.ms,
                      hz: 2,
                      rotation: 0.05,
                    ),
                  ),
                  sh16,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
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
                                      child: Image.asset(AppImages.logoutTag, scale: 4),
                                    ),
                                    sh20,
                                    Text(
                                      "Are you sure you want to log out of your account?",
                                      style: h2.copyWith(color: AppColors.black.withValues(alpha: 0.6),),
                                      textAlign: TextAlign.center,
                                    ),
                                    sh10,
                                    GestureDetector(
                                      onTap: () {
                                        LocalStorage.removeData(key: AppConstant.token);
                                        Get.to(() => ChooseRoleView());
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
                          ),
                        );
                      },
                      leading: Image.asset(AppImages.logout, scale: 4),
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text(
                        "Log Out",
                        style: h2.copyWith(color: AppColors.secColor),
                      ),
                      subtitle: Text(
                        "Securely log out Account",
                        style: h3.copyWith(color: AppColors.gray, fontSize: 12),
                      ),
                    ).animate().fadeIn(
                      duration: 600.ms,
                      delay: 500.ms,
                      curve: Curves.easeInOut,
                    ).slideY(
                      begin: 0.3,
                      end: 0.0,
                      duration: 600.ms,
                      delay: 500.ms,
                      curve: Curves.easeInOut,
                    ).shake(
                      duration: 800.ms,
                      delay: 500.ms,
                      hz: 2,
                      rotation: 0.05,
                    ),
                  ),
                  sh50,
                  sh50,
                  sh50,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vendor profile header: show **shop logo** when loaded; else user profile photo. Cache-bust so new uploads show after Edit Shop.
String _vendorHeaderImageUrl(ProfileController c, Data? user) {
  final shopLogo = c.vendorShopLogoUrl.value;
  final profilePic = user?.profile;
  final base = (shopLogo != null && shopLogo.isNotEmpty)
      ? shopLogo
      : (profilePic ?? AppImages.noImage);
  return _vendorCacheBustedUrl(base, c.vendorShopLogoTimestamp ?? user?.updatedAt);
}

bool _vendorHasBannerStrip(String? bannerUrl, String? bannerColorHex) {
  final u = bannerUrl?.trim() ?? '';
  final c = bannerColorHex?.trim() ?? '';
  return u.isNotEmpty || c.isNotEmpty;
}

/// Wide banner from Edit Shop (`banner` / `bannerColor` on my-shop).
Widget _vendorBannerStrip(
  ProfileController c,
  Data? user,
  String? bannerUrl,
  String? bannerColorHex,
) {
  final u = bannerUrl?.trim() ?? '';
  if (u.isNotEmpty) {
    final src = _vendorCacheBustedUrl(u, c.vendorShopLogoTimestamp ?? user?.updatedAt);
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.network(
        src,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _vendorBannerColorFallback(bannerColorHex),
      ),
    );
  }
  return _vendorBannerColorFallback(bannerColorHex);
}

Widget _vendorBannerColorFallback(String? bannerColorHex) {
  final color = _parseBannerColorHex(bannerColorHex);
  return Container(
    height: 100,
    width: double.infinity,
    alignment: Alignment.center,
    color: color ?? AppColors.mainColor.withValues(alpha: 0.15),
    child: color == null
        ? Icon(Icons.storefront_outlined, size: 40, color: Colors.grey.shade600)
        : null,
  );
}

Color? _parseBannerColorHex(String? raw) {
  if (raw == null) return null;
  var hex = raw.trim();
  if (hex.isEmpty) return null;
  if (hex.startsWith('#')) hex = hex.substring(1);
  if (hex.length == 6) {
    return Color(int.parse('FF$hex', radix: 16));
  }
  if (hex.length == 8) {
    return Color(int.parse(hex, radix: 16));
  }
  return null;
}

String _vendorCacheBustedUrl(String base, DateTime? updatedAt) {
  if (!base.startsWith('http')) return base;
  final ms = updatedAt?.millisecondsSinceEpoch ?? 0;
  return base.contains('?') ? '$base&cb=$ms' : '$base?cb=$ms';
}