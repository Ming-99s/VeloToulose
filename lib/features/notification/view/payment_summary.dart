import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/enum/notification_type.dart';
import 'package:velo_toulose/core/widgets/botton.dart';
import 'package:velo_toulose/models/notification.dart';
import 'package:velo_toulose/models/payment.dart';

class PaymentSummaryScreen extends StatelessWidget {
  final Payment payment;
  final AppNotification notification;

  const PaymentSummaryScreen({
    super.key,
    required this.payment,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          'Payment Summary',
          style: AppTextStyle.heading.copyWith(fontSize: 22),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              _PaymentStatusWidget(type: notification.type),
              const SizedBox(height: 24),
              _PaymentInfoWidget(payment: payment),
              const SizedBox(height: 18),
              _PaymentBreakdownWidget(payment: payment),
              const SizedBox(height: 20),
              AppButton(
                isprimaryColor: true,
                label: 'Back to Map',
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// Status Icon + Title 

class _PaymentStatusWidget extends StatelessWidget {
  final NotificationType type;

  const _PaymentStatusWidget({required this.type});

  String get _title => switch (type) {
    NotificationType.unlockFee => 'Unlock Fee Charged',
    NotificationType.overtimeFee => 'Overtime Fee Charged',
    NotificationType.passPurchase => 'Pass Purchased Successfully',
    NotificationType.rideReceipt => 'Payment Confirmed',
  };

  String get _subtitle => switch (type) {
    NotificationType.unlockFee => 'Your bike is unlocked. Enjoy your ride!',
    NotificationType.overtimeFee => 'Overtime charge applied to your account.',
    NotificationType.passPurchase =>
      'Your pass is now active and ready to use.',
    NotificationType.rideReceipt => 'Thank you for riding with Vélo Toulouse.',
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              color: AppColor.primaryLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColor.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_rounded,
                color: AppColor.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _title,
            textAlign: TextAlign.center,
            style: AppTextStyle.heading,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyle.subheading,
            ),
          ),
        ],
      ),
    );
  }
}

// Payment Info 

class _PaymentInfoWidget extends StatelessWidget {
  final Payment payment;

  const _PaymentInfoWidget({required this.payment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
      decoration: BoxDecoration(
        color: AppColor.primaryLight,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColor.textPrimary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoLine(label: 'Payment ID', value: '#${payment.paymentId}'),
          const SizedBox(height: 18),
          _InfoLine(
            label: 'Date',
            value:
                '${payment.createdAt.day}/${payment.createdAt.month}/${payment.createdAt.year}',
          ),
          const SizedBox(height: 18),
          _InfoLine(label: 'Type', value: payment.type.name),
        ],
      ),
    );
  }
}

//  Payment Breakdown 

class _PaymentBreakdownWidget extends StatelessWidget {
  final Payment payment;

  const _PaymentBreakdownWidget({required this.payment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
      decoration: BoxDecoration(
        color: AppColor.primaryLight,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColor.textPrimary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'COST BREAKDOWN',
            style: AppTextStyle.label.copyWith(
              fontSize: 10,
              letterSpacing: 3,
              color: AppColor.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: Text(
                  payment.type.name,
                  style: AppTextStyle.cardTitle.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '€${payment.amount.toStringAsFixed(2)}',
                style: AppTextStyle.cardTitle.copyWith(
                  fontSize: 15,
                  color: AppColor.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: AppColor.border, thickness: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Text('Total', style: AppTextStyle.cardTitle),
              ),
              Text(
                '€${payment.amount.toStringAsFixed(2)}',
                style: AppTextStyle.priceTag.copyWith(
                  fontSize: 20,
                  color: AppColor.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Shared Info Line ─────────────────────────────────────────────────────────

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label.toUpperCase(),
            style: AppTextStyle.label.copyWith(
              fontSize: 11,
              letterSpacing: 1.4,
              color: AppColor.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(value, style: AppTextStyle.cardTitle),
      ],
    );
  }
}
