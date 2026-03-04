import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  final Widget buttonContent; // Ubah dari String ke Widget
  final VoidCallback? onPressed; // Pastikan nullable (?)
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;

  const ButtonCustom({
    super.key,
    required this.buttonContent,
    this.onPressed,
    this.backgroundColor = const Color(0xFF508C1D), // Sesuaikan warna
    this.textColor = Colors.white,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Bisa null
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      child: buttonContent, // Bisa Text atau SizedBox (Loading)
    );
  }
}
