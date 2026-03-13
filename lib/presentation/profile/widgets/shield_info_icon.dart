import 'package:flutter/material.dart';

class ShieldInfoIcon extends StatelessWidget {
  const ShieldInfoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: const [
        Icon(Icons.shield, color: Color(0xFF4E4E4E), size: 22),
        Text(
          'i',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
