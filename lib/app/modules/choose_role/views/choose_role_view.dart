// app/modules/choose_role/views/choose_role_view.dart
import 'package:expiry_deals/app/modules/auth/views/login_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_sizes/app_sizes.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseRoleView extends StatelessWidget {
  const ChooseRoleView({super.key});

  @override
  Widget build(BuildContext context) {
    final topHeight = MediaQuery.sizeOf(context).height * 0.4;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topHeight,
            child: ColoredBox(
              color: AppColors.mainColor,
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SvgPicture.asset(
                        AppImages.logoWordmarkWhiteSvg,
                        height: 120,
                        fit: BoxFit.contain,
                        // SVG uses CSS class fills; flutter_svg may skip them (paths default to black).
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: topHeight - 22,
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSizes.paddingLarge,
                    28,
                    AppSizes.paddingLarge,
                    16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'How would you like to use Expiry Deals?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Choose your role to get started',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.hintColor,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _RoleChoiceTile(
                        title: 'Customer',
                        subtitle: 'Browse deals and save money',
                        filled: true,
                        icon: Icons.shopping_bag_rounded,
                        onTap: () {
                          LocalStorage.saveData(key: AppConstant.role, data: 'User');
                          Get.to(() => LoginView());
                        },
                      ),
                      const SizedBox(height: 14),
                      _RoleChoiceTile(
                        title: 'Vendor',
                        subtitle: 'List products and grow your business',
                        filled: false,
                        icon: Icons.storefront_rounded,
                        onTap: () {
                          LocalStorage.saveData(key: AppConstant.role, data: 'Vendor');
                          Get.to(() => LoginView(isVendor: true));
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleChoiceTile extends StatelessWidget {
  const _RoleChoiceTile({
    required this.title,
    required this.subtitle,
    required this.filled,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool filled;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return Material(
      color: filled ? AppColors.mainColor : AppColors.white,
      elevation: filled ? 4 : 0,
      shadowColor: AppColors.mainColor.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: filled
            ? BorderSide.none
            : BorderSide(color: AppColors.mainColor, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: filled
                      ? Colors.white.withValues(alpha: 0.2)
                      : AppColors.mainColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 26,
                  color: filled ? Colors.white : AppColors.mainColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: filled ? Colors.white : AppColors.mainColor,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: filled
                            ? Colors.white.withValues(alpha: 0.88)
                            : AppColors.hintColor,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
