import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/features/ride/widgets/return_station_card.dart';
import 'package:velo_toulose/models/station.dart';

class StationListSection extends StatelessWidget {
  const StationListSection({super.key,required this.mapController});

  final MapController mapController;

  void _selectStation(Station station, BuildContext context) {
    context.read<MapViewModel>().selectStation(station);

    // move map to station location after popping back
    Navigator.pop(context);

    // small delay to let the screen transition finish first
    Future.delayed(const Duration(milliseconds: 300), () {
      mapController.move(station.location, 17.0); // zoom in on station
    });
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
        // section header
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
                  onTap: hasSlots
                      ? () => _selectStation(station,context)
                      : null,
                );
              },
            ),
          ),
      ],
    );
  }
}
