import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// iOS-style activity indicator on iOS; Material circular elsewhere (min touch rules via parent).
class AdaptiveLoading extends StatelessWidget {
  const AdaptiveLoading({super.key, this.radius = 14, this.color});

  final double radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.mainColor;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoActivityIndicator(radius: radius, color: c);
    }
    return CircularProgressIndicator(color: c, strokeWidth: 2.5);
  }
}
