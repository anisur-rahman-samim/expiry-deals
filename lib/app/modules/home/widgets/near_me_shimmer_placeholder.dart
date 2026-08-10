import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:flutter/material.dart';

/// Lightweight loading placeholder for Near Me (map strip + card strip).
class NearMeShimmerPlaceholder extends StatefulWidget {
  const NearMeShimmerPlaceholder({super.key});

  @override
  State<NearMeShimmerPlaceholder> createState() =>
      _NearMeShimmerPlaceholderState();
}

class _NearMeShimmerPlaceholderState extends State<NearMeShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = 0.35 + _c.value * 0.35;
        final base = Color.lerp(AppColors.grayLight, AppColors.white, t)!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => Container(
                  width: 260,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
