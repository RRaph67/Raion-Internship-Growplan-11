import 'package:flutter/material.dart';

class FaqIcon extends StatelessWidget {
  const FaqIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Color(0xFF4E4E4E),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
