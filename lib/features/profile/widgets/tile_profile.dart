import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';

class TileProfile extends StatelessWidget {
  const TileProfile({super.key, required this.onTap,required this.icon,required this.label});

  final Function() onTap;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Material(
        color: AppColor.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: ()=>onTap,
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),

              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 231, 237, 247),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColor.textSecondary,
              ),
            ),
            title: Text(
              label,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}
