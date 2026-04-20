import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/features/ride/view/station_list.dart';
import 'package:velo_toulose/features/ride/view/timer_section.dart';
import 'package:velo_toulose/features/ride/viewmodel/ride_view_model.dart';

class RideActiveScreen extends StatelessWidget {
  const RideActiveScreen({super.key,required this.mapController});
  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    final rideVm = context.watch<RideViewModel>();
    final ride = rideVm.activeRide;

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            // custom top bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.border),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(53, 107, 114, 128),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColor.textPrimary,
                        size: 16,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        'Active Ride',
                        style: AppTextStyle.heading,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // timer card
                    const TimerSection(),

                    const SizedBox(height: 16),

                    // ride info strip
                    if (ride != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColor.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _RideInfoChip(
                              icon: Icons.pedal_bike_rounded,
                              label: 'Bike',
                              value: '#${ride.bikeId}',
                            ),
                            Container(
                              width: 1,
                              height: 32,
                              color: AppColor.border,
                            ),
                            _RideInfoChip(
                              icon: Icons.timer_outlined,
                              label: 'Free time',
                              value: '30 min',
                            ),
                            Container(
                              width: 1,
                              height: 32,
                              color: AppColor.border,
                            ),
                            _RideInfoChip(
                              icon: Icons.euro_rounded,
                              label: 'After free',
                              value: '€0.05/min',
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    Expanded(child: StationListSection(mapController: mapController,)),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RideInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _RideInfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColor.primary, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColor.textSecondary),
        ),
      ],
    );
  }
}
