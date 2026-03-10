import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isObscured;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const CustomField({
    super.key,
    required this.controller,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.isObscured = false,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: isObscured,
      // ✅ STYLE UNTUK INPUT USER (Hitam, Font 12)
      style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        // ✅ STYLE UNTUK HINT (Hijau, Font 12)
        hintStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6ABA27),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Color(0xFF6ABA27), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Color(0xFF6ABA27), width: 1),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
