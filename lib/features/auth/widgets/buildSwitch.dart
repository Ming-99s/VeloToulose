import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/features/auth/view/auth_screen.dart';

class Buildswitch extends StatelessWidget {
  const Buildswitch({super.key,required this.isLogin});
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Row(
        children: [
          Expanded(child: Divider()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(
                  isLogin ? "Don't have account?" : "Already have an account?",
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AuthScreen(
                          mode: isLogin ? AuthMode.register : AuthMode.login,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      isLogin ? 'Register' : 'Login',
                      style: TextStyle(
                        color: AppColor.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColor.primary
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Divider()),
        ],
      ),
  );
  }
}
