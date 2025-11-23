import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomTextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double fontSize;
  final TextAlign textAlign;
  final int maxLines;

  const CustomTextWidget({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 14.0,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.nunito(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }
}
