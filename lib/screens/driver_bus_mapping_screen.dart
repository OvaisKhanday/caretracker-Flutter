import 'dart:convert';

import 'package:caretracker/widgets/button_widgets.dart';
import 'package:caretracker/widgets/dialog_widgets.dart';
import 'package:caretracker/widgets/svg_widgets.dart';
import 'package:caretracker/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/variables.dart';
import '../models/bus.dart';
import '../models/driver.dart';
import 'login_screen.dart';

class DriverBusMappingScreen extends StatefulWidget {
  const DriverBusMappingScreen({super.key});

  @override
  State<DriverBusMappingScreen> createState() => _DriverBusMappingScreenState();
}

class _DriverBusMappingScreenState extends State<DriverBusMappingScreen> {
  final busSvgAssetName = 'assets/svgs/bus.svg';
  final steeringSvgAssetName = 'assets/svgs/steering.svg';

  final storage = const FlutterSecureStorage();
// todo: if number of drivers is more than the actual buses available,
// todo: we should be able to handle that case also.

  List<Driver> drivers = [];
  List<String> selectedBuses = [];
  List<Bus> buses = [];
  List<String> busNoList = ['nil'];
  List<Map<String, String>> mappings = [];

  bool isReady = false;
  @override
  void initState() {
    isReady = false;

    _getDriverBusLists().then((response) {
      final body = jsonDecode(response.body);
      print(body);
      if (response.statusCode == 200) {
        print('1');
        for (var driver in body['drivers']) {
          Driver d = Driver.fromJson(driver);
          String bus = d.busNo == -1 ? 'nil' : d.busNo.toString();
          drivers.add(d);
          selectedBuses.add(bus);
          mappings.add({
            'driver_id': d.id ?? '',
          });
        }
        print(drivers);
        for (var bus in body['buses']) {
          buses.add(Bus.fromJson(bus));
          busNoList.add(bus['bus_no'].toString());
        }
        print(buses);
        print(busNoList);
        setState(() {
          isReady = true;
        });
      } else if (body['is_token_valid'] == false) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(builder: (BuildContext context) => const LoginScreen()),
          ModalRoute.withName('/'),
        );
        showDialogWidget(context: context, success: false, message: 'session expired');
      } else {
        showDialogWidget(context: context, success: false, message: body['message']);
      }
    }).catchError((onError) {
      showDialogWidget(context: context, success: false, message: onError.toString());
    });

    super.initState();
  }

  Future<http.Response> _getDriverBusLists() async {
    final token = await storage.read(key: 'token') ?? '';
    final url = Uri.https(serverUrl, '/api/admin/driverBusMapping/get');
    return http.get(url,
        headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'authorization': 'Bearer $token'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !isReady
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        svgHeadlineWidget(context: context, assetName: steeringSvgAssetName, height: 96),
                        const SizedBox(width: 12),
                        svgHeadlineWidget(context: context, assetName: busSvgAssetName, height: 96)
                      ],
                    ),
                    titleTextWidget(title: 'Driver Bus Mappings'),
                    const SizedBox(height: 12),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: drivers.length,
                        itemBuilder: (context, index) => Container(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Container(
                                        color: Theme.of(context).colorScheme.tertiaryContainer,
                                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                                        child: Text(
                                          drivers[index].name ?? '',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Theme.of(context).colorScheme.tertiaryContainer,
                                        ),
                                        child: dropdownButtonWidget(
                                            context: context,
                                            hint: 'buses',
                                            selectedItem: selectedBuses[index],
                                            items: busNoList,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedBuses[index] = value ?? 'nil';
                                                print(selectedBuses);
                                              });
                                            }),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                                const SizedBox(height: 6),
                              ],
                            ))),
                    nextAndSaveButtonWidget(
                        context: context,
                        buttonText: 'save',
                        onPressed: () {
                          String duplicateBus = _checkIfBusesAreNotDuplicate(selectedBuses);
                          if (duplicateBus != 'nil') {
                            showDialogWidget(
                                context: context,
                                success: false,
                                message: 'bus no: $duplicateBus can not have more than one driver');
                            return;
                          }
                          for (int i = 0; i < selectedBuses.length; i++) {
                            mappings[i]['bus_id'] = 'nil';
                            for (int j = 0; j < buses.length; j++) {
                              // busNoList is of length 1 more than buses, as of 'nil'.
                              if (selectedBuses[i] == buses[j].busNo.toString()) {
                                mappings[i]['bus_id'] = buses[j].id ?? '';
                              }
                            }
                          }

                          print(mappings);

                          _sendMappingToServer(mappings).then((response) {
                            final body = jsonDecode(response.body);
                            if (response.statusCode == 200) {
                              showDialogWidget(context: context, success: true, message: 'buses mapped');
                              // _reload();
                            } else if (body['is_token_valid'] == false) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute<void>(builder: (BuildContext context) => const LoginScreen()),
                                ModalRoute.withName('/'),
                              );
                              showDialogWidget(context: context, success: false, message: 'session expired');
                            } else {
                              showDialogWidget(context: context, success: false, message: body['message']);
                            }
                          }).catchError((onError) {
                            showDialogWidget(context: context, success: false, message: onError.toString());
                          });
                        })
                  ],
                ),
              ));
  }

  Future<http.Response> _sendMappingToServer(List<Map<String, String>> mapping) async {
    final token = await storage.read(key: 'token') ?? '';
    final url = Uri.https(serverUrl, '/api/admin/driverBusMapping/set');
    return http.post(url,
        headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'authorization': 'Bearer $token'},
        body: jsonEncode(<String, List<Map<String, String>>>{
          'mappings': mapping,
        }));
  }

  String _checkIfBusesAreNotDuplicate(List<String> buses) {
    for (int i = 0; i < buses.length; i++) {
      for (int j = i + 1; j < buses.length; j++) {
        if (buses[i] == buses[j] && buses[i] != 'nil') {
          return buses[i];
        }
      }
    }
    return 'nil';
  }
}
