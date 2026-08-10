import 'package:expiry_deals/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

/// Full-screen profile photo with pinch-zoom; change photo opens Edit Profile.
class ProfilePhotoPreviewView extends StatelessWidget {
  const ProfilePhotoPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final pc = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('Profile photo', style: h2.copyWith(color: Colors.white, fontSize: 18)),
        centerTitle: true,
      ),
      body: Obx(() {
        final url = pc.profileData.value.data?.profile;
        final imageUrl =
            (url != null && url.isNotEmpty) ? url : AppImages.noImage;

        return Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Padding(
                        padding: EdgeInsets.all(48),
                        child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Image.network(
                      AppImages.noImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Pinch to zoom.',
                      textAlign: TextAlign.center,
                      style: h4.copyWith(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.mainColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        await Get.to(() => EditProfileView());
                        await pc.fetchProfile();
                      },
                      child: Text(
                        'Change photo',
                        style: h4.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
