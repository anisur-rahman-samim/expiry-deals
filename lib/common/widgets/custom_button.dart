import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_color/app_colors.dart';
import '../app_text_style/styles.dart';

class CustomCenterButton extends StatelessWidget {
  final String title;
  final double width;

  final Color? bgColor;
  final Color? textColor;
  final bool? isArrow;
  final Function()? onTap;
  const CustomCenterButton({
    super.key,
    required this.title,
    required this.width,
     this.isArrow = false,

     this.bgColor,
     this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 43,
        width: width,
       
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xff0F1A2E),
                  borderRadius: BorderRadius.circular(8),
                ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text(title,style: h3.copyWith(color: textColor ?? AppColors.white),),
        ),
      ),
    );
  }
}