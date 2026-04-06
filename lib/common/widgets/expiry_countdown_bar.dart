import 'dart:async';

import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Live countdown (updates every second). Use [dense] for home strip tiles; [dense]: false for detail.
class ExpiryCountdownBar extends StatefulWidget {
  const ExpiryCountdownBar({
    super.key,
    required this.expiresAt,
    this.dense = true,
  });

  final DateTime expiresAt;
  final bool dense;

  @override
  State<ExpiryCountdownBar> createState() => _ExpiryCountdownBarState();
}

class _ExpiryCountdownBarState extends State<ExpiryCountdownBar> {
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  /// Includes seconds so the bar visibly ticks every second.
  String _formatRemaining(Duration d) {
    if (d.isNegative) return '';
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) {
      return '${h}h ${m}m ${s}s left';
    }
    if (m > 0) {
      return '${m}m ${s}s left';
    }
    return '${s}s left';
  }

  static const Color _expiredGrey = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final left = widget.expiresAt.difference(now);
    final expired = left.isNegative;
    final urgent = !expired && left < const Duration(hours: 1);

    final padH = widget.dense ? 8.0 : 14.0;
    final padV = widget.dense ? 5.0 : 12.0;
    final iconSize = widget.dense ? 13.0 : 18.0;
    final fontSize = widget.dense ? 10.0 : 15.0;

    if (expired) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule_rounded,
              size: iconSize,
              color: _expiredGrey,
            ),
            SizedBox(width: widget.dense ? 5 : 8),
            Text(
              'Expired',
              style: GoogleFonts.dmSans(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: _expiredGrey,
                height: 1.1,
              ),
            ),
          ],
        ),
      );
    }

    final barColor = urgent
        ? AppColors.red.withValues(alpha: 0.92)
        : Colors.black.withValues(alpha: 0.62);
    final accentColor = urgent ? Colors.white : Colors.amberAccent;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      decoration: BoxDecoration(
        color: barColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule_rounded,
            size: iconSize,
            color: accentColor,
          ),
          SizedBox(width: widget.dense ? 5 : 8),
          Flexible(
            child: Text(
              _formatRemaining(left),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmSans(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
