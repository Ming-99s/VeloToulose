import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/features/notification/view/ride_summary.dart';
import 'package:velo_toulose/features/ride/viewmodel/ride_view_model.dart';
import 'package:velo_toulose/features/ride/widgets/return_station_card.dart';
import 'package:velo_toulose/models/station.dart';

class StationListSection extends StatelessWidget {
  const StationListSection({super.key, required this.mapController});

  final MapController mapController;

  Future<void> _returnBike(Station station, BuildContext context) async {
    final rideVm = context.read<RideViewModel>();

    // show loading while endRide runs
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final endedRide = await rideVm.endRide(station.stationId);

    if (!context.mounted) return;
    Navigator.pop(context); // dismiss loading dialog

    if (endedRide == null) {
      // endRide failed — show error and stay on screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(rideVm.error ?? 'Could not return bike. Try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // success — go to ride summary, clearing the active ride screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RideSummaryScreen(
          ride: endedRide,
          hasPass: false, // TODO: pass real value from auth/user viewmodel
          plan: 'Pay as you go',
        ),
      ),
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.toStringAsFixed(0)} m away';
    return '${(meters / 1000).toStringAsFixed(1)} km away';
  }

  @override
  Widget build(BuildContext context) {
    final mapVm = context.watch<MapViewModel>();
    final stations = mapVm.stations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 18,
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'RETURN STATIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: AppColor.textSecondary,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${stations.length} stations',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        if (stations.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Icon(Icons.dock, size: 48, color: AppColor.border),
                  const SizedBox(height: 12),
                  Text('No stations available', style: AppTextStyle.subheading),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              itemCount: stations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final station = stations[index];
                final freeSlots = station.getFreeSlots().length;
                final hasSlots = freeSlots > 0;
                final distance = mapVm.getDistanceTo(station);

                return StationCard(
                  station: station,
                  freeSlots: freeSlots,
                  hasSlots: hasSlots,
                  distanceLabel: distance != null
                      ? _formatDistance(distance)
                      : null,
                  onTap: hasSlots ? () => _returnBike(station, context) : null,
                );
              },
            ),
          ),
      ],
    );
  }
}
