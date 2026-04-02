import 'dart:async';

import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Compact live countdown for “ending soon” tiles (updates every second).
class ExpiryCountdownBar extends StatefulWidget {
  const ExpiryCountdownBar({
    super.key,
    required this.expiresAt,
  });

  final DateTime expiresAt;

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

  String _format(Duration d) {
    if (d.isNegative) return 'Ended';
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) {
      return '${h}h ${m.toString().padLeft(2, '0')}m ${s.toString().padLeft(2, '0')}s';
    }
    if (m > 0) {
      return '${m}m ${s.toString().padLeft(2, '0')}s';
    }
    return '${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final left = widget.expiresAt.difference(now);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.62),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 13,
            color: left.isNegative ? Colors.white70 : Colors.amberAccent,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              left.isNegative ? 'Ended' : 'Ends in ${_format(left)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
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
