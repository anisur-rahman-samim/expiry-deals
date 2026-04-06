// onboarding_view.dart
import 'package:expiry_deals/app/modules/choose_role/views/choose_role_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/app_sizes/app_sizes.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  static final List<({IconData icon, String title, String subtitle})> _slides = [
    (
      icon: Icons.shopping_cart_rounded,
      title: 'Discover Local Deals',
      subtitle: 'Find massive discounts from stores near you.',
    ),
    (
      icon: Icons.timer_outlined,
      title: "Grab Before It's Gone",
      subtitle: "Time-limited deals that won't last long.",
    ),
    (
      icon: Icons.location_on_rounded,
      title: 'Pick Up Nearby',
      subtitle: 'Save money on products just around the corner.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());
    final PageController pageController = PageController();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: _slides.length,
            onPageChanged: (i) => controller.currentIndex.value = i,
            itemBuilder: (_, index) {
              final slide = _slides[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    Icon(
                      slide.icon,
                      size: 120,
                      color: AppColors.mainColor,
                    ),
                    sh30,
                    Text(
                      slide.title,
                      textAlign: TextAlign.center,
                      style: h1.copyWith(
                        fontSize: 26,
                        height: 1.2,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    sh16,
                    Text(
                      slide.subtitle,
                      textAlign: TextAlign.center,
                      style: h4.copyWith(
                        color: Colors.black54,
                        height: 1.5,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(flex: 3),
                    sh100,
                    sh100,
                    sh30,
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: _slides.length,
                  effect: WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 12,
                    activeDotColor: AppColors.mainColor,
                    dotColor: Colors.grey.shade300,
                  ),
                ),
                sh50,
                Obx(
                  () => Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
                    child: CustomCenterButton(
                      title: controller.currentIndex.value < 2
                          ? 'Continue'
                          : 'Get Started',
                      width: double.infinity,
                      textColor: Colors.white,
                      onTap: () {
                        if (controller.currentIndex.value < 2) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          LocalStorage.saveData(
                            key: AppConstant.onboarding,
                            data: 'onboarding',
                          );
                          Get.offAll(() => const ChooseRoleView());
                        }
                      },
                    ),
                  ),
                ),
                Obx(
                  () => controller.currentIndex.value < 2
                      ? TextButton(
                          onPressed: () {
                            LocalStorage.saveData(
                              key: AppConstant.onboarding,
                              data: 'onboarding',
                            );
                            Get.offAll(() => const ChooseRoleView());
                          },
                          child: Text(
                            'Skip',
                            style: h3.copyWith(color: Colors.black54),
                          ),
                        )
                      : const SizedBox(height: 48),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
