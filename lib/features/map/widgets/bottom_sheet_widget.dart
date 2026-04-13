import 'package:flutter/material.dart';
import 'package:velo_toulose/features/map/utils/distance_format.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/models/station.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({
    super.key,
    required this.station,
    required this.viewModel,
    required this.scrollController
    
  });

  final Station station;
  final MapViewModel viewModel;
  final ScrollController scrollController;

@override
Widget build(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
    ),
    child: ListView( 
      controller: scrollController, 
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      shrinkWrap: true,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              station.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => viewModel.clearSelectedStation(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              viewModel.userLocation != null
                  ? DistanceUtils.formatted(viewModel.userLocation!, station.location)
                  : 'Distance unavailable',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.pedal_bike, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text('${station.availableBikes} / ${station.capacity} bikes available'),
          ],
        ),
        const SizedBox(height: 16),
      ],
    ),
  );

  }
}
