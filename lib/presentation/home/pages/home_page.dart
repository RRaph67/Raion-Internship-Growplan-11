import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_pallete.dart';
import 'package:flutter_application_1/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_1/presentation/discovery/pages/discovery_page.dart';
import 'package:flutter_application_1/presentation/home/widgets/appbar_widget.dart';
import 'package:flutter_application_1/presentation/home/widgets/bottom_navigation.dart';
import 'package:flutter_application_1/presentation/plant_info/pages/main_plant_page.dart';
import 'package:flutter_application_1/presentation/plant_info/widget/simple_appbar.dart';
import 'package:flutter_application_1/presentation/profile/pages/profile_kosong.dart';
import 'package:flutter_application_1/presentation/user_tanam/cubit/user_tanam_cubit.dart';
import 'package:flutter_application_1/presentation/user_tanam/cubit/user_tanam_state.dart';
import 'package:flutter_application_1/presentation/user_tanam/pages/add_user_tanam.dart';
import 'package:flutter_application_1/presentation/user_tanam/pages/user_tanam_detail.dart';
import 'package:flutter_application_1/presentation/user_tanam/widget/user_tanam_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int myIndex = 0;
  final supabase = Supabase.instance.client;
  String? _username;
  String? _currentPhotoUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Inisialisasi data tanaman (Logika Kode 2)
    context.read<UserTanamCubit>().fetchUserTanamList();

    // Inisialisasi data user (Logika Kode 1)
    final state = context.read<AuthCubit>().state;
    if (state is AuthSuccess) {
      _getUserInfo(); // Mengambil nama dari metadata
      _currentPhotoUrl = state.user.fotoProfil;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<UserTanamCubit>().fetchUserTanamList();
    }
  }

  void _getUserInfo() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final metadata = user.userMetadata ?? {};
      setState(() {
        // Mengutamakan metadata 'name' sesuai fitur Kode 1
        _username = metadata['name']?.toString() ?? "User";
      });
    }
  }

  // Tampilan Home dengan GridView (Kode 2) tapi tetap responsif
// Update pada bagian _buildHomePage di dalam HomePage class
  Widget _buildHomePage() {
    return BlocBuilder<UserTanamCubit, UserTanamState>(
      builder: (context, state) {
        if (state is UserTanamLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF508C1D)),
          );
        } else if (state is UserTanamListLoaded) {
          final list = state.list;

          if (list.isEmpty) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    // Menyesuaikan tinggi agar konten berada di tengah layar
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100,left: 20 ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/home/belum_punya_tanaman.png',
                            width: 284,
                            height: 284,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Yah, kamu belum memiliki tanaman",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF508C1D), // Warna sesuai permintaan
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                          ), // Memberi ruang bawah agar tidak terlalu mepet
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          // Jika ada data, tampilkan GridView
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return UserTanamCard(
                id: item.id,
                namaTanam: item.namaTanam,
                tanggalTanam: item.tanggalTanam.toIso8601String(),
                imageUrl: item.imageUrl,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserTanamDetailPage(userTanamId: item.id),
                    ),
                  );
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
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
            // Menerapkan Fitur Update dari Kode 1: Pindah ke Profil Kosong
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileEmptyPage()),
            );
          },
          rightIconPath: 'assets/icons/home/notifications.png',
          showBackButton: false,
        );
      case 1:
        return SimpleAppBar(
          title: "Discovery",
          showBackButton: true,
          onBackTap: () => setState(() => myIndex = 0),
        );
      case 2:
        return SimpleAppBar(
          title: "Plant Info",
          showBackButton: true,
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
      // BlocListener memastikan jika profile diupdate di tempat lain, UI Home ikut berubah
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            setState(() {
              _currentPhotoUrl = state.user.fotoProfil;
              _username = state.user.nama;
            });
          }
        },
        child: IndexedStack(index: myIndex, children: _pages),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: myIndex,
        onTap: (index) => setState(() => myIndex = index),
      ),
      floatingActionButton: myIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddUserTanamPage()),
                );
                if (mounted) {
                  context.read<UserTanamCubit>().fetchUserTanamList();
                }
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
