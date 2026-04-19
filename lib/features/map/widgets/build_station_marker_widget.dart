import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/models/station.dart';

class BuildStationMarkerWidget extends StatelessWidget {
  const BuildStationMarkerWidget({super.key, required this.station,required this.hasActiveRide});

  final Station station;
  final bool hasActiveRide;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(hasActiveRide ? Icons.dock : Icons.pedal_bike, color: Colors.white, size: 20),
          Text(
            hasActiveRide ?  station.emptyDock.toString() : station.availableBikes.toString() ,
            style: AppTextStyle.buttonText,
          ),
        ],
      ),
    );
  }
}
