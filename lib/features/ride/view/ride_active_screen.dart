import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/features/ride/widgets/station_list_section.dart';
import 'package:velo_toulose/features/ride/widgets/timer_section.dart';

class RideActiveScreen extends StatelessWidget {
  const RideActiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            children: [
              TimerSection(),
              SizedBox(height: 20),
              Expanded(child: StationListSection()),
            ],
          ),
        ),
      ),
    );
  }
}
