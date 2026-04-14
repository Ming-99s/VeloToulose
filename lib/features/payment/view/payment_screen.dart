import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/widgets/botton.dart';
import 'package:velo_toulose/features/payment/widgets/pass_cart.dart';

class PassView extends StatefulWidget {
  const PassView({super.key});

  @override
  State<PassView> createState() => _PassViewState();
}

class _PassViewState extends State<PassView> {
  int _selectedIndex = 2; // default to Year Pass (index 2)

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
          'Subscription',
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
              const Text('Choose your plan', style: AppTextStyle.heading),
              const SizedBox(height: 8),
              const Text(
                'Select the best option for your commute in Toulouse.',
                style: AppTextStyle.subheading,
              ),
              const SizedBox(height: 24),

              // --- Pass cards ---
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PassCard(
                        title: 'Day Pass',
                        price: '€3',
                        period: '/24h',
                        features: [
                          'First 30m free',
                          'Unlimited trips',
                          'City-wide access',
                        ],
                        isSelected: _selectedIndex == 0,
                        onTap: () => setState(() => _selectedIndex = 0),
                      ),
                      const SizedBox(height: 16),
                      PassCard(
                        title: 'Monthly',
                        price: '€39',
                        period: '/mo',
                        features: [
                          'First 30m free',
                          'Electric priority',
                          'Renewable monthly',
                        ],
                        isSelected: _selectedIndex == 1,
                        onTap: () => setState(() => _selectedIndex = 1),
                      ),
                      const SizedBox(height: 16),
                      PassCard(
                        title: 'Year Pass',
                        price: '€299',
                        period: '/yr',
                        features: [
                          'First 60m free',
                          'Electric priority',
                          'Full theft insurance',
                        ],
                        isSelected: _selectedIndex == 2,
                        onTap: () => setState(() => _selectedIndex = 2),
                        badge: 'BEST VALUE',
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: AppButton(
                  label: 'Continue',
                  onPressed: () {
                    // TODO: navigate or call ViewModel later
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