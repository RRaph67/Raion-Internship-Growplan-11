import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF4F8F1C);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 47.21),
          child: Column(
            children: [
              const SizedBox(height: 24),

              /// Logo + Title
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

              // Title
              const Text(
                "Atur Ulang Kata Sandi",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E4E1E),
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                "Masukkan alamat email yang terdaftar untuk\nmendapatkan kode OTP.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: primaryGreen),
              ),

              const SizedBox(height: 32),

              // Placeholder image space
              const SizedBox(height: 180, width: double.infinity),

              const SizedBox(height: 24),

              // Email Label
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E4E1E),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // TextField
              TextField(
                decoration: InputDecoration(
                  hintText: "Masukkan email",
                  hintStyle: const TextStyle(color: primaryGreen),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: primaryGreen, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: primaryGreen, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 250),

              // Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Kirim Kode OTP",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
