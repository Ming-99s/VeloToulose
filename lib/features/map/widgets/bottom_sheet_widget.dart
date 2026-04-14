import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/features/map/utils/distance_format.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/features/map/widgets/bike_tile.dart';
import 'package:velo_toulose/features/payment/view/payment_method_screen.dart';
import 'package:velo_toulose/models/bike.dart';
import 'package:velo_toulose/models/station.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({
    super.key,
    required this.station,
    required this.viewModel,
    required this.scrollController,
  });

  final Station station;
  final MapViewModel viewModel;
  final ScrollController scrollController;

  void _toConfirmRide(BuildContext context,station,bike){
      Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PaymentMethodScreen(
                  station: station,  
                  bikeType: bike.type,
                  bikeId: bike.bikeId,
                  slotLabel: bike.slotId ?? '-',
                ),
              ),
              );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: SingleChildScrollView(
        controller: scrollController, 
        child: Column(
          children: [
            const SizedBox(height: 12),

            /// Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        station.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            viewModel.userLocation != null
                                ? DistanceUtils.formatted(
                                    viewModel.userLocation!,
                                    station.location,
                                  )
                                : 'Distance unavailable',
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    decoration: BoxDecoration(
                      color: AppColor.primaryLight,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColor.primary),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.pedal_bike,
                              size: 30,
                              color: AppColor.primary,
                            ),
                            const Text(
                              'Available Bike',
                              style: AppTextStyle.pricePeriod,
                            ),
                          ],
                        ),
                        Text(
                          '${station.availableBikes}',
                          style: AppTextStyle.priceTag,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'AVAILABLE BIKE',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            ///BIKE LIST 
            ListView(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), 
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              children: [
                ...viewModel
                    .getBikesAt(station)
                    .map((bike) => BikeTile(bike: bike, stationName: station.name,onTap: ()=> _toConfirmRide(context,station,bike),))
                    .toList(),

                if (viewModel.getBikesAt(station).isEmpty)
                  const Center(
                    child: Text(
                      'No bikes available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
