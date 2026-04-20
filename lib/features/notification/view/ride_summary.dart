import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/widgets/botton.dart';
import 'package:velo_toulose/features/notification/widgets/ride_station_info_widget.dart';
import 'package:velo_toulose/features/notification/widgets/ride_status_widget.dart';
import 'package:velo_toulose/features/notification/widgets/subscription_method_widget.dart';
import 'package:velo_toulose/models/ride.dart';

class RideSummaryScreen extends StatelessWidget {
  final Ride ride;
  final bool hasPass;
  final String plan;

  const RideSummaryScreen({
    super.key,
    required this.ride,
    required this.hasPass,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColor.textPrimary,
            size: 20,
          ),
        ),
        title: Text(
          'Ride Summary',
          style: AppTextStyle.heading.copyWith(fontSize: 22),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              const RideStatusWidget(),
              const SizedBox(height: 24),
              RideStationInfoWidget(ride: ride), // ← pass ride
              const SizedBox(height: 18),
              SubscriptionMethodWidget(ride: ride, hasPass: hasPass,plan: plan,),
              const SizedBox(height: 20),
              AppButton(
                isprimaryColor: true,
                label: 'Back to Map',
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
