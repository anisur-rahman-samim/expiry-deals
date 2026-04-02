import 'dart:async';

import 'package:expiry_deals/app/modules/browse/controllers/browse_controller.dart';
import 'package:expiry_deals/app/modules/home/controllers/near_me_stores_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/helper/search_radius_miles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// iOS-style bottom sheet to set search radius (miles), saves, and refreshes shop lists.
void showSearchRadiusDialog(NearMeStoresController c) {
  final ctx = Get.context;
  if (ctx == null) return;

  double d = SearchRadiusMiles.get();

  showModalBottomSheet<void>(
    context: ctx,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(ctx).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          final bottom = MediaQuery.paddingOf(context).bottom;
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, bottom + 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Search radius',
                  style: h2.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Drag to set how far to search. Smaller areas usually load faster.',
                  style: h4.copyWith(
                    color: AppColors.hintColor,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${SearchRadiusMiles.minMiles.toStringAsFixed(0)} mi',
                      style: h4.copyWith(
                        color: AppColors.hintColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${SearchRadiusMiles.maxMiles.toStringAsFixed(0)} mi',
                      style: h4.copyWith(
                        color: AppColors.hintColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: d.clamp(
                    SearchRadiusMiles.minMiles,
                    SearchRadiusMiles.maxMiles,
                  ),
                  min: SearchRadiusMiles.minMiles,
                  max: SearchRadiusMiles.maxMiles,
                  label: '${d.round()} mi',
                  onChanged: (v) => setState(() => d = v),
                ),
                Center(
                  child: Text(
                    '${d.round()} miles',
                    style: h3.copyWith(
                      color: AppColors.mainColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        style: TextButton.styleFrom(
                          minimumSize: const Size(0, 48),
                        ),
                        child: Text(
                          'Cancel',
                          style: h4.copyWith(
                            color: AppColors.hintColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          final miles = d.roundToDouble();
                          Navigator.of(sheetContext).pop();
                          unawaited(() async {
                            await c.applySearchRadiusMiles(miles);
                            if (Get.isRegistered<BrowseController>()) {
                              await Get.find<BrowseController>().refreshAll();
                            }
                          }());
                        },
                        child: Text(
                          'Apply',
                          style: h4.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

/// Compact control showing current radius; tap to change (min ~44pt touch target on iOS).
class SearchRadiusMileButton extends StatelessWidget {
  const SearchRadiusMileButton({super.key, required this.controller});

  final NearMeStoresController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showSearchRadiusDialog(controller),
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.grayLight.withValues(alpha: 0.85),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.place_outlined,
                  size: 18,
                  color: AppColors.mainColor,
                ),
                const SizedBox(width: 6),
                Text(
                  '${controller.searchRadiusMiles.value.toStringAsFixed(0)} mi',
                  style: h4.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Icon(Icons.expand_more, size: 20, color: AppColors.hintColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
