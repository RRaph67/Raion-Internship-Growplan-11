import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_1/presentation/home/widgets/appbar_widget.dart';
import 'package:flutter_application_1/presentation/home/widgets/bottom_navigation.dart';
import 'package:flutter_application_1/presentation/plant_info/pages/main_plant_page.dart';
import 'package:flutter_application_1/presentation/plant_info/widget/simple_appbar.dart';
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
      setState(() {
        _username = metadata['name']?.toString() ?? "User";
      });
    }
  }

  final List<Widget> _pages = [
    Center(child: Text("Ini halaman Home")),
    Center(child: Text("Discovery belum ada")),
    const PlantInfo(),
  ];

  PreferredSizeWidget _buildAppBar() {
    switch (myIndex) {
      case 0: // Home
        return CustomAppBar(
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
        );
      case 1: // Discovery
        return SimpleAppBar(
          title: "Discovery",
          onBackTap: () {
            setState(() {
              myIndex = 0; // kembali ke Home tab
            });
          },
        );
      case 2: // My Plant
        return SimpleAppBar(
          title: "Plant Info",
          onBackTap: () {
            setState(() {
              myIndex = 0; // kembali ke Home tab
            });
          },
        );
      default:
        return const SimpleAppBar(title: "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(index: myIndex, children: _pages),
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
