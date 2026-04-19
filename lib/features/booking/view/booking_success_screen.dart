import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/widgets/botton.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/features/ride/viewmodel/ride_view_model.dart';

class BookingSuccessScreen extends StatefulWidget {
  final String bikeType;
  final String bikeId;
  final String stationName;
  final String stationId;

  const BookingSuccessScreen({
    super.key,
    required this.bikeType,
    required this.bikeId,
    required this.stationName,
    required this.stationId,
  });

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> {
  @override
  void initState() {
    super.initState();
    // start ride as soon as booking is confirmed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startRide();
    });
  }

  Future<void> _startRide() async {
    final rideViewModel = context.read<RideViewModel>();
    final authViewModel = context.read<AuthViewModel>();

    await rideViewModel.startRide(
      userId: authViewModel.currentUser?.userId ?? 'guest',
      bikeId: widget.bikeId,
      startStationId: widget.stationId,
    );
  }

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

              Lottie.asset(
                'assets/stickers/bike.json',
                width: 200,
                height: 200,
                repeat: true,
              ),
              const SizedBox(height: 32),

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

              const Text(
                'Booking Confirmed!',
                style: AppTextStyle.heading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              Text(
                'Enjoy your ride',
                style: AppTextStyle.subheading.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      label: 'Bike',
                      value: '${widget.bikeType} #${widget.bikeId}',
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: AppColor.border, height: 1),
                    const SizedBox(height: 12),
                    _DetailRow(label: 'Station', value: widget.stationName),
                    const SizedBox(height: 12),
                    const Divider(color: AppColor.border, height: 1),
                    const SizedBox(height: 12),
                    _DetailRow(label: 'Status', value: 'Unlocked'),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: AppButton(
                  label: 'Start Riding',
                  isprimaryColor: true,
                  trailingIcon: Icons.pedal_bike,
                  onPressed: () {
                    // pop all the way back to map — ride banner will show
                    Navigator.of(context).popUntil((route) => route.isFirst);
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
