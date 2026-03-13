import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/validator/auth_validator.dart';
import 'package:flutter_application_1/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_1/presentation/auth/widgets/auth_button.dart';
import 'package:flutter_application_1/presentation/auth/widgets/custom_field.dart';
import 'package:flutter_application_1/presentation/auth/widgets/password_page.dart';
import 'package:flutter_application_1/presentation/home/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _usnCont = TextEditingController();
  final _emailCont = TextEditingController();
  final _passwordCont = TextEditingController();
  final _confPasswordCont = TextEditingController();

  @override
  void dispose() {
    _usnCont.dispose();
    _emailCont.dispose();
    _passwordCont.dispose();
    _confPasswordCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/unsplash_7PZvhCwxios (1).png',
              width: double.infinity,
              fit: BoxFit.cover,
              height: 300,
            ),
          ),

          // Kontainer putih scrollable
          Positioned.fill(
            top: 160, 
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, -5),
                  ),
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Buat Akun!',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF305412),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Daftar untuk bergabung dengan Growplan',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6ABA27),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Username
                        Text(
                          'Nama Pengguna',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF305412),
                          ),
                        ),
                        SizedBox(height: 5),
                        CustomField(
                          hint: 'Masukan Username',
                          controller: _usnCont,
                          validator: (value) =>
                              AuthValidator.name(value: value),
                        ),
                        const SizedBox(height: 10),

                        // Email
                        Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF305412),
                          ),
                        ),
                        CustomField(
                          hint: 'Masukan Email',
                          controller: _emailCont,
                          validator: (value) =>
                              AuthValidator.email(value: value),
                        ),
                        const SizedBox(height: 10),

                        // Password
                        Text(
                          'Kata Sandi',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF305412),
                          ),
                        ),
                        SizedBox(height: 5),
                        PasswordField(
                          controller: _passwordCont,
                          hint: 'Masukan Kata Sandi',
                          validator: (value) =>
                              AuthValidator.password(value: value),
                        ),
                        const SizedBox(height: 10),

                        // Confirm Password
                        Text(
                          'Konfirmasi Kata Sandi',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF305412),
                          ),
                        ),
                        SizedBox(height: 5),
                        PasswordField(
                          controller: _confPasswordCont,
                          hint: 'Masukan Kata Sandi',
                          validator: (value) => AuthValidator.confirmPassword(
                            password: _passwordCont.text,
                            confirmPassword: value,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Tombol Sign Up
                        AuthButton(
                          namaController: _usnCont,
                          emailController: _emailCont,
                          passwordController: _passwordCont,
                          confirmPasswordController: _confPasswordCont,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await context.read<AuthCubit>().register(
                                _usnCont.text.trim(),
                                _emailCont.text.trim(),
                                _passwordCont.text.trim(),
                              );
                            }
                          },
                          buttonContent: BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is AuthEmailSent) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (dialogContext) {
                                    return AlertDialog(
                                      title: const Text("Email Terkirim"),
                                      content: const Text(
                                        "Kami telah mengirim email verifikasi. "
                                        "Silakan cek inbox atau folder spam.",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }

                              if (state is AuthSuccess) {
                                Future.microtask(() {
                                  if (!context.mounted) return;

                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).popUntil((route) => route.isFirst);

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => HomePage(),
                                    ),
                                  );
                                });
                              }

                              if (state is AuthFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                );
                              }

                              return const Text("Daftar");
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Link ke Log In
                        Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Sudah punya akun? ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Masuk Sekarang",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF508C1D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
