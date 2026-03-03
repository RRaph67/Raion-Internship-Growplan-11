import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_text.dart';
import 'package:flutter_application_1/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_1/presentation/auth/widgets/auth_button.dart';
import 'package:flutter_application_1/presentation/auth/widgets/custom_field.dart';
import 'package:flutter_application_1/presentation/auth/widgets/password_page.dart';
import 'package:flutter_application_1/presentation/home/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  // final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final _emailCont = TextEditingController();
  final _passwordCont = TextEditingController();
  // bool _isLoading = false;
  // bool _obscurePw = true;

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
                                    ), // warna hijau sesuai tema
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
            bottom: 490, // posisikan tepat di atas container
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

// import 'package:after_bigbug/presentation/pages/homePage.dart';
// import 'package:after_bigbug/presentation/pages/regisPage.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class LogIn extends StatefulWidget {
//   const LogIn({super.key});

//   @override
//   LogInState createState() => LogInState();
// }

// class LogInState extends State<LogIn> {
//   final supabase = Supabase.instance.client;
//   final _formKey = GlobalKey<FormState>();
//   final _emailCont = TextEditingController();
//   final _passwordCont = TextEditingController();
//   bool _isLoading = false;
//   bool _obscurePw = true;

//   @override
//   void dispose() {
//     _emailCont.dispose();
//     _passwordCont.dispose();
//     super.dispose();
//   }

//   Future<void> _signIn() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await supabase.auth.signInWithPassword(
//         email: _emailCont.text.trim(),
//         password: _passwordCont.text,
//       );

//       if (response.session != null && mounted) {
//         Navigator.of(
//           context,
//         ).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
//       }
//     } on Exception catch (err) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(err.toString()),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
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
//               'assets/group-MC0.png',
//               width: double.infinity,
//               fit: BoxFit.cover,
//               height: 300,
//             ),
//           ),

//           // Container putih di bawah
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 525,
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
//                 padding: const EdgeInsets.all(42.0),
//                 child: SingleChildScrollView(
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Judul Log In
//                         Center(
//                           child: Text(
//                             'Selamat Datang!',
//                             style: const TextStyle(
//                               fontSize: 32,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF305412),
//                             ),
//                           ),
//                         ),
//                         Center(
//                           child: Text(
//                             'Masuk untuk melanjutkan dengan Growplan',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF6ABA27),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 24),

//                         // Email TextFormField
//                         Text(
//                           'Email',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                             color: Color(0xFF305412),
//                           ),
//                         ),
//                         SizedBox(height: 5),
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
//                             // prefixIcon dihapus
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

//                         // Password TextFormField
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
//                             hintText: "Masukan Kata Sandi",
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
//                             // prefixIcon dihapus
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscurePw
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 color: const Color(0xFF6ABA27),
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscurePw = !_obscurePw;
//                                 });
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

//                         const SizedBox(height: 16),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: InkWell(
//                             child: const Text(
//                               'Lupa kata sandi?',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFF508C1D),
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 48),
//                         SizedBox(
//                           width: double.infinity,
//                           height: 55,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Color(
//                                 0xFF508C1D,
//                               ), // hijau konsisten
//                               foregroundColor: Colors.white,
//                               textStyle: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(
//                                   50,
//                                 ), // radius sama dengan form
//                               ),
//                             ),
//                             onPressed: _isLoading ? null : _signIn,
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
//                                     'Masuk',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                           ),
//                         ),

//                         const SizedBox(height: 24),
//                         Align(
//                           alignment: Alignment.center,
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const SignUp(),
//                                 ),
//                               );
//                             },
//                             child: RichText(
//                               text: const TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text: "Belum Punya Akun? ",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400,
//                                       color: Color.fromARGB(255, 0, 0, 0),
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: "Daftar",
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
