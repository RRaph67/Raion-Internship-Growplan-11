// File: lib/presentation/discovery/discovery_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_pallete.dart';
import 'package:flutter_application_1/presentation/discovery/widget/post_card_widget.dart';

class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        children: [
          // Header Section
          _buildHeaderSection(),
          const SizedBox(height: 24),

          // Feed Section
          _buildFeedSection(),
        ],
      ),
      floatingActionButton:FloatingActionButton(onPressed: (){},
      backgroundColor: AppPallete.primaryNormal,
              elevation: 4,
              shape: const CircleBorder(),
              child: Image.asset('assets/pencil.png'))
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temukan Tanaman',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF508C1D),
            ),
          ),
          Text(
            'Jelajahi berbagai tanaman dan tips perawatan',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedSection() {
    return Column(
      children: [
        // Post 1
        PostCard(
          userId: '1',
          userName: 'Natasha Udu',
          username: '@pokcoyandonion',
          userAvatarUrl: 'https://i.pinimg.com/736x/7c/6f/cd/7c6fcd13ddde1124ac5503c5f7a0cf44.jpg', //avatar
          postText:
              'Dah tau blom ada yg namanya kutu daun? Hati-hati nih sama tanaman monstera!',
          postImages: [
            'https://i.pinimg.com/1200x/94/d9/5a/94d95a92d1bc06a2196e97250cd7b52e.jpg',
            'https://i.pinimg.com/1200x/30/f1/a8/30f1a8809d04ac9f66bba8e2484dcf80.jpg',
          ],
        ),

        // Post 2
        PostCard(
          userId: '2',
          userName: 'Baskara Putra',
          username: '@bukanwordfangs',
          userAvatarUrl: 'https://i.pinimg.com/736x/bb/3f/ee/bb3feef4b74b58a09a1d418a78a47a87.jpg', //avatar
          postText:
              'Akhirnya Aglaonema koleksi gue keluar tunas baru! Rasanya lebih seneng daripada dapet gajian. 😂',
          postImages: [
            'https://i.pinimg.com/736x/b1/1f/33/b11f33fdf2f1a001c1003aa7a09c4aa7.jpg',
            'https://i.pinimg.com/736x/5a/4f/24/5a4f24f3f2aad1c5b3e4abbf4dabac1d.jpg',
            'https://i.pinimg.com/736x/a3/6e/8a/a36e8a4f9890177800e0d820b2161a18.jpg',
          ],
        ),

        // Post 3
        PostCard(
          userId: '3',
          userName: 'Adrian Mahendra',
          username: '@asamlambunk',
          userAvatarUrl: 'https://topikindo.com/wp-content/uploads/2026/03/Bigmo-Muhammad-Jannah-b.webp', //avatar
          postText:
              'Tips menyiram tanaman: Jangan terlalu banyak air, biarkan tanah agak kering dulu.',
          postImages: ['https://i.pinimg.com/1200x/30/f1/a8/30f1a8809d04ac9f66bba8e2484dcf80.jpg'],
        ),

        // Post 4
        PostCard(
          userId: '4',
          userName: 'Siti Nurhaliza',
          username: '@tanamanhijau',
          userAvatarUrl: 'https://image.idntimes.com/post/20251212/upload_af8f7709daaa7b7992e0f2b243815044_1af8a1b5-b343-4564-826b-6b1bb01cb73e.jpg', //avatar
          postText:
              'Pupuk organik lebih baik daripada pupuk kimia untuk tanaman indoor.',
          postImages: [
            'https://i.pinimg.com/736x/5a/4f/24/5a4f24f3f2aad1c5b3e4abbf4dabac1d.jpg',
            'https://i.pinimg.com/736x/a3/6e/8a/a36e8a4f9890177800e0d820b2161a18.jpg',
          ],
        ),
      ],
    );
  }
}
