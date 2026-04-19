import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/features/booking/view/pass_selection_screen.dart';

class PayAsYouGoCard extends StatelessWidget {
  const PayAsYouGoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.background,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(29, 107, 114, 128),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromARGB(37, 107, 114, 128),
            ),
            child: Text(
              'Current Status'.toUpperCase(),
              style: TextStyle(
                color: AppColor.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pay-as-you-go',
                style: TextStyle(
                  color: AppColor.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'You are using pay per ride.',
                style: TextStyle(
                  color: AppColor.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),

            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.primary,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(58, 255, 94, 0),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                  spreadRadius: 2,
                )
              ]
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PassView()),
                );
              },
              child: Text('Get a Pass', style: AppTextStyle.buttonText),
            ),
          )

        ],
      ),
    );
  }
}