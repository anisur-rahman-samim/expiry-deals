import 'package:expiry_deals/app/modules/profile/controllers/contents_controller.dart';
import 'package:expiry_deals/app/modules/terms_conditions/controllers/terms_conditions_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';  // Import the flutter_html package
import 'package:get/get.dart';

class TermsConditionsView extends GetView<ContentsController> {
  const TermsConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ContentsController());
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        title: Text('Terms and Conditions', style: h2.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // If content is not available or empty
          if (controller.contentData.value?.termsAndConditions == null ||
              controller.contentData.value!.termsAndConditions!.isEmpty) {
            return Center(child: Text("No content available", style: h3));
          }

          // Use FlutterHtml to render HTML content
          return SingleChildScrollView(
            child: Html(
              data: controller.contentData.value!.termsAndConditions!,
              style: {
                // You can define custom styles for HTML content here
                "p": Style(
                  fontSize: FontSize(14),
                  lineHeight: LineHeight(1.6),
                ),
                "h3": Style(
                  fontSize: FontSize(18),
                  fontWeight: FontWeight.bold,
                ),
              },
            ),
          );
        }),
      ),
    );
  }
}
