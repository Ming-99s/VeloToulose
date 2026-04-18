import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/models/station.dart';
import 'package:velo_toulose/repositories/abstract/station_repostiory.dart';

class StationListSection extends StatefulWidget {
  const StationListSection({super.key});

  @override
  State<StationListSection> createState() => _StationListSectionState();
}

class _StationListSectionState extends State<StationListSection> {
  late final Future<List<Station>> _stationsFuture;

  @override
  void initState() {
    super.initState();
    _stationsFuture = context.read<StationRepostiory>().loadStations();
  }

  String _formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    }
    return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    final mapViewModel = context.watch<MapViewModel>();

    return FutureBuilder<List<Station>>(
      future: _stationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Unable to load stations.',
              style: AppTextStyle.subheading,
            ),
          );
        }

        final stations = snapshot.data ?? [];

        if (stations.isEmpty) {
          return Center(
            child: Text(
              'No return stations available.',
              style: AppTextStyle.subheading,
            ),
          );
        }

        return ListView.builder(
          itemCount: stations.length,
          itemBuilder: (context, index) {
            final station = stations[index];
            final distance = mapViewModel.getDistanceTo(station);

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColor.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(station.name, style: AppTextStyle.cardTitle),
                        if (distance != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            _formatDistance(distance),
                            style: AppTextStyle.subheading,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      foregroundColor: AppColor.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Return Here', style: AppTextStyle.buttonText),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
