import 'package:flutter/material.dart';

class PanduanWidget extends StatelessWidget {
  final List<String> panduan;

  const PanduanWidget({super.key, required this.panduan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 388,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFE2E2E2)),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 24, height: 24),
              SizedBox(
                width: 165,
                child: Text(
                  'Panduan Tanam',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFE6B400),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Looping isi array panduan dari DB
          for (int i = 0; i < panduan.length; i++)
            _buildStep(i + 1, panduan[i]),
        ],
      ),
    );
  }

  Widget _buildStep(int stepNumber, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: ShapeDecoration(
        color: const Color(0xFFFFFAE6),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFFFEEB0)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEB0),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              stepNumber.toString(),
              style: TextStyle(
                color: const Color(0xFFE6B400),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: const Color(0xFF383838), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
