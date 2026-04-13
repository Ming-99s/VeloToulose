import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/widgets/nav_item.dart';

class Navbar extends StatelessWidget {
   Navbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  int selectedIndex;
  Function(int index) onItemTapped;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(31, 0, 0, 0),
            blurRadius: 15,
            spreadRadius: 1,
            offset: Offset(0, 1)
          )
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          backgroundColor: AppColor.background,
          elevation: 0,
          selectedItemColor: AppColor.primary,
          unselectedItemColor: AppColor.textSecondary,
          currentIndex: selectedIndex,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.normal,
          ),
          onTap: onItemTapped,
          items: [
            navitem('assets/icons/map.png', 'assets/icons/activeMap.png', 'Map'),
            navitem(
              'assets/icons/user.png',
              'assets/icons/userActive.png',
              'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
