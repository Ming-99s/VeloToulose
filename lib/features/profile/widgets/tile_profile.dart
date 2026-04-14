import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';

class TileProfile extends StatelessWidget {
  const TileProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
      child: Material(
        color: AppColor.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            print('hellp');
          },
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 231, 237, 247),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.monetization_on_rounded,
                color: AppColor.textSecondary,
              ),
            ),
            title: Text(
              'Payment Methods',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}
