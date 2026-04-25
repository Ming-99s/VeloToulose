import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/widgets/botton.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/features/auth/widgets/buildSwitch.dart';
import 'package:velo_toulose/features/booking/viewmodel/user_pass_viewmodel.dart';
import 'package:velo_toulose/features/notification/viewmodel/notification_view_model.dart';
import 'package:velo_toulose/features/profile/profile_screen.dart';
import 'package:velo_toulose/features/ride/viewmodel/ride_view_model.dart';
import 'package:velo_toulose/main_common.dart';

enum AuthMode { login, register }

class AuthScreen extends StatefulWidget {
  final AuthMode mode;

  const AuthScreen({super.key, required this.mode});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthMode _mode;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get isLogin => _mode == AuthMode.login;

  void _switchMode() {
    setState(() {
      _mode = isLogin ? AuthMode.register : AuthMode.login;
    });
    context.read<AuthViewModel>().clearError();
  }

  Future<void> _submit() async {
    final viewModel = context.read<AuthViewModel>();
    bool success = false;

    if (isLogin) {
      success = await viewModel.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } else {
      success = await viewModel.register(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }

if (success && mounted) {
  final uid = viewModel.currentUser!.userId;
  // reload user-specific data
  await context.read<NotificationViewModel>()
    .loadNotifications(uid);
  await context.read<RideViewModel>()
    .checkActiveRide(uid);

  Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(),));
}
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.background),
        backgroundColor: AppColor.transparent,
      ),
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
                  width: 300,
                  child: Lottie.asset('assets/stickers/girl.json'),
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

                        // error message
                        if (viewModel.error != null)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(18, 164, 29, 19),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              viewModel.error!,
                              style: TextStyle(
                                color: AppColor.red,
                                fontSize: 13,
                              ),
                            ),
                          ),

                        SizedBox(height: 10),

                        Buildswitch(isLogin: isLogin, onSwitch: _switchMode),

                        SizedBox(height: 10),

                        AppButton(
                          label: viewModel.isLoading
                              ? 'Please wait...'
                              : isLogin
                              ? 'Login'
                              : 'Register',
                          isprimaryColor: true,
                          onPressed: viewModel.isLoading ? () {} : _submit,
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
              controller: _firstNameController,
              decoration: InputDecoration(
                hintText: 'First Name',
                border: InputBorder.none,
              ),
            ),
            Divider(),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                hintText: 'Last Name',
                border: InputBorder.none,
              ),
            ),
            Divider(),
          ],
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              border: InputBorder.none,
            ),
          ),
          Divider(),
          TextField(
            controller: _passwordController,
            obscureText: true,
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
