import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/enum/payment_type.dart';
import 'package:velo_toulose/core/utils/id_generator.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/features/booking/viewmodel/user_pass_viewmodel.dart';
import 'package:velo_toulose/features/map/utils/distance_format.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/features/map/widgets/bike_tile.dart';
import 'package:velo_toulose/features/map/widgets/empty_dock.dart';
import 'package:velo_toulose/features/notification/viewmodel/notification_view_model.dart';
import 'package:velo_toulose/features/ride/viewmodel/ride_view_model.dart';
import 'package:velo_toulose/features/booking/view/payment_method_screen.dart';
import 'package:velo_toulose/models/bike.dart';
import 'package:velo_toulose/models/payment.dart';
import 'package:velo_toulose/models/station.dart';
import 'package:velo_toulose/repositories/abstract/payment_repository.dart';

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

  Future<void> endRide(BuildContext context) async {
    final endedRide = await context.read<RideViewModel>().endRide(
      station.stationId,
    );
    if (endedRide == null || !context.mounted) return;

    final hasPass = context.read<UserPassViewModel>().hasActivePass;
    final payRepo = context.read<PaymentRepository>();
    final userId = context.read<AuthViewModel>().currentUser!.userId;

    // charge overtime if applicable and no pass
    if (!hasPass && endedRide.isOvertime()) {
      final overtimeCost = endedRide.calculateCost(hasPass: false) - 2.50;
      await payRepo.savePayment(
        Payment(
          paymentId: IdGenerator.payment(),
          userId: userId,
          type: PaymentType.overtimeFee,
          amount: overtimeCost,
          createdAt: DateTime.now(),
          rideId: endedRide.rideId,
        ),
      );
    }

    if (!context.mounted) return;

    context.read<NotificationViewModel>().addRideReceipt(
      endedRide,
      hasPass: hasPass,
    );

    // reload this station's bikes and docks after return
    await context.read<MapViewModel>().loadBikesByStation(station.stationId);
    await context.read<MapViewModel>().loadDockByStation(station.stationId);

    if (context.mounted) {
      viewModel.clearSelectedStation();
    }
  }

  void _toConfirmRide(BuildContext context, Station station, Bike bike) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaymentMethodScreen(
          station: station,
          bikeId: bike.bikeId,
          slotLabel: bike.slotId!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rideViewModel = context.watch<RideViewModel>();
    final hasActiveRide = rideViewModel.hasActiveRide;

    // empty slots where user can return their bike
    final emptySlots = viewModel.getDockAt();
    final availableBikes = viewModel.getBikesAt();

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

            // drag handle
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

            // header
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

                  // stats row
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
                        // available bikes
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.pedal_bike,
                              size: 30,
                              color: AppColor.primary,
                            ),
                            const Text(
                              'Available',
                              style: AppTextStyle.pricePeriod,
                            ),
                            Text(
                              '${availableBikes.length}',
                              style: AppTextStyle.priceTag,
                            ),
                          ],
                        ),
                        // divider
                        Container(
                          width: 1,
                          height: 50,
                          color: AppColor.primary,
                        ),
                        // empty docks
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.dock,
                              size: 30,
                              color: AppColor.primary,
                            ),
                            const Text(
                              'Empty docks',
                              style: AppTextStyle.pricePeriod,
                            ),
                            Text(
                              '${emptySlots.length}',
                              style: AppTextStyle.priceTag,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // available bikes section
            if (availableBikes.isNotEmpty && !hasActiveRide) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'AVAILABLE BIKES',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                children: availableBikes
                    .map(
                      (bike) => BikeTile(
                        bike: bike,
                        stationName: station.name,
                        onTap: () => _toConfirmRide(context, station, bike),
                      ),
                    )
                    .toList(),
              ),
            ],

            if (availableBikes.isEmpty && !hasActiveRide)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'No bikes available at this station',
                    style: TextStyle(color: AppColor.textSecondary),
                  ),
                ),
              ),

            // empty docks section — only show when user has active ride
            if (hasActiveRide && emptySlots.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'RETURN YOUR BIKE HERE',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                children: emptySlots
                    .map(
                      (slot) => EmptyDockTile(
                        slot: slot,
                        onReturn: () => endRide(context),
                      ),
                    )
                    .toList(),
              ),
            ],

            if (!hasActiveRide || emptySlots.isEmpty)
              const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
