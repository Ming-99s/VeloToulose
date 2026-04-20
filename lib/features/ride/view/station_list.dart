import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/models/station.dart';

class StationListSection extends StatelessWidget {
  const StationListSection({super.key});

  void _selectStation(BuildContext context, Station station) {
    context.read<MapViewModel>().selectStation(station);
    Navigator.of(context).pop(); // go back to map
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

                return _StationCard(
                  station: station,
                  freeSlots: freeSlots,
                  hasSlots: hasSlots,
                  distanceLabel: distance != null
                      ? _formatDistance(distance)
                      : null,
                  onTap: hasSlots
                      ? () => _selectStation(context, station)
                      : null,
                );
              },
            ),
          ),
      ],
    );
  }
}

class _StationCard extends StatelessWidget {
  final Station station;
  final int freeSlots;
  final bool hasSlots;
  final String? distanceLabel;
  final VoidCallback? onTap;

  const _StationCard({
    required this.station,
    required this.freeSlots,
    required this.hasSlots,
    required this.distanceLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final slotColor = hasSlots
        ? const Color(0xFF16A34A)
        : AppColor.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: hasSlots
                ? const Color(0xFF16A34A).withOpacity(0.25)
                : AppColor.border,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: hasSlots
                  ? const Color(0xFF16A34A).withOpacity(0.06)
                  : Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // dock icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: hasSlots
                    ? const Color(0xFF16A34A).withOpacity(0.08)
                    : AppColor.border.withOpacity(0.4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.dock_rounded, color: slotColor, size: 26),
            ),

            const SizedBox(width: 14),

            // station info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(station.name, style: AppTextStyle.cardTitle),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // availability dot
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: slotColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        hasSlots
                            ? '$freeSlots free dock${freeSlots > 1 ? 's' : ''}'
                            : 'Full — no docks',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: slotColor,
                        ),
                      ),
                      if (distanceLabel != null) ...[
                        const SizedBox(width: 8),
                        Text('·', style: AppTextStyle.subheading),
                        const SizedBox(width: 8),
                        Text(
                          distanceLabel!,
                          style: AppTextStyle.subheading.copyWith(fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // return button or full badge
            if (hasSlots)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primary.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Return',
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColor.white,
                      size: 14,
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColor.border.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Full',
                  style: TextStyle(
                    color: AppColor.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
