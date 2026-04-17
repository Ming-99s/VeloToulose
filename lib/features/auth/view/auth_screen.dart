import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velo_toulose/core/constant/app_color.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: AppColor.primary,
      body: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  'Login',style: TextStyle(
                    color: AppColor.background,
                    fontSize: 32,
                    fontWeight: FontWeight.w800
                
                  ),
                
                ),
              
              Text('Welcome Back',style: TextStyle(
                color: AppColor.background,
                fontSize: 15,
                fontWeight: FontWeight.w500
              ),),
                ],
                    ),
            ),
          ),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -100,
                  right: 0,
                  child: Lottie.asset('assets/stickers/girl.json'),
                  width: 300,
                  ),
                Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColor.background
                ),
                child: Column(
                  children: [
                    TextField(
                      
                    )
                  ],
                )
                          ),
              ],
            )),

        ],
      )
      
    );
  }
}