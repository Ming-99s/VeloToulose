import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/features/payment/view/payment_method_screen.dart';
import 'package:velo_toulose/models/bike.dart';

class BikeTile extends StatelessWidget {
  const BikeTile({super.key, required this.bike, required this.stationName});

  final Bike bike;
  final String stationName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
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
                padding: EdgeInsets.all(10),
                width: 70,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColor.background,
              
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: const Color.fromARGB(255, 250, 208, 184),
                  ),
                ),
                child: Icon(Icons.pedal_bike, size: 30, color: AppColor.primary),
              ),
                        SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( '# ${bike.bikeId}',style: AppTextStyle.cardTitle,),
                  Text('#${bike.slotId!} • ${bike.type}',style: AppTextStyle.pricePeriod,),
                ],
              ),
            ],
          ),



          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColor.primary
            ),
            child: TextButton(onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PaymentMethodScreen(
                    stationName: stationName,
                    bikeType: bike.type,
                    bikeId: bike.bikeId,
                    slotLabel: bike.slotId ?? '-',
                  ),
                ),
              );
            }, child: Text('Select',style: AppTextStyle.buttonText,))),
        ],
      ),
    );
  }
}
