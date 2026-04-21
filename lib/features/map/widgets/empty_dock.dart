import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/models/slot.dart';

class EmptyDockTile extends StatelessWidget {
  final Slot slot;
  final VoidCallback onReturn;

  const EmptyDockTile({super.key,required this.slot, required this.onReturn});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      decoration: BoxDecoration(
        color: AppColor.primaryLight,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color.fromARGB(255, 250, 141, 78)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: 70,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: const Color.fromARGB(255, 250, 141, 78),
                  ),
                ),
                child: Icon(Icons.dock, size: 25, color: AppColor.primary),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dock #${slot.slotId}',
                    style: AppTextStyle.cardTitle,
                  ),
                  Text('available to return', style: AppTextStyle.pricePeriod),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColor.primary,
            ),
            child: TextButton(
              onPressed: onReturn,
              child: const Text(
                'Return',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
