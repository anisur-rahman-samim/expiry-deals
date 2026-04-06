// common/widgets/custom_center_button.dart
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:flutter/material.dart';

// Paste this updated version
class CustomCenterButton extends StatelessWidget {
  final String title;
  final double width;
  final Color? bgColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const CustomCenterButton({
    super.key,
    required this.title,
    required this.width,
    this.bgColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWhite = bgColor == Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: isWhite
              ? null
              : LinearGradient(
                  colors: [AppColors.mainColor, AppColors.secColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: isWhite ? Colors.white : null,
          border: isWhite ? Border.all(color: AppColors.mainColor, width: 2) : null,
          boxShadow: isWhite
              ? null
              : [
            BoxShadow(
              color: AppColors.mainColor.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          title,
          style: h2.copyWith(
            color: textColor ?? (isWhite ? AppColors.mainColor : Colors.white),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}