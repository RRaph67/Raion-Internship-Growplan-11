import 'package:flutter/material.dart';

class NewPasswordPage extends StatelessWidget {
  const NewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Back Button
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),

              const SizedBox(height: 10),

              /// Logo + Title
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  "Growplan",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF407017),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// Title
              const Center(
                child: Text(
                  "Kata Sandi Baru",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF25410E),
                  ),
                ),
              ),

              const SizedBox(height: 5),

              const Center(
                child: Text(
                  "Masukkan kata sandi baru Anda. Pastikan berbeda\n"
                  "dari kata sandi sebelumnya demi keamanan akun.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF508C1D)),
                ),
              ),

              const SizedBox(height: 40),

              /// Label 1
              const Text(
                "Kata Sandi Baru",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF25410E),
                ),
              ),

              const SizedBox(height: 8),

              /// Password Field 1
              Container(
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFF6ABA27),
                    width: 1.5,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Masukkan kata sandi baru",
                          style: TextStyle(color: Color(0xFF6ABA27)),
                        ),
                      ),
                      Icon(Icons.visibility_outlined, color: Color(0xFF6ABA27)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// Label 2
              const Text(
                "Konfirmasi Kata Sandi",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF25410E),
                ),
              ),

              const SizedBox(height: 8),

              /// Password Field 2
              Container(
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFF6ABA27),
                    width: 1.5,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Masukkan ulang kata sandi",
                          style: TextStyle(color: Color(0xFF6ABA27)),
                        ),
                      ),
                      Icon(Icons.visibility_outlined, color: Color(0xFF6ABA27)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 250),

              /// Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD1EABC),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Perbarui Kata Sandi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
