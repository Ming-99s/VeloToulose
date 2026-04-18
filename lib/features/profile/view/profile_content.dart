import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/widgets/confirm_dialog.dart';
import 'package:velo_toulose/features/auth/view/auth_screen.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/features/profile/widgets/pay_as_you_go_card.dart';
import 'package:velo_toulose/features/profile/widgets/tile_profile.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  void _signOutOrLogin(BuildContext context) {
    context.read<AuthViewModel>().signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AuthScreen(mode: AuthMode.login)),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

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
                        backgroundImage:
                            (vm.currentUser?.image != null &&
                                vm.currentUser!.image.toString().isNotEmpty)
                            ? NetworkImage(vm.currentUser!.image.toString())
                            : null,
                        child:
                            (vm.currentUser?.image == null ||
                                vm.currentUser!.image.toString().isEmpty)
                            ? Icon(
                                Icons.person,
                                color: AppColor.background,
                                size: 50,
                              )
                            : null,
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
                          child: vm.isLoggedIn ? CircleAvatar(
                            backgroundColor: AppColor.primary,
                            child: Icon(Icons.edit, color: AppColor.background),
                          ): SizedBox.shrink()
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10,),
              // real name and email from AuthViewModel
              Text(
                vm.isLoggedIn ? vm.currentUser!.fullName : 'Welcome',
                style: AppTextStyle.heading,
              ),
              Text(
                vm.isLoggedIn ? vm.currentUser!.email : '',
                style: AppTextStyle.pricePeriod,
              ),

              vm.isLoggedIn ?   SizedBox(height: 30) : SizedBox.shrink(),
              vm.isLoggedIn ? PayAsYouGoCard() : SizedBox.shrink(),
              vm.isLoggedIn ?  SizedBox(height: 30) : SizedBox.shrink(),

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
                child: vm.isLoggedIn
                    ? Column(
                        children: [
                          TileProfile(
                            label: 'Notification',
                            icon: Icons.notifications,
                            onTap: () => {},
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
              ),

              vm.isLoggedIn ?  SizedBox(height: 30) : SizedBox.shrink(),
              GestureDetector(
                onTap: () {
                  vm.isLoggedIn
                      ? showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmDialog(
                              title: 'Sign out',
                              message: 'Sign out of your account?',
                              confirmLabel: 'Sign out',
                              cancelLabel: 'cancel',
                              isDanger: true,
                              onTap: () => _signOutOrLogin(context),
                            );
                          },
                        )
                      :  _signOutOrLogin(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    vm.isLoggedIn ?  Icon(Icons.logout, color: AppColor.red) :  Icon(Icons.login, color: AppColor.primary),
                    SizedBox(width: 10),
                    Text(
                      vm.isLoggedIn ?  'Sign out' : 'Login',
                      style: TextStyle(
                        color: vm.isLoggedIn ?  AppColor.red : AppColor.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15
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
