import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/features/ride/widgets/station_list_section.dart';
import 'package:velo_toulose/features/ride/widgets/timer_section.dart';

class RideActiveScreen extends StatelessWidget {
  final bool startTimer;

  const RideActiveScreen({super.key, this.startTimer = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColor.textPrimary,
            size: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            children: [
              TimerSection(autoStart: startTimer),
              const SizedBox(height: 20),
              const Expanded(child: StationListSection()),
            ],
          ),
        ),
      ),
    );
  }
}
