import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/features/onBoarding/view/on-boarding_screen.dart';
import 'package:velo_toulose/main_common.dart';

class SplashScreen extends StatefulWidget {
  final bool onboardingDone;

  const SplashScreen({super.key, required this.onboardingDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;
  late AnimationController _circleScaleController;
  late AnimationController _circleFadeController;
  late Animation<double> _circleRadiusAnimation;
  late Animation<double> _circleFadeAnimation;

  @override
  void initState() {
    super.initState();

    _lottieController = AnimationController(vsync: this);

    _circleScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _circleFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _circleFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _circleFadeController, curve: Curves.easeIn),
    );
  }

  Future<void> _startCircleAnimation() async {
    final auth = context.read<AuthViewModel>();
    await auth.restoreSession();

    await _circleScaleController.forward();
    await _circleFadeController.forward();

    if (!mounted) return;

    // 1. Onboarding not done  => show onboarding
    // 2. Onboarding done      => go to app (both guests and logged-in users)
    //    Login check happens later when user tries to book a bike
    final Widget next = widget.onboardingDone
        ? const MyApp()
        : const OnBoardingScreen();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => next,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _circleScaleController.dispose();
    _circleFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final maxRadius =
        sqrt(pow(size.width / 2, 2) + pow(size.height / 2, 2)) + 20;

    _circleRadiusAnimation = Tween<double>(begin: 0, end: maxRadius).animate(
      CurvedAnimation(parent: _circleScaleController, curve: Curves.easeInOut),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Lottie.asset(
              'assets/logo/velo_tolouse.json',
              controller: _lottieController,
              onLoaded: (composition) {
                _lottieController
                  ..duration = composition.duration * 0.8
                  ..forward().whenComplete(_startCircleAnimation);
              },
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _circleScaleController,
                _circleFadeController,
              ]),
              builder: (context, child) {
                return Opacity(
                  opacity: _circleFadeAnimation.value,
                  child: CustomPaint(
                    painter: _CircleRevealPainter(
                      radius: _circleRadiusAnimation.value,
                      color: const Color(0xFFFF5C00),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleRevealPainter extends CustomPainter {
  final double radius;
  final Color color;

  _CircleRevealPainter({required this.radius, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_CircleRevealPainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.color != color;
  }
}
