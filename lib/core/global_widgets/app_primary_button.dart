import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  final double? radius;
  final Color? bgColor;
  final Color? border;
  final Color? textColor;
  final double? fontSize;
  final double? height;
  final double? width;
  final FontWeight? fontWeight;

  const AppPrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.bgColor,
    this.border,
    this.textColor,
    this.radius,
    this.fontSize,
    this.height,
    this.width,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius ?? 30),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height ?? 60,
          width: width ?? double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 30),
            color: bgColor ?? Colors.white,
            border: border != null ? Border.all(color: border!) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon( icon, size: 22, color: Colors.white),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize ?? 16,
                    fontWeight: fontWeight ?? FontWeight.w600,
                    color: textColor ?? Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
