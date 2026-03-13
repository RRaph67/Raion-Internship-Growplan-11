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
            top: 160, // biar ada space untuk background
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

// import 'package:after_bigbug/presentation/pages/loginPage.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   SignUpState createState() => SignUpState();
// }

// class SignUpState extends State<SignUp> {
//   final supabase = Supabase.instance.client;
//   final _formKey = GlobalKey<FormState>();
//   final _usnCont = TextEditingController();
//   final _emailCont = TextEditingController();
//   final _passwordCont = TextEditingController();
//   final _confPasswordCont = TextEditingController();
//   bool _isLoading = false;
//   bool _obscurePw = true;
//   bool _obscureConfPw = true;

//   @override
//   void dispose() {
//     _usnCont.dispose();
//     _emailCont.dispose();
//     _passwordCont.dispose();
//     _confPasswordCont.dispose();
//     super.dispose();
//   }

//   Future<void> _signUp() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (_passwordCont.text != _confPasswordCont.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Password do not match'),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final response = await supabase.auth.signUp(
//         email: _emailCont.text.trim(),
//         password: _passwordCont.text,
//         data: {
//           'username': _usnCont.text, // simpan username di metadata
//         },
//       );

//       if (response.session != null) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const LogIn()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please check your email to confirm your account'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         Navigator.of(context).pop();
//       }
//     } catch (err) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(err.toString()),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Image.asset(
//               'assets/unsplash_7PZvhCwxios (1).png',
//               width: double.infinity,
//               fit: BoxFit.cover,
//               height: 300,
//             ),
//           ),

//           // Kontainer putih scrollable
//           Positioned.fill(
//             top: 160, // biar ada space untuk background
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 4,
//                     offset: const Offset(0, -5),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: SingleChildScrollView(
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Center(
//                           child: Text(
//                             'Buat Akun!',
//                             style: const TextStyle(
//                               fontSize: 32,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF305412),
//                             ),
//                           ),
//                         ),
//                         Center(
//                           child: Text(
//                             'Daftar untuk bergabung dengan Growplan',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF6ABA27),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 24),

//                         // Username
//                         Text(
//                           'Nama Pengguna',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                             color: Color(0xFF305412),
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         TextFormField(
//                           controller: _usnCont,
//                           keyboardType: TextInputType.text,
//                           decoration: InputDecoration(
//                             labelText: "Nama Pengguna",
//                             labelStyle: const TextStyle(
//                               fontSize: 12,
//                               color: Color(0xFF6ABA27),
//                             ),
//                             hintText: "Masukan Nama Pengguna",
//                             hintStyle: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xFF6ABA27),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFF6ABA27),
//                                 width: 2,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFF6ABA27),
//                                 width: 1,
//                               ),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Username tidak boleh kosong";
//                             }
//                             if (value.length < 3) {
//                               return "Username minimal 3 karakter";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 10),

//                         // Email
//                         Text(
//                           'Email',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                             color: Color(0xFF305412),
//                           ),
//                         ),
//                         TextFormField(
//                           controller: _emailCont,
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: InputDecoration(
//                             labelText: "Email",
//                             labelStyle: const TextStyle(
//                               color: Color(0xFF6ABA27),
//                               fontSize: 12,
//                             ),
//                             hintText: "Masukan Email",
//                             hintStyle: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xFF6ABA27),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFF6ABA27),
//                                 width: 2,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFF6ABA27),
//                                 width: 1,
//                               ),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Email tidak boleh kosong";
//                             }
//                             if (!value.contains('@')) {
//                               return "Email tidak valid! coba lagi";
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 10),

//                         // Password
//                         Text(
//                           'Kata Sandi',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                             color: Color(0xFF305412),
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         TextFormField(
//                           controller: _passwordCont,
//                           obscureText: _obscurePw,
//                           decoration: InputDecoration(
//                             labelText: "Kata Sandi",
//                             labelStyle: const TextStyle(
//                               color: Color(0xFF6ABA27),
//                               fontSize: 12,
//                             ),
//                             hintText: "Masukan kata sandi",
//                             hintStyle: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xFF6ABA27),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFF6ABA27),
//                                 width: 2,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFF6ABA27),
//                                 width: 1,
//                               ),
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscurePw
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 color: const Color(0xFF6ABA27),
//                               ),
//                               onPressed: () {
//                                 setState(() => _obscurePw = !_obscurePw);
//                               },
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Password tidak boleh kosong";
//                             }
//                             if (value.length < 6) {
//                               return "Password minimal 6 karakter";
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 10),

//                         // Confirm Password
//                         Text(
//                           'Konfirmasi Kata Sandi',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                             color: Color(0xFF305412),
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         TextFormField(
//                           controller: _confPasswordCont,
//                           obscureText: _obscureConfPw,
//                           decoration: InputDecoration(
//                             labelText: "Konfirmasi kata sandi",
//                             labelStyle: const TextStyle(
//                               color: Color(0xFF6ABA27),
//                               fontSize: 12,
//                             ),
//                             hintText: "Konfirmasi kata sandi",
//                             hintStyle: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xFF6ABA27),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFF6ABA27),
//                                 width: 2,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               borderSide: const BorderSide(
//                                 color: Color(0xFF6ABA27),
//                                 width: 1,
//                               ),
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscureConfPw
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 color: const Color(0xFF6ABA27),
//                               ),
//                               onPressed: () {
//                                 setState(
//                                   () => _obscureConfPw = !_obscureConfPw,
//                                 );
//                               },
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Confirm Password tidak boleh kosong";
//                             }
//                             if (value.length < 6) {
//                               return "Confirm Password minimal 6 karakter";
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 32),

//                         // Tombol Sign Up
//                         SizedBox(
//                           width: double.infinity,
//                           height: 55,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF508C1D),
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                             ),
//                             onPressed: _isLoading ? null : _signUp,
//                             child: _isLoading
//                                 ? const SizedBox(
//                                     width: 24,
//                                     height: 24,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: Colors.white,
//                                     ),
//                                   )
//                                 : const Text(
//                                     'Daftar',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         const SizedBox(height: 24),

//                         // Link ke Log In
//                         Align(
//                           alignment: Alignment.center,
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const LogIn(),
//                                 ),
//                               );
//                             },
//                             child: RichText(
//                               text: const TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text: "Sudah punya akun? ",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400,
//                                       color: Color.fromARGB(255, 0, 0, 0),
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: "Masuk Sekarang",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color(0xFF508C1D),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
