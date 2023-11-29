import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/button_widgets.dart';
import '../widgets/svg_widgets.dart';
import '../widgets/text_widgets.dart';

class ParentTrackingScreen extends StatefulWidget {
  const ParentTrackingScreen({super.key});

  @override
  State<ParentTrackingScreen> createState() => _ParentTrackingScreenState();
}

class Coordinates {
  double lat;
  double lon;
  Coordinates(this.lat, this.lon);
}

class _ParentTrackingScreenState extends State<ParentTrackingScreen> {
  final busSvgAssetName = 'assets/svgs/bus.svg';
  double lat = 33.0;
  double lon = 23.0;

  Stream<Coordinates> _changeCoordinates() async* {
    await Future.delayed(const Duration(seconds: 1));
    lat += Random().nextDouble();
    lon += Random().nextDouble();
    yield Coordinates(lat, lon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: busNoInTopNotch(busNo: '24'),
                        ),
                      ),
                      Expanded(child: svgHeadlineWidget(context: context, assetName: busSvgAssetName, height: 30)),
                      Expanded(flex: 2, child: Center(child: titleTextWidget(title: 'Student Name Here')))
                    ],
                  )),
              const SizedBox(height: 12),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 108, 223, 217),
                ),
                child: StreamBuilder<Coordinates>(
                    stream: _changeCoordinates(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active || snapshot.hasData) {
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('lat: ${snapshot.data!.lat}'),
                            Text('lon: ${snapshot.data!.lon}'),
                          ],
                        ));
                      } else {
                        return const CircularProgressIndicator.adaptive();
                      }
                    }),
              )),
              // const SizedBox(height: 12),
              stopTrackingButton(
                  context: context,
                  buttonText: 'stop',
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ));
  }
}
