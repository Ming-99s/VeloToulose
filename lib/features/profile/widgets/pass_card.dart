import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';

class PassCard extends StatelessWidget {
  const PassCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.background,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(29, 107, 114, 128),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 2

          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColor.primaryLight
            ),
            child: Text('Current Plan'.toUpperCase(),style: TextStyle(color: AppColor.primary,fontSize: 10,fontWeight: FontWeight.w600),),
          ),
          SizedBox(height: 5,),
          Text('Monthly',style: TextStyle(color: AppColor.primary,fontSize: 30,fontWeight: FontWeight.w800),),
          SizedBox(height: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rewal Date'.toUpperCase(),style: TextStyle(color: AppColor.textSecondary,fontSize: 12),),
              Text('Mar 24,2026',style: TextStyle(color: AppColor.textPrimary,fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }
}
