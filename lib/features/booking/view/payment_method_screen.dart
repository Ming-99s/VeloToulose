import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/widgets/botton.dart';
import 'package:velo_toulose/features/booking/view/booking_success_screen.dart';
import 'package:velo_toulose/features/booking/view/pass_selection_screen.dart';
import 'package:velo_toulose/features/booking/widgets/selected_bike_card.dart';
import 'package:velo_toulose/models/pass.dart';
import 'package:velo_toulose/models/station.dart';

enum PaymentMethodOption { payAsYouGo, selectPass }

class PaymentMethodScreen extends StatefulWidget {
  final Station station;
  final String bikeId;
  final String slotLabel;

  const PaymentMethodScreen({
    super.key,
    required this.station,
    required this.bikeId,
    required this.slotLabel,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentMethodOption _selected = PaymentMethodOption.payAsYouGo;
  Pass? _selectedPass; // ← holds pass chosen from PassView

  static const double unlockFee = 2.50;

  // if pass selected → free, otherwise €2.50
  double get totalPrice => _selectedPass != null ? 0.0 : unlockFee;

  String get priceLabel =>
      _selectedPass != null ? 'Free' : '€${unlockFee.toStringAsFixed(2)}';

  Future<void> _goToPassSelection() async {
    // navigate to PassView and wait for result
    final Pass? result = await Navigator.of(context).push<Pass>(
      MaterialPageRoute(
        builder: (_) => PassView(
          bikeId: widget.bikeId,
          station: widget.station,
        ),
      ),
    );

    // user selected a pass and came back
    if (result != null) {
      setState(() {
        _selectedPass = result;
        _selected = PaymentMethodOption.selectPass;
      });
    }
  }

  void _confirmBooking() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookingSuccessScreen(
          bikeId: widget.bikeId,
          stationName: widget.station.name,
          stationId: widget.station.stationId,
          usedPass: _selectedPass, // null = pay as you go
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                child: Text(widget.station.name, style: AppTextStyle.heading),
              ),
              const SizedBox(height: 20),

              SelectedBikeCard(
                bikeId: widget.bikeId,
                slotLabel: widget.slotLabel,
              ),
              const SizedBox(height: 28),

              Text(
                'PAYMENT METHOD',
                style: AppTextStyle.label.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
              const SizedBox(height: 12),

              // pay as you go
              _PaymentOptionTile(
                icon: Icons.directions_bike,
                title: 'Pay-as-you-go',
                subtitle: '€2.50 per ride. First 30 min free,\nthen €0.05/min.',
                isSelected: _selected == PaymentMethodOption.payAsYouGo,
                onTap: () => setState(() {
                  _selected = PaymentMethodOption.payAsYouGo;
                  _selectedPass = null; // clear pass if switching back
                }),
              ),
              const SizedBox(height: 12),

              // select pass — tapping opens PassView
              _PaymentOptionTile(
                icon: Icons.card_membership,
                title: _selectedPass != null
                    ? 'Pass: ${_selectedPass!.type.name}' // show selected pass name
                    : 'Select a Pass',
                subtitle: _selectedPass != null
                    ? 'No bike fee — covered by your pass ✓'
                    : 'Unlimited rides with a daily, weekly, or annual pass.',
                isSelected: _selected == PaymentMethodOption.selectPass,
                onTap: _goToPassSelection, // ← opens PassView, waits for result
              ),

              const Spacer(),

              // price summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Booking Fee', style: AppTextStyle.subheading),
                  Text(
                    _selected == PaymentMethodOption.selectPass &&
                            _selectedPass != null
                        ? 'Free'
                        : '€${unlockFee.toStringAsFixed(2)}',
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
                  Text(priceLabel, style: AppTextStyle.priceTag),
                ],
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: AppButton(
                  label: 'Confirm Booking',
                  isprimaryColor: true,
                  trailingIcon: Icons.arrow_forward,
                  onPressed: _confirmBooking,
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
                color: isSelected
                    ? AppColor.primary.withOpacity(0.1)
                    : AppColor.primaryLight,
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
