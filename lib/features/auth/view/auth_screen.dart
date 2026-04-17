import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/widgets/botton.dart';
import 'package:velo_toulose/features/auth/widgets/buildSwitch.dart';

enum AuthMode { login, register }

class AuthScreen extends StatelessWidget {
  final AuthMode mode;

  const AuthScreen({super.key, required this.mode});

  bool get isLogin => mode == AuthMode.login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLogin ? 'Login' : 'Register',
                    style: TextStyle(
                      color: AppColor.background,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    isLogin ? 'Welcome Back' : 'Create Account',
                    style: TextStyle(
                      color: AppColor.background,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -120,
                  right: -40,
                  child: Lottie.asset('assets/stickers/girl.json'),
                  width: 300,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColor.background,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 20),

                        _inputs(),

                        SizedBox(height: 10),

                        Buildswitch(isLogin: isLogin),

                        SizedBox(height: 10),

                        AppButton(
                          label: isLogin ? 'Login' : 'Register',
                          isprimaryColor: true,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputs() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(0, 2),
            spreadRadius: 1.2,
            color: Color.fromARGB(71, 107, 114, 128),
          ),
        ],
      ),
      child: Column(
        children: [
          if (!isLogin) ...[
            TextField(
              decoration: InputDecoration(
                hintText: 'Username',
                border: InputBorder.none,
              ),
            ),
            Divider(),
          ],
          TextField(
            decoration: InputDecoration(
              hintText: 'Email',
              border: InputBorder.none,
            ),
          ),
          Divider(),
          TextField(
            decoration: InputDecoration(
              hintText: 'Password',
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
