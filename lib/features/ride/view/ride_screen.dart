import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/features/ride/widgets/cost_breakdown_card.dart';
import 'package:velo_toulose/features/ride/widgets/monthly_pass_card.dart';
import 'package:velo_toulose/features/ride/widgets/primary_button.dart';
import 'package:velo_toulose/features/ride/widgets/ride_info_card.dart';
import 'package:velo_toulose/features/ride/viewmodel/ride_view_model.dart';
import 'package:velo_toulose/features/ride/widgets/success_section.dart';

class RideSummaryScreen extends StatelessWidget {
  const RideSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RideViewModel>();

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
        actions: [
          IconButton(
            tooltip: 'Toggle pass mode',
            onPressed: () {
              context
                  .read<RideViewModel>()
                  .setHasMonthlyPass(!viewModel.hasMonthlyPass);
            },
            icon: Icon(
              viewModel.hasMonthlyPass ? Icons.toggle_on : Icons.toggle_off,
              color: AppColor.primary,
              size: 30,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: [
              const SuccessSection(),
              const SizedBox(height: 24),
              RideInfoCard(
                returnedTo: viewModel.returnedTo,
                duration: viewModel.duration,
                bikeId: viewModel.bikeId,
              ),
              const SizedBox(height: 18),
              viewModel.hasMonthlyPass
                  ? MonthlyPassCard(
                      headline: viewModel.monthlyPassHeadline,
                      line1: viewModel.monthlyPassLine1,
                      line2: viewModel.monthlyPassLine2,
                      total: viewModel.monthlyPassTotal,
                    )
                  : CostBreakdownCard(
                      firstSegmentLabel: viewModel.firstSegmentLabel,
                      firstSegmentPrice: viewModel.firstSegmentPrice,
                      firstSegmentNote: viewModel.firstSegmentNote,
                      secondSegmentLabel: viewModel.secondSegmentLabel,
                      secondSegmentPrice: viewModel.secondSegmentPrice,
                      secondSegmentNote: viewModel.secondSegmentNote,
                      totalAmount: viewModel.totalAmount,
                    ),
              const Spacer(),
              PrimaryButton(
                label: 'Back to Map',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
