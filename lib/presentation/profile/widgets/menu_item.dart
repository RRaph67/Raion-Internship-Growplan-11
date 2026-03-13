import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final Widget iconWidget;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? trailingColor;

  const MenuItem({
    super.key,
    required this.iconWidget,
    required this.title,
    required this.onTap,
    this.titleColor,
    this.trailingColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: iconWidget,
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? const Color(0xFF4E4E4E),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: trailingColor ?? const Color(0xFF4E4E4E),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
