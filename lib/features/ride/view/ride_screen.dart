import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/features/ride/widgets/primary_button_widget.dart';
import 'package:velo_toulose/features/ride/widgets/ride_station_info_widget.dart';
import 'package:velo_toulose/features/ride/widgets/ride_status_widget.dart';
import 'package:velo_toulose/features/ride/widgets/subscription_method_widget.dart';

class RideSummaryScreen extends StatefulWidget {
  const RideSummaryScreen({super.key});

  @override
  State<RideSummaryScreen> createState() => _RideSummaryScreenState();
}

class _RideSummaryScreenState extends State<RideSummaryScreen> {
  bool isMonthlyPass = false;

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
        title: const Text(
          'Ride Summary',
          style: TextStyle(
            color: AppColor.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const RideStatusWidget(),
                          const SizedBox(height: 24),
                          const RideStationInfoWidget(),
                          const SizedBox(height: 18),
                          SubscriptionMethodWidget(
                            isMonthlyPass: isMonthlyPass,
                            onTap: () {
                              setState(() {
                                isMonthlyPass = !isMonthlyPass;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      PrimaryButtonWidget(
                        label: 'Back to Map',
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
