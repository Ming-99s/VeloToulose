import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';

class SearchBarVelo extends StatelessWidget {
  const SearchBarVelo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.search),
          hintText: "Search Station",
        ),
      ),
    );
  }
}
