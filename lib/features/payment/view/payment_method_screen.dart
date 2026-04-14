import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/widgets/botton.dart';
import 'package:velo_toulose/features/payment/widgets/selected_bike_card.dart';
import 'package:velo_toulose/features/payment/view/pass_selection_screen.dart';
import 'package:velo_toulose/features/payment/view/booking_success_screen.dart';

enum PaymentMethodOption { payAsYouGo, selectPass }

class PaymentMethodScreen extends StatefulWidget {
  final String stationName;
  final String bikeType;
  final String bikeId;
  final String slotLabel;

  const PaymentMethodScreen({
    super.key,
    required this.stationName,
    required this.bikeType,
    required this.bikeId,
    required this.slotLabel,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentMethodOption _selected = PaymentMethodOption.payAsYouGo;

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

              // Booking summary label
              Center(
                child: Text('BOOKING SUMMARY', style: AppTextStyle.label),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  widget.stationName,
                  style: AppTextStyle.heading,
                ),
              ),
              const SizedBox(height: 20),

              // Selected Bike Card 
              SelectedBikeCard(
                bikeType: widget.bikeType,
                bikeId: widget.bikeId,
                slotLabel: widget.slotLabel,
              ),
              const SizedBox(height: 28),

              // Payment method section
              Text(
                'PAYMENT METHOD',
                style: AppTextStyle.label.copyWith(color: AppColor.textSecondary),
              ),
              const SizedBox(height: 12),

              // Pay-as-you-go option
              _PaymentOptionTile(
                icon: Icons.directions_bike,
                title: 'Pay-as-you-go',
                subtitle: '€2.50 per ride. First 30 minutes free,\nthen €0.05/min.',
                isSelected: _selected == PaymentMethodOption.payAsYouGo,
                onTap: () => setState(() => _selected = PaymentMethodOption.payAsYouGo),
              ),
              const SizedBox(height: 12),

              // Select a Pass option
              _PaymentOptionTile(
                icon: Icons.card_membership,
                title: 'Select a Pass',
                subtitle: 'Unlock unlimited rides with a daily,\nweekly, or monthly pass.',
                isSelected: _selected == PaymentMethodOption.selectPass,
                onTap: () => setState(() => _selected = PaymentMethodOption.selectPass),
              ),

              const Spacer(),

              // Price summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Booking Fee', style: AppTextStyle.subheading),
                  Text('€2.50', style: AppTextStyle.subheading),
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
                  Text('€2.50', style: AppTextStyle.priceTag),
                ],
              ),
              const SizedBox(height: 20),

              // Confirm button
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: AppButton(
                  label: 'Confirm Booking',
                  isprimaryColor: true,
                  trailingIcon: Icons.arrow_forward,
                  onPressed: () {
                    if (_selected == PaymentMethodOption.selectPass) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PassView(
                            bikeType: widget.bikeType,
                            bikeId: widget.bikeId,
                            stationName: widget.stationName,
                          ),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BookingSuccessScreen(
                            bikeType: widget.bikeType,
                            bikeId: widget.bikeId,
                            stationName: widget.stationName,
                          ),
                        ),
                      );
                    }
                  },
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
            // Icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.primary.withValues(alpha: 0.1)
                    : AppColor.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColor.primary, size: 22),
            ),
            const SizedBox(width: 12),
            // Text
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
            // Radio indicator
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