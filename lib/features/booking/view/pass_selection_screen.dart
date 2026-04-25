import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/widgets/botton.dart';
import 'package:velo_toulose/features/booking/viewmodel/pass_viewmode.dart';
import 'package:velo_toulose/features/booking/viewmodel/user_pass_viewmodel.dart';
import 'package:velo_toulose/features/booking/widgets/pass_cart.dart';
import 'package:velo_toulose/features/notification/viewmodel/notification_view_model.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/models/station.dart';

class PassView extends StatelessWidget {
  final String? bikeId;
  final Station? station;

  const PassView({super.key, this.bikeId, this.station});

  @override
  Widget build(BuildContext context) {
    final passVm = context.watch<PassViewModel>();
    final userPassVm = context.read<UserPassViewModel>();
    final notiVm = context.read<NotificationViewModel>();
    final authVm = context.read<AuthViewModel>();

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
          'Subscription',
          style: AppTextStyle.cardTitle.copyWith(fontSize: 18),
        ),
      ),
      // no loading state — plans are static, no async needed
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text('Choose your plan', style: AppTextStyle.heading),
              const SizedBox(height: 8),
              const Text(
                'Select the best option for your commute in Toulouse.',
                style: AppTextStyle.subheading,
              ),
              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...passVm.plans.asMap().entries.map((entry) {
                        final index = entry.key;
                        final plan = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: PassCard(
                            title: plan.title,
                            price: '€${plan.price.toStringAsFixed(0)}',
                            period: plan.period,
                            features: plan.features,
                            isSelected: passVm.selectedIndex == index,
                            onTap: () => passVm.selectPass(index),
                            badge: plan.badge,
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: AppButton(
                  label: 'Upgrade Plan',
                  isprimaryColor: true,
                 onPressed: () async {
                    final userId = authVm.currentUser!.userId;

                    final pass = await passVm
                        .purchaseSelectedPass(); 

                    await userPassVm.activatePass(pass);
                    notiVm.addPassPurchase(pass, userId);

                    if (bikeId != null && station != null) {
                      Navigator.of(context).pop(pass);
                    } else {
                      Navigator.of(context).pop();
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
