import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/widgets/botton.dart';
import 'package:velo_toulose/main_common.dart';
import 'package:velo_toulose/repositories/local/pref_repository.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  Future<void> _complete(BuildContext context) async {
    final prefRepo = context.read<PreferencesRepository>();
    await prefRepo.completeOnboarding();

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MyApp()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          /// Lottie background animation
          SizedBox(
            width: size.width,
            height: size.height * 0.2,
            child: Lottie.asset('assets/stickers/bike.json', fit: BoxFit.cover),
          ),

          /// Animated circle at bottom
          Positioned(
            bottom: -size.width * 0.2,
            left: -size.width * 0.2,
            right: -size.width * 0.2,
            child: AnimatedScale(
              scale: 1.2,
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              child: Container(
                width: size.width * 1.5,
                height: size.width * 1.5,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primary,
                ),
              ),
            ),
          ),

          /// Foreground content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  const Spacer(flex: 6),

                  /// Logo
                  Image.asset(
                    'assets/logo/logo.png',
                    width: size.width * 0.2, 
                  ),
                  SizedBox(height: size.height * 0.02),

                  /// Title
                  Text(
                    'Explore Phnom Penh\non Two Wheels',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32, 
                      fontWeight: FontWeight.w900,
                      color: AppColor.background,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  /// Subtitle
                  Text(
                    'Find nearby bikes, unlock in seconds,\nand ride wherever the city takes you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColor.primaryLight,
                    ),
                  ),

                  const Spacer(flex: 3),

                  /// Continue button
                  AppButton(
                    isprimaryColor: false,
                    label: 'Continue',
                    onPressed: () => _complete(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
