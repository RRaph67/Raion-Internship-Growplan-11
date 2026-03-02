import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/auth/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  String? _username;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

void _getUserInfo() {
    final user = supabase.auth.currentUser;

    if (user != null) {
      final metadata = user.userMetadata ?? {};

      setState(() {
        _username = metadata['name']?.toString();
      });
    }
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await supabase.auth.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LogIn()),
        );
      }
    } on Exception catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GrowPlan'),
        elevation: 0,
        backgroundColor: const Color(0xFF6ABA27),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // <--- hilangkan tombol back
      ),

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              SizedBox(height: 24),
              Text(
                _username ?? "No username",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF305412), // hijau konsisten
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        50,
                      ), // radius sama dengan form
                    ),
                  ),
                  onPressed: _isLoading ? null : _signOut,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:after_bigbug/presentation/pages/loginPage.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class HomePage extends StatefulWidget {
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final supabase = Supabase.instance.client;
//   String? _username;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _getUserInfo();
//   }

// void _getUserInfo() {
//     final user = supabase.auth.currentUser;
//     if (user != null) {
//       setState(() {
//         _username = user.userMetadata?['username'] as String?;
//       });
//     }
//   }

//   Future<void> _signOut() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       await supabase.auth.signOut();
//       if (mounted) {
//         Navigator.of(
//           context,
//         ).pushReplacement(MaterialPageRoute(builder: (context) => LogIn()));
//       }
//     } on Exception catch (err) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(err.toString()),
//             backgroundColor: Colors.redAccent,
//           ),
//         );
//       }
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
//       appBar: AppBar(
//         title: const Text('GrowPlan'),
//         elevation: 0,
//         backgroundColor: const Color(0xFF6ABA27),
//         foregroundColor: Colors.white,
//         automaticallyImplyLeading: false, // <--- hilangkan tombol back
//       ),

//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Welcome',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
//               ),
//               SizedBox(height: 24),
//               Text(
//                 _username ?? "No username",
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               const SizedBox(height: 48),
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF305412), // hijau konsisten
//                     foregroundColor: Colors.white,
//                     textStyle: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(
//                         50,
//                       ), // radius sama dengan form
//                     ),
//                   ),
//                   onPressed: _isLoading ? null : _signOut,
//                   child: _isLoading
//                       ? const SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : const Text(
//                           'Sign Out',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
