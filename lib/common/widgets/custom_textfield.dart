// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app_color/app_colors.dart';
import '../app_text_style/styles.dart';

class CustomTextField extends StatefulWidget {

  final double width;
  final double? horizontalPadding;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? preIcon;
  final int? maxLines;
  final bool obscureText;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.width,
    this.hintText,
    this.controller,
    this.horizontalPadding,
    this.preIcon,
    this.maxLines,
    this.obscureText = false,
    this.enabled = true,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText; // Local state to manage obscureText

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText; // Initialize with widget.obscureText
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.maxLines == 3 ? 100 : 45,
      width: widget.width,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grayLight)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          controller: widget.controller,
          obscureText: _obscureText,

          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: widget.obscureText
                ? GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText; // Toggle obscureText
                });
              },
              child: Icon(
                _obscureText
                    ? CupertinoIcons.eye
                    : CupertinoIcons.eye_slash,
                color: AppColors.black.withValues(alpha: 0.7),


              ),
            )
                : null, // Only show suffixIcon for obscureText fields
            prefixIcon: widget.preIcon,
            hintText: widget.hintText,
            hintStyle:  h3.copyWith(color: AppColors.black.withValues(alpha: 0.5),)
          ),
          maxLines: widget.maxLines ?? 1,
          style: h3,
          enabled: widget.enabled,
        ),
      ),
    );
  }
}
