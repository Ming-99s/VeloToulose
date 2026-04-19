import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/widgets/botton.dart';
import 'package:velo_toulose/features/booking/viewmodel/pass_viewmode.dart';
import 'package:velo_toulose/features/booking/widgets/pass_cart.dart';
import 'package:velo_toulose/features/booking/view/booking_success_screen.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/features/notification/viewmodel/notification_view_model.dart';
import 'package:velo_toulose/models/station.dart';

class PassView extends StatelessWidget {
  final String? bikeType;
  final String? bikeId;
  final Station? station;

  const PassView({
    super.key,
    this.bikeType,
    this.bikeId,
    this.station,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PassViewModel>();

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
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColor.primary))
          : viewModel.errorMessage != null
              ? Center(child: Text(viewModel.errorMessage!))
              : SafeArea(
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
                                ...viewModel.passes.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final pass = entry.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: PassCard(
                                      title: _passTitle(pass.type.name),
                                      price: '€${pass.price.toStringAsFixed(0)}',
                                      period: _passPeriod(pass.type.name),
                                      features: _passFeatures(pass.type.name),
                                      isSelected: viewModel.selectedIndex == index,
                                      onTap: () => viewModel.selectPass(index),
                                      badge: pass.type.name == 'annual' ? 'BEST VALUE' : null,
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
                            label: 'Continue',
                            isprimaryColor: true,
                            onPressed: () {
                              viewModel.activatePass();

                              // Send a notification for the pass purchase
                              final pass = viewModel.activePass;
                              if (pass != null) {
                                final userId = context.read<AuthViewModel>().currentUser?.userId ?? 'guest';
                                context.read<NotificationViewModel>().addPassPurchase(pass, userId);
                              }

                              if (bikeType != null && bikeId != null && station != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BookingSuccessScreen(
                                      bikeType: bikeType!,
                                      bikeId: bikeId!,
                                      stationName: station!.name,
                                      stationId: station!.stationId,
                                    ),
                                  ),
                                );
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

  String _passTitle(String typeName) {
    switch (typeName) {
      case 'daily':
        return 'Day Pass';
      case 'weekly':
        return 'Monthly';
      case 'annual':
        return 'Year Pass';
      default:
        return typeName;
    }
  }

  String _passPeriod(String typeName) {
    switch (typeName) {
      case 'daily':
        return '/24h';
      case 'weekly':
        return '/mo';
      case 'annual':
        return '/yr';
      default:
        return '';
    }
  }

  List<String> _passFeatures(String typeName) {
    switch (typeName) {
      case 'daily':
        return ['First 30m free', 'Unlimited trips', 'City-wide access'];
      case 'weekly':
        return ['First 1day free', 'Unlimited trips', 'Renewable monthly'];
      case 'annual':
        return ['First 2weeks free', 'Unlimited trips', 'Full theft insurance'];
      default:
        return [];
    }
  }
}