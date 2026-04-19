import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/widgets/confirm_dialog.dart';
import 'package:velo_toulose/features/auth/view/auth_screen.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/features/profile/view/edit_profile_screen.dart';
import 'package:velo_toulose/features/profile/widgets/pass_card.dart';
import 'package:velo_toulose/features/profile/widgets/pay_as_you_go_card.dart';
import 'package:velo_toulose/features/profile/widgets/tile_profile.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  void _signOutOrLogin(BuildContext context) {
    context.read<AuthViewModel>().signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => AuthScreen(mode: AuthMode.login)),
      (route) => false,
    );
  }

  void _goToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final user = vm.currentUser;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // avatar
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 5, color: AppColor.background),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          spreadRadius: 0.5,
                          color: Color.fromARGB(60, 107, 114, 128),
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColor.textSecondary,
                      backgroundImage: (user?.hasImage == true)
                          ? NetworkImage(user!.image.toString())
                          : null,
                      child: user?.hasImage != true
                          ? Icon(
                              Icons.person,
                              color: AppColor.background,
                              size: 50,
                            )
                          : null,
                    ),
                  ),
                  if (vm.isLoggedIn)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _goToEditProfile(context),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(58, 255, 94, 0),
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

            const SizedBox(height: 10),

            // name + email
            Text(
              vm.isLoggedIn ? user!.fullName : 'Welcome',
              style: AppTextStyle.heading,
            ),
            Text(
              vm.isLoggedIn ? user!.email : '',
              style: AppTextStyle.pricePeriod,
            ),

            if (vm.isLoggedIn) ...[
              const SizedBox(height: 30),

              // show PassCard if user has active pass, otherwise PayAsYouGoCard
              user?.hasActivPass == true
                  ? PassCard(pass: user!.pass!)
                  : const PayAsYouGoCard(),

              const SizedBox(height: 30),

              Container(
                decoration: BoxDecoration(
                  color: AppColor.background,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(29, 107, 114, 128),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TileProfile(
                      label: 'Notification',
                      icon: Icons.notifications,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],

            // login / sign out button
            GestureDetector(
              onTap: () {
                vm.isLoggedIn
                    ? showDialog(
                        context: context,
                        builder: (ctx) => ConfirmDialog(
                          title: 'Sign out',
                          message: 'Sign out of your account?',
                          confirmLabel: 'Sign out',
                          cancelLabel: 'Cancel',
                          isDanger: true,
                          onTap: () => _signOutOrLogin(context),
                        ),
                      )
                    : _signOutOrLogin(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    vm.isLoggedIn ? Icons.logout : Icons.login,
                    color: vm.isLoggedIn ? AppColor.red : AppColor.primary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    vm.isLoggedIn ? 'Sign out' : 'Login',
                    style: TextStyle(
                      color: vm.isLoggedIn ? AppColor.red : AppColor.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
