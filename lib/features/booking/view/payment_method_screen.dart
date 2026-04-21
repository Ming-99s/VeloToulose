import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/widgets/botton.dart';
import 'package:velo_toulose/features/booking/view/booking_success_screen.dart';
import 'package:velo_toulose/features/booking/view/pass_selection_screen.dart';
import 'package:velo_toulose/features/booking/viewmodel/payment_method_viewmodel.dart';
import 'package:velo_toulose/features/booking/viewmodel/user_pass_viewmodel.dart';
import 'package:velo_toulose/features/booking/widgets/selected_bike_card.dart';
import 'package:velo_toulose/features/profile/widgets/pass_card.dart';
import 'package:velo_toulose/models/pass.dart';
import 'package:velo_toulose/models/station.dart';

class PaymentMethodScreen extends StatelessWidget {
  final Station station;
  final String bikeId;
  final String slotLabel;

  const PaymentMethodScreen({
    super.key,
    required this.station,
    required this.bikeId,
    required this.slotLabel,
  });

  Future<void> _goToPassSelection(
    BuildContext context,
    PaymentMethodViewModel vm,
  ) async {
    final Pass? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PassView(bikeId: bikeId, station: station),
      ),
    );
    if (result != null) {
      vm.setSelectedPass(result);
    }
  }

  void _confirmBooking(
    BuildContext context,
    Pass? activePass,
    PaymentMethodViewModel vm,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookingSuccessScreen(
          bikeId: bikeId,
          stationName: station.name,
          stationId: station.stationId,
          usedPass: activePass ?? vm.selectedPass,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PaymentMethodViewModel>();
    final userPassVm = context.watch<UserPassViewModel>();
    final hasActivePass = userPassVm.hasActivePass;
    final activePass = userPassVm.activePass;

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: Text(
          'Confirm your ride',
          style: AppTextStyle.cardTitle.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              Center(child: Text('BOOKING SUMMARY', style: AppTextStyle.label)),
              const SizedBox(height: 8),
              Center(
                child: Text(station.name, style: AppTextStyle.heading),
              ),
              const SizedBox(height: 20),

              SelectedBikeCard(bikeId: bikeId, slotLabel: slotLabel),
              const SizedBox(height: 28),

              Text(
                'PAYMENT METHOD',
                style: AppTextStyle.label.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
              const SizedBox(height: 12),

              if (hasActivePass) ...[
                PassCard(
                  pass: activePass!,
                  onPressed: () => _goToPassSelection(context, vm),
                ),
                const SizedBox(height: 8),
              ] else ...[
                _PaymentOptionTile(
                  icon: Icons.directions_bike,
                  title: 'Pay-as-you-go',
                  subtitle:
                      '€2.50 per ride. First 30 min free,\nthen €0.05/min.',
                  isSelected: vm.selected == PaymentMethodOption.payAsYouGo,
                  onTap: vm.selectPayAsYouGo,
                ),
                const SizedBox(height: 12),

                _PaymentOptionTile(
                  icon: Icons.card_membership,
                  title: 'Select a Pass',
                  subtitle: 'Rides with a daily, weekly, or annual pass.',
                  isSelected: vm.selected == PaymentMethodOption.selectPass,
                  onTap: () => _goToPassSelection(context, vm),
                ),
              ],

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Booking Fee', style: AppTextStyle.subheading),
                  Text(
                    hasActivePass
                        ? 'Free'
                        : vm.selected == PaymentMethodOption.selectPass &&
                              vm.selectedPass != null
                        ? 'Free'
                        : '€${PaymentMethodViewModel.unlockFee.toStringAsFixed(2)}',
                    style: AppTextStyle.subheading,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Today',
                    style: AppTextStyle.cardTitle.copyWith(fontSize: 18),
                  ),
                  Text(
                    hasActivePass ? 'Free' : vm.priceLabel,
                    style: AppTextStyle.priceTag,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: AppButton(
                  label: 'Confirm Booking',
                  isprimaryColor: true,
                  trailingIcon: Icons.arrow_forward,
                  onPressed: () => _confirmBooking(
                    context,
                    hasActivePass ? activePass : null,
                    vm,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryLight : AppColor.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColor.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColor.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyle.cardTitle),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyle.feature),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColor.primary : AppColor.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
