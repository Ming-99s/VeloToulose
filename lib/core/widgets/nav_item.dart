import 'package:flutter/material.dart';

BottomNavigationBarItem navitem(
  String unactive,
  String activeIcon,
  String label,
) {
  return BottomNavigationBarItem(
    icon: Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Image.asset(unactive, width: 24, height: 24),
    ),
    activeIcon: Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Image.asset(activeIcon, width: 24, height: 24)),
    label: label,
  );
}
