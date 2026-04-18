import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/widgets/botton.dart';
import 'package:velo_toulose/features/ride/view/ride_active_screen.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String bikeType;
  final String bikeId;
  final String stationName;

  const BookingSuccessScreen({
    super.key,
    required this.bikeType,
    required this.bikeId,
    required this.stationName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Lottie bike animation
              Lottie.asset(
                'assets/stickers/bike.json',
                width: 200,
                height: 200,
                repeat: true,
              ),
              const SizedBox(height: 32),

              // Success icon
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primaryLight,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColor.primary,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Booking Confirmed!',
                style: AppTextStyle.heading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Enjoy your ride',
                style: AppTextStyle.subheading.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Ride details card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _DetailRow(label: 'Bike', value: '$bikeType #$bikeId'),
                    const SizedBox(height: 12),
                    const Divider(color: AppColor.border, height: 1),
                    const SizedBox(height: 12),
                    _DetailRow(label: 'Station', value: stationName),
                    const SizedBox(height: 12),
                    const Divider(color: AppColor.border, height: 1),
                    const SizedBox(height: 12),
                    _DetailRow(label: 'Status', value: 'Unlocked'),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // Start Riding button — pops back to map
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: AppButton(
                  label: 'Start Riding',
                  isprimaryColor: true,
                  trailingIcon: Icons.pedal_bike,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const RideActiveScreen(),
                      ),
                      (route) => route.isFirst,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.subheading),
        Text(
          value,
          style: AppTextStyle.cardTitle.copyWith(color: AppColor.primary),
        ),
      ],
    );
  }
}
