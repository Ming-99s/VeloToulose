import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/widgets/confirm_dialog.dart';
import 'package:velo_toulose/features/auth/view/auth_screen.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/models/bike.dart';

class BikeTile extends StatelessWidget {
  const BikeTile({
    super.key,
    required this.bike,
    required this.stationName,
    required this.onTap,
  });

  final Bike bike;
  final String stationName;
  final Function() onTap;

  void _handleSelect(BuildContext context) {
    final isLoggedIn = context.read<AuthViewModel>().isLoggedIn;

    if (!isLoggedIn) {
      // show login prompt dialog
      showDialog(
        context: context,
        builder: (_) => ConfirmDialog(
          title: 'Login Required',
          message: 'You need to login first to book a bike',
          confirmLabel: 'Login',
          cancelLabel: 'Cancel',
          isDanger: false,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AuthScreen(mode: AuthMode.login),
              ),
            );
          },
        ),
      );
      return;
    }

    //if already login it continue
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 247, 243),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color.fromARGB(255, 255, 224, 210)),
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
                  color: AppColor.background,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: const Color.fromARGB(255, 250, 208, 184),
                  ),
                ),
                child: Icon(
                  Icons.pedal_bike,
                  size: 30,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('# ${bike.bikeId}', style: AppTextStyle.cardTitle),
                  Text(
                    '#${bike.slotId!}',
                    style: AppTextStyle.pricePeriod,
                  ),
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
              onPressed: () => _handleSelect(context), 
              child: Text('Select', style: AppTextStyle.buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
