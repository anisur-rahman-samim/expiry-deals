// onboarding_view.dart
import 'package:expiry_deals/app/modules/choose_role/views/choose_role_view.dart';
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
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  static final List<Map<String, String>> pages = [
    {
      "image": AppImages.onboarding1,
      "title": "Turn Near-Expiry\nProducts into Sales!",
      "desc": "Use our map view to find stores and products near you, or browse by categories."
    },
    {
      "image": AppImages.onboarding2,
      "title": "Turn Near-Expiry\nProducts into Sales!",
      "desc": "Use our map view to find stores and products near you, or browse by categories."
    },
    {
      "image": AppImages.onboarding3,
      "title": "Turn Near-Expiry\nProducts into Sales!",
      "desc": "Use our map view to find stores and products near you, or browse by categories."
    },
  ];

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());
    final PageController pageController = PageController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: pageController,
            itemCount: pages.length,
            onPageChanged: (i) => controller.currentIndex.value = i,
            itemBuilder: (_, index) {
              final page = pages[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal:AppSizes.paddingLarge),
                child: Column(
                  children: [
                    sh50,
                    Expanded(
                      child: Image.asset(
                        page["image"]!,
                        fit: BoxFit.contain,
                      ),
                    ),

                    sh50,

                    // Title
                    Text(
                      page["title"]!,
                      textAlign: TextAlign.center,
                      style: h1.copyWith(
                        fontSize: 28,
                        height: 1.2,
                      ),
                    ),

                    sh20,

                    // Description
                    Text(
                      page["desc"]!,
                      textAlign: TextAlign.center,
                      style: h4.copyWith(
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),

                    sh100,
                    sh100,
                    sh30,
                  ],
                ),
              );
            },
          ),
          // Indicator + Button
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Smooth Indicator
                SmoothPageIndicator(
                  controller: pageController,
                  count: pages.length,
                  effect: WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 12,
                    activeDotColor: AppColors.mainColor,
                    dotColor: Colors.grey.shade300,
                  ),
                ),

                sh50,

                // Get Started Button (Only on last page)
                Obx(
                      () => AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: controller.currentIndex.value == 2 ? 1.0 : 1.0,
                    child:  Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
                      child: CustomCenterButton(
                        title: controller.currentIndex.value < 2? "Continue" :"Get Started",
                        width: double.infinity,
                        textColor: Colors.white,
                        onTap: () {
                          if (controller.currentIndex.value < 2) {
                            // Go to next page
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            // Last page → Go to Choose Role
                            LocalStorage.saveData(key: AppConstant.onboarding, data: "onboarding");
                            Get.offAll(() => const ChooseRoleView());
                          }
                        },
                      ),
                    )
                       // Keep space
                  ),

                ),
                // Skip Button (only show on first two pages)
                Obx(() => controller.currentIndex.value < 2
                    ? TextButton(
                  onPressed: () {
                    LocalStorage.saveData(key: AppConstant.onboarding, data: "onboarding");
                    Get.offAll(() => const ChooseRoleView());
                  },
                  child: Text(
                    "Skip",
                    style: h3.copyWith(color: Colors.black54),
                  ),
                )
                    : TextButton(onPressed: (){}, child: Text(""))), // Keep spacing consistent
              ],
            ),
          ),
        ],
      ),
    );
  }
}