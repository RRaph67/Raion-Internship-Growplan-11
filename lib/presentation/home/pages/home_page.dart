import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_pallete.dart';
import 'package:flutter_application_1/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_1/presentation/discovery/pages/discovery_page.dart';
import 'package:flutter_application_1/presentation/home/widgets/appbar_widget.dart';
import 'package:flutter_application_1/presentation/home/widgets/bottom_navigation.dart';
import 'package:flutter_application_1/presentation/plant_info/pages/main_plant_page.dart';
import 'package:flutter_application_1/presentation/plant_info/widget/simple_appbar.dart';
import 'package:flutter_application_1/presentation/profile/cubit/profile_cubit.dart';
import 'package:flutter_application_1/presentation/profile/edit_profile.dart';
import 'package:flutter_application_1/presentation/user_tanam/cubit/user_tanam_cubit.dart';
import 'package:flutter_application_1/presentation/user_tanam/cubit/user_tanam_state.dart';
import 'package:flutter_application_1/presentation/user_tanam/pages/add_user_tanam.dart';
import 'package:flutter_application_1/presentation/user_tanam/pages/user_tanam_detail.dart';
import 'package:flutter_application_1/presentation/user_tanam/widget/user_tanam_card.dart';
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

  Widget _buildHomePage() {
    return BlocBuilder<UserTanamCubit, UserTanamState>(
      builder: (context, state) {
        if (state is UserTanamLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserTanamListLoaded) {
          final list = state.userTanamList;
          if (list.isEmpty) {
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
          }
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
                namaTanam: item['nama_tanam'],
                tanggalTanam: item['tanggal_tanam'],
                imageUrl: item['image_url'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          UserTanamDetailPage(userTanamId: item['id']),
                    ),
                  );
                },
              );
            },
          );
        } else if (state is UserTanamError) {
          return Center(child: Text("Error: ${state.message}"));
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
          rightIconPath: 'assets/icons/home/notifications.png',
        );
      case 1:
        return const SimpleAppBar(title: "Discovery");
      case 2:
        return const SimpleAppBar(title: "Plant Info");
      default:
        return const SimpleAppBar(title: "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserTanamCubit()..fetchUserTanamList(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: IndexedStack(index: myIndex, children: _pages),
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
                  // refresh otomatis setelah kembali
                  context.read<UserTanamCubit>().fetchUserTanamList();
                },
                backgroundColor: AppPallete.primaryNormal,
                elevation: 4,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
      ),
    );
  }
}
