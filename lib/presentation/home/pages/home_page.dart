import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_pallete.dart';
import 'package:flutter_application_1/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_1/presentation/discovery/pages/discovery_page.dart';
import 'package:flutter_application_1/presentation/home/widgets/appbar_widget.dart';
import 'package:flutter_application_1/presentation/home/widgets/bottom_navigation.dart';
import 'package:flutter_application_1/presentation/plant_info/pages/main_plant_page.dart';
import 'package:flutter_application_1/presentation/plant_info/widget/simple_appbar.dart';
import 'package:flutter_application_1/presentation/profile/pages/profil_kosong.dart';
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

  // Halaman Home default
  Widget _buildHomePage() {
    final List<String> todoTanaman = []; // nanti isi dari DB

    if (todoTanaman.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/home/belum_punya_tanaman.png',
              width: 248,
              height: 248,
            ),
            const SizedBox(height: 34),
            const Text(
              "Yah, kamu belum memiliki tanaman",
              style: TextStyle(fontSize: 16, color: Colors.black45),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: todoTanaman.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.local_florist),
            title: Text(todoTanaman[index]),
          );
        },
      );
    }
  }

  List<Widget> get _pages => [
    _buildHomePage(),
    const DiscoveryPage(),
    const PlantInfo(),
  ];

  PreferredSizeWidget _buildAppBar() {
    switch (myIndex) {
      case 0:
        return CustomAppBar(
          username: _username,
          photoUrl: _currentPhotoUrl,
          onAvatarTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileEmptyPage()),
            );
          },

          rightIconPath: 'assets/icons/home/notifications.png',
        );
      case 1:
        return SimpleAppBar(
          title: "Discovery",
          onBackTap: () => setState(() => myIndex = 0),
        );
      case 2:
        return SimpleAppBar(
          title: "Plant Info",
          onBackTap: () => setState(() => myIndex = 0),
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
        onTap: (index) => setState(() => myIndex = index),
      ),
      floatingActionButton: myIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // aksi tambah tanaman
              },
              backgroundColor: AppPallete.primaryNormal,
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
