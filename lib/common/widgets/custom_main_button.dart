import 'package:flutter/material.dart';

import '../app_color/app_colors.dart';
import '../app_text_style/styles.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final double width;

  final Color? borderColor;
  final Color? textColor;
  final bool? isArrow;
  final Function()? onTap;
  const CustomButton({
    super.key,
    required this.title,
    required this.width,
     this.isArrow = false,

     this.borderColor,
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
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF22C55E),
                      Color(0xFF145880),


                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(34),
                ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,style: h3.copyWith(color: textColor ?? AppColors.white),),
              isArrow == true?   Icon(Icons.arrow_forward,color: AppColors.white,) : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}