import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_1/presentation/auth/pages/login_page.dart';
import 'package:flutter_application_1/presentation/home/widgets/appbar_widget.dart';
import 'package:flutter_application_1/presentation/home/widgets/bottom_navigation.dart';
import 'package:flutter_application_1/presentation/profile/cubit/profile_cubit.dart';
import 'package:flutter_application_1/presentation/profile/edit_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int myIndex = 0;
  final supabase = Supabase.instance.client;
  String? _username;
  String? _currentPhotoUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthCubit>().state;
    if (state is AuthSuccess) {
      _getUserInfo();
      _currentPhotoUrl = state.user.fotoProfil!;
    }
  }

  void _getUserInfo() {
    final user = supabase.auth.currentUser;

    if (user != null) {
      final metadata = user.userMetadata ?? {};
      // Pastikan nama ada, jika tidak set null
      setState(() {
        _username = metadata['name']?.toString() ?? "User";
      });
    }
  }

  Future<void> _signOut() async {
    // Set loading state
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      await supabase.auth.signOut();

      // Cek apakah widget masih ada di tree sebelum navigasi
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LogIn()),
        );
      }
    } catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${err.toString()}')));
      }
    } finally {
      // Reset loading hanya jika widget masih ada (jika navigasi gagal atau error)
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
      appBar: CustomAppBar(
        username: _username,
        photoUrl: _currentPhotoUrl,
        onAvatarTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => ProfileCubit(supabase),
                child: const EditProfile(),
              ),
            ),
          );
        },
        onRightIconTap: () {
          print("Icon kanan ditekan");
        },
        rightIconPath: 'assets/icons/home/notifications.png',
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Kosong
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: myIndex,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
      ),
    );
  }
}
