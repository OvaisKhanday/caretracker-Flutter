import 'package:caretracker/widgets/button_widgets.dart';
import 'package:caretracker/widgets/svg_widgets.dart';
import 'package:caretracker/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

import 'driver_driving_screen.dart';

class DriverMainScreen extends StatelessWidget {
  final busSvgAssetName = 'assets/svgs/bus.svg';
  const DriverMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            schoolNameWidget(schoolName: 'Apple Bird School'),
            Expanded(child: Container()),
            svgHeadlineWidget(
                context: context, assetName: busSvgAssetName, height: 96),
            bigBusNoTextWidget(busNo: '24'),
            titleTextWidget(title: 'JK04H5569'),
            Expanded(child: Container()),
            titleTextWidget(title: 'Danish Ahmad Khanday'),
            phoneIconWithNumber(phone: '4545454545'),
            Expanded(child: Container()),
            descriptionTextWidget(
                description:
                    'Start a session of loading or unloading of students in the bus. Remember to drive safely. Someone is waiting for you and the children in the bus.'),
            const SizedBox(height: 12),
            nextAndSaveButtonWidget(
                context: context,
                buttonText: 'start',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DrivingLocationScreen()));
                }),
            logoutButtonWidget(
                context: context,
                buttonText: 'logout',
                onPressed: () {
                  Navigator.pop(context);
                }),
            const SizedBox(height: 12)
          ],
        ));
  }
}
