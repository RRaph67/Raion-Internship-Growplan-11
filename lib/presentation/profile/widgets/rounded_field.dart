import 'package:flutter/material.dart';

class RoundedField extends StatelessWidget {
  final TextEditingController controller;

  const RoundedField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF25410E), width: 1),
        borderRadius: BorderRadius.circular(28),
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        style: const TextStyle(
          color: Color(0xFF6ABA27),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
