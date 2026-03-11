import 'package:flutter/material.dart';

class RingkasanWidget extends StatelessWidget {
  final String ringkasan;

  const RingkasanWidget({super.key, required this.ringkasan});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 388,
          height: 120,
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
                  Container(
                    child: Image.asset('assets/icons/detail_plant/ringkas.png',width: 24, height: 24,),
                  ),
                  SizedBox(
                    width: 116,
                    child: Text(
                      'Ringkasan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF508C1D),
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800,
                        height: 1.20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16,),
              SizedBox(
                width: 348,
                child: Text(
                  ringkasan, // <-- value dari Supabase
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: const Color(0xFF383838),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
