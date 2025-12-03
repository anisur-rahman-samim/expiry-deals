// app/modules/auth/forget/views/forget_view.dart
import 'package:expiry_deals/app/modules/auth/views/login_view.dart';
import 'package:expiry_deals/app/modules/auth/views/signup_view.dart';
import 'package:expiry_deals/app/modules/forget/views/reset_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_sizes/app_sizes.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class VerifyView extends StatefulWidget {
  final bool? isSignUp;
  const VerifyView({super.key, required this.isSignUp});

  @override
  State<VerifyView> createState() => _VerifyViewState();
}

class _VerifyViewState extends State<VerifyView> {
  final TextEditingController pinController = TextEditingController();
  int countdown = 60;
  bool canResend = false;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && countdown > 0) {
        setState(() => countdown--);
        startTimer();
      } else if (mounted) {
        setState(() => canResend = true);
      }
    });
  }

  void resendCode() {
    if (!canResend) return;
    setState(() {
      countdown = 60;
      canResend = false;
    });
    startTimer();
    // TODO: Call your resend API here
    Get.snackbar("Success", "Verification code sent!");
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade300),
    ),
  );

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
            // Orange Gradient Header with Curved Bottom
            Stack(
              children: [
                Container(
                  height: height * 0.40,
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
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                    ),
                  ),
                ),
                // Header Content
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: Column(
                      children: [
                        sh50,
                        Image.asset(AppImages.logoWhite, height: 80),
                        sh40,
                        Text(
                          "Confirm It’s Really You.",
                          textAlign: TextAlign.center,
                          style: h1.copyWith(color: AppColors.white, fontSize: 30),
                        ),
                        sh16,
                        Text(
                            "Enter the 6-digit code sent to your email.",
                            textAlign: TextAlign.center,
                            style: h2.copyWith(color: AppColors.white, fontSize: 14)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            sh40,

            // Main Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Column(
                children: [
                  // Pinput Field
                  Pinput(
                    controller: pinController,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: AppColors.mainColor, width: 2),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: Colors.grey[200],
                        border: Border.all(color: AppColors.mainColor),
                      ),
                    ),
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    cursor: Container(width: 2, color: AppColors.mainColor),
                    onCompleted: (pin) {
                      // Auto submit when 6 digits entered
                      //  Get.toNamed('/reset-password');
                    },
                  ),

                  sh50,

                  // Verify Button
                  CustomCenterButton(
                    title: "Verify Email",
                    width: double.infinity,
                    onTap: () {
                      if (pinController.text.length == 6) {
                        kSnackBar(message: "OTP Verify Successfully", bgColor: AppColors.green);
                        if(widget.isSignUp == true){
                          Get.to(() => LoginView());
                        }else{
                          Get.to(() => ResetView());
                        }


                      } else {

                        Get.showSnackbar(
                          GetSnackBar(
                            title: "Error",
                            message: "Please enter 6-digit code",
                            duration: Duration(seconds: 2),
                          ),
                        );

                      }
                    },
                  ),

                  sh30,

                  // Resend Code
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: h4.copyWith(color: Colors.black54),
                        children: [
                          const TextSpan(text: "Didn’t get code? "),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: canResend ? resendCode : null,
                              child: Text(
                                canResend ? "Resend" : "Resend in $countdown",
                                style: h4.copyWith(
                                  color: canResend
                                      ? AppColors.mainColor
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  sh100,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }
}