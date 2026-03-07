import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/const/icons_const.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: const Color(0xFF508C1D),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Opacity(
              opacity: currentIndex == 0 ? 1.0 : 0.5,
              child: Image.asset(IconConst.home, width: 24, height: 24),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Opacity(
              opacity: currentIndex == 1 ? 1.0 : 0.5,
              child: Image.asset(IconConst.discovery, width: 24, height: 24),
            ),
            label: 'Discovery',
          ),
          BottomNavigationBarItem(
            icon: Opacity(
              opacity: currentIndex == 2 ? 1.0 : 0.5,
              child: Image.asset(IconConst.myPlant, width: 24, height: 24),
            ),
            label: 'Plant Info',
          ),
        ],
      ),
    );
  }
}
