
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset(AppImages.logo,scale: 2,),);
  }
}
