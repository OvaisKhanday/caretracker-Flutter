import 'dart:async';

import 'package:caretracker/widgets/button_widgets.dart';
import 'package:caretracker/widgets/svg_widgets.dart';
import 'package:caretracker/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DrivingLocationScreen extends StatefulWidget {
  const DrivingLocationScreen({super.key});

  @override
  State<DrivingLocationScreen> createState() => _DrivingLocationScreenState();
}

class _DrivingLocationScreenState extends State<DrivingLocationScreen> {
  final busSvgAssetName = 'assets/svgs/bus.svg';
  late Position currentPosition;
  StreamController<Position> _locationController = StreamController<Position>();
  Stream<Position> get locationStream => _locationController.stream;

  Future<void> getContinuousLocation() async {
    if (true) {
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
        ),
      ).listen((Position position) {
        _locationController.add(position);
        print(position);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _determinePosition().then((value) => print(currentPosition));
    _getLocationUpdates();
    getContinuousLocation();
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
                      Expanded(
                          child: svgHeadlineWidget(
                              context: context,
                              assetName: busSvgAssetName,
                              height: 30)),
                      Expanded(
                          child: Center(
                              child: titleTextWidget(title: 'JK03H8484')))
                    ],
                  )),
              const SizedBox(height: 12),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(255, 108, 223, 217),
                ),
              )),
              // const SizedBox(height: 12),
              stopTrackingButton(
                  context: context,
                  buttonText: 'stop',
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              // Text(_locationController.onListen)
            ],
          ),
        ));
  }

  _getLocationUpdates() {
    print('im here');
    try {
      const LocationSettings locationSettings = LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
          timeLimit: Duration(minutes: 1));
    } catch (e) {
      // throws timeout exception
    }

    StreamSubscription<ServiceStatus> serviceStatusStream =
        Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      return print(status);
    });
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    print('im here above.1');

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    currentPosition = await Geolocator.getCurrentPosition();
    print('im here above.2');
    print(currentPosition);
    return currentPosition;
  }
}
