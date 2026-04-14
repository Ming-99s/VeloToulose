import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/widgets/confirm_dialog.dart';
import 'package:velo_toulose/features/auth/view/auth_screen.dart';
import 'package:velo_toulose/features/profile/widgets/pass_card.dart';
import 'package:velo_toulose/features/profile/widgets/pay_as_you_go_card.dart';
import 'package:velo_toulose/features/profile/widgets/tile_profile.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  void _signOut(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 5,
                          color: AppColor.background,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            spreadRadius: 0.5,
                            color: const Color.fromARGB(60, 107, 114, 128),
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColor.textSecondary,
                        child: Icon(
                          Icons.person,
                          color: AppColor.background,
                          size: 50,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(58, 255, 94, 0),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: AppColor.primary,
                            child: Icon(Icons.edit, color: AppColor.background),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),
              Text('Pheng Lyming', style: AppTextStyle.heading),
              Text('Lyming4999@gmail.com', style: AppTextStyle.pricePeriod),

              SizedBox(height: 30),

              PayAsYouGoCard(),

              SizedBox(height: 30),

              Container(
                decoration: BoxDecoration(
                  color: AppColor.background,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(29, 107, 114, 128),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(children: [TileProfile(), TileProfile()]),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: (){ showDialog(
                  context: context,
                  builder: (BuildContext context){

                  return ConfirmDialog(
                    title: 'Sign out',
                    message: 'Sign out of your account?',
                    confirmLabel: 'Sign out',
                    cancelLabel: 'cancel ',
                    isDanger: true,
                    onTap: () => _signOut(context),
                  );
                  
                  }

                );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: AppColor.red),
                    SizedBox(width: 10),
                    Text(
                      'Sign out',
                      style: TextStyle(
                        color: AppColor.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
