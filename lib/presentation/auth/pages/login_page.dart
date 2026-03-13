import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_text.dart';
import 'package:flutter_application_1/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_1/presentation/auth/widgets/auth_button.dart';
import 'package:flutter_application_1/presentation/auth/widgets/custom_field.dart';
import 'package:flutter_application_1/presentation/auth/widgets/password_page.dart';
import 'package:flutter_application_1/presentation/home/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailCont = TextEditingController();
  final _passwordCont = TextEditingController();


  @override
  void dispose() {
    _emailCont.dispose();
    _passwordCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/group-MC0.png',
              width: double.infinity,
              fit: BoxFit.cover,
              height: 300,
            ),
          ),

          // Container putih di bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 525,
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
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(42.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul Log In
                        Center(
                          child: Text(
                            'Selamat Datang!',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF305412),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Masuk untuk melanjutkan dengan Growplan',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6ABA27),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Email TextFormField
                        Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF305412),
                          ),
                        ),
                        SizedBox(height: 5),

                        CustomField(
                          hint: "Masukan Email",
                          controller: _emailCont,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email tidak boleh kosong";
                            }
                            if (!value.contains('@')) {
                              return "Email tidak valid! coba lagi";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Password TextFormField
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
                          hint: "Masukan Kata Sandi",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password tidak boleh kosong";
                            }
                            if (value.length < 6) {
                              return "Password minimal 6 karakter";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/forgot');
                            },
                            child: const Text(
                              'Lupa kata sandi?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF508C1D),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 36),
                        AuthButton(
                          emailController: _emailCont,
                          passwordController: _passwordCont,
                          buttonContent: BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is AuthFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error Occured: ${state.message}',
                                    ),
                                  ),
                                );
                              }
                              if (state is AuthSuccess) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(
                                      0xFF6ABA27,
                                    ), 
                                  ),
                                );
                              }
                              return Text('Masuk', style: AppText.semiBold20);
                            },
                          ),
                          onPressed: () async {
                            await context.read<AuthCubit>().login(
                              _emailCont.text.trim(),
                              _passwordCont.text.trim(),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/regis');
                            },
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Belum Punya Akun? ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Daftar",
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

          Positioned(
            bottom: 490, 
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/Group 36698.png',
                width: 117,
                height: 109,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
