import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/utils/timer_util.dart';
import 'package:velo_toulose/features/ride/viewmodel/ride_view_model.dart';

class TimerSection extends StatefulWidget {
  const TimerSection({super.key});

  @override
  State<TimerSection> createState() => _TimerSectionState();
}

class _TimerSectionState extends State<TimerSection> {
  Timer? _ticker;


  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // watch so widget rebuilds when ride changes
    final ride = context.watch<RideViewModel>().activeRide;
    final time = TimeUtils(activeRide: ride); // fresh every second
    final isOvertime = time.isOvertime;
    final color = isOvertime ? AppColor.red : AppColor.primary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isOvertime
              ? [AppColor.red.withOpacity(0.08), AppColor.red.withOpacity(0.03)]
              : [AppColor.primary.withOpacity(0.08), AppColor.primaryLight],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          children: [
            // status chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    isOvertime ? 'OVERTIME' : 'RIDE IN PROGRESS',
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),


              Text(
                time.timerLabel,
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: -2,
                  height: 1,
                ),
              ),
            
            const SizedBox(height: 4),
            Text(
              'mm : ss',
              style: TextStyle(
                fontSize: 11,
                color: color.withOpacity(0.5),
                fontWeight: FontWeight.w500,
                letterSpacing: 3,
              ),
            ),

            const SizedBox(height: 16),
            Container(height: 1, color: color.withOpacity(0.1)),
            const SizedBox(height: 16),

            // status label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isOvertime
                      ? Icons.warning_amber_rounded
                      : Icons.timer_outlined,
                  color: color,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    time.statusLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            if (isOvertime) ...[
              const SizedBox(height: 8),
              Text(
                'Return the bike to stop extra charges',
                textAlign: TextAlign.center,
                style: AppTextStyle.subheading.copyWith(fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
