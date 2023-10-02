import 'dart:convert';

import 'package:caretracker/widgets/dialog_widgets.dart';
import 'package:caretracker/widgets/text_widgets.dart';
import '../constants/variables.dart';
import '../widgets/button_widgets.dart';
import '../widgets/svg_widgets.dart';
import '../widgets/text_fields_widgets.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BusManagementScreen extends StatefulWidget {
  const BusManagementScreen({super.key});

  @override
  State<BusManagementScreen> createState() => _BusManagementScreenState();
}

class _BusManagementScreenState extends State<BusManagementScreen> {
  final storage = const FlutterSecureStorage();
  final busSvgAssetName = 'assets/svgs/bus.svg';
  final _formKey = GlobalKey<FormState>();
  List buses = [];

  bool isLoaded = false;

  @override
  void initState() {
    // send request to the server and receive the list of buses.
    // in the request we would pass authentication: Bearer $token in the header.
    // we'll receive a list of buses.
    isLoaded = false;
    _receiveBusListResponse().then((response) {
      buses = jsonDecode(response.body)['buses'];
      setState(() {
        isLoaded = true;
      });
    });
    super.initState();
  }

  Future<http.Response> _receiveBusListResponse() async {
    String token = await storage.read(key: 'token') ?? '';
    var url = Uri.https(serverUrl, '/api/admin/bus/all');
    return http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Bearer $token',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !isLoaded
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    svgHeadlineWidget(context: context, assetName: busSvgAssetName, height: 96),
                    titleTextWidget(title: 'bus management'),
                    Form(
                      key: _formKey,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: buses.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).colorScheme.secondaryContainer,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  descriptionTextWidget(description: buses[index]['bus_registration']),
                                  descriptionTextWidget(description: buses[index]['bus_no'].toString()),
                                  smallButtonWidget(
                                      context: context,
                                      icon: Icons.edit_rounded,
                                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                      iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                                      onPressed: () {
                                        //edit;
                                        _showEditBusDialog(index: index);
                                      }),
                                  smallButtonWidget(
                                      context: context,
                                      icon: Icons.delete_rounded,
                                      backgroundColor: Theme.of(context).colorScheme.error,
                                      iconColor: Theme.of(context).colorScheme.onError,
                                      onPressed: () {
                                        // delete particular bus from the database.
                                        // ask for prompt.
                                        _showDeletePrompt(buses[index]['_id']);
                                      })
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    smallButtonWidget(
                      // add new
                      context: context,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      iconColor: Theme.of(context).colorScheme.onSecondary,
                      icon: Icons.add_outlined,
                      onPressed: () {
                        // add new bus with bus_no and bus_registration;
                        _addNewBusDialog(context);
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ));
  }

  _showEditBusDialog({required int index}) {
    final busRegistrationController = TextEditingController();
    final busNoController = TextEditingController();

    final updateBusFormKey = GlobalKey<FormState>();
    Color? messageColor = Theme.of(context).colorScheme.onSurface;
    String message = "";
    bool busNoExist = false;
    bool busRegExist = false;

    busRegistrationController.text = buses[index]['bus_registration'];
    busNoController.text = buses[index]['bus_no'].toString();

    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => SimpleDialog(
                  contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                  children: [
                    titleTextWidget(title: 'update the bus'),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: messageColor),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: updateBusFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          busRegTextFieldWidget(controller: busRegistrationController, onChanged: (value) {}),
                          busRegExist
                              ? Text(
                                  'bus with same registration exists',
                                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                                )
                              : const Text(''),
                          const SizedBox(height: 12),
                          busNoTextFieldWidget(controller: busNoController, onChanged: (value) {}),
                          busNoExist
                              ? Text(
                                  'bus with same number exists',
                                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                                )
                              : const Text(''),
                          const SizedBox(height: 12),
                          smallButtonWidget(
                              context: context,
                              icon: Icons.done_rounded,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              iconColor: Theme.of(context).colorScheme.onPrimary,
                              onPressed: () {
                                setState(() {
                                  busRegExist = false;
                                  busNoExist = false;
                                });
                                if (updateBusFormKey.currentState!.validate()) {
                                  List busesWithOutThis = [...buses];
                                  busesWithOutThis.removeAt(index);

                                  for (var bus in busesWithOutThis) {
                                    if (bus['bus_registration'] == busRegistrationController.text.toUpperCase()) {
                                      setState(() {
                                        busRegExist = true;
                                      });
                                    }
                                    if (bus['bus_no'].toString() == busNoController.text) {
                                      setState(() {
                                        busNoExist = true;
                                      });
                                    }
                                  }
                                  if (busRegExist == false && busNoExist == false) {
                                    //todo: implement

                                    buses[index]['bus_registration'] = busRegistrationController.text;
                                    buses[index]['bus_no'] = busNoController.text;
                                    // updated the buses array now send the array to server.
                                    // and wait for the response.
                                    _updateBusesToDatabase(buses).then((response) {
                                      final body = jsonDecode(response.body);
                                      Navigator.pop(context);
                                      final message = body['message'];
                                      if (response.statusCode == 200) {
                                        showDialogWidget(context: context, success: true, message: message);
                                        _refreshBuses();
                                      } else if (body['type'] == 'invalid data') {
                                        showDialogWidget(
                                            context: context,
                                            success: false,
                                            message: body['message']['bus_no']
                                                ? body['message']['bus_no']
                                                : body['message']['bus_registration']);
                                      } else if (body['is_token_valid'] == false) {
                                        while (Navigator.canPop(context)) {
                                          Navigator.pop(context);
                                        }
                                        Navigator.pushNamed(context, '/login');
                                        showDialogWidget(context: context, success: false, message: 'session expired');
                                      } else {
                                        showDialogWidget(context: context, success: false, message: message);
                                      }
                                    });
                                    // print(buses);
                                  }
                                }
                              })
                        ],
                      ),
                    ),
                  ],
                ))));
  }

  Future<http.Response> _deleteBusById(String busId) async {
    String token = await storage.read(key: 'token') ?? '';
    var url = Uri.https(serverUrl, '/api/admin/bus/remove');
    return http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{'bus_id': busId}));
  }

  Future<http.Response> _updateBusesToDatabase(List buses) async {
    String token = await storage.read(key: 'token') ?? '';
    var url = Uri.https(serverUrl, '/api/admin/bus/update');
    return http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'buses': buses,
      }),
    );
  }

  _showDeletePrompt(String busId) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Remove this bus from the institute.'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      // remove the bus with _id busId from the database and refresh.
                      _deleteBusById(busId).then((response) {
                        final body = jsonDecode(response.body);
                        String message = body['message'];
                        Navigator.pop(context);
                        if (response.statusCode == 200) {
                          showDialogWidget(context: context, success: true, message: message);
                          _refreshBuses();
                        } else if (body['is_token_valid'] == false) {
                          while (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                          Navigator.pushNamed(context, '/login');
                          showDialogWidget(context: context, success: false, message: 'session expired');
                        } else {
                          showDialogWidget(context: context, success: false, message: message);
                        }
                      });
                    },
                    child: Text('remove'))
              ],
            ));
  }

  _addNewBusDialog(BuildContext context) {
    final newBusFormKey = GlobalKey<FormState>();
    final busRegistrationController = TextEditingController();
    final busNoController = TextEditingController();
    Color? messageColor = Theme.of(context).colorScheme.onSurface;
    String message = "";
    bool busNoExist = false;
    bool busRegExist = false;

    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => SimpleDialog(
                  contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                  children: [
                    titleTextWidget(title: 'add new bus'),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: messageColor),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: newBusFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          busRegTextFieldWidget(controller: busRegistrationController, onChanged: (value) {}),
                          busRegExist
                              ? Text(
                                  'bus with same registration exists',
                                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                                )
                              : const Text(''),
                          const SizedBox(height: 12),
                          busNoTextFieldWidget(controller: busNoController, onChanged: (value) {}),
                          busNoExist
                              ? Text(
                                  'bus with same number exists',
                                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                                )
                              : const Text(''),
                          const SizedBox(height: 12),
                          smallButtonWidget(
                              context: context,
                              icon: Icons.add_rounded,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              iconColor: Theme.of(context).colorScheme.onPrimary,
                              onPressed: () {
                                setState(() {
                                  busRegExist = false;
                                  busNoExist = false;
                                });
                                if (newBusFormKey.currentState!.validate()) {
                                  for (var bus in buses) {
                                    if (bus['bus_registration'] == busRegistrationController.text.toUpperCase()) {
                                      setState(() {
                                        busRegExist = true;
                                      });
                                    }
                                    if (bus['bus_no'].toString() == busNoController.text) {
                                      setState(() {
                                        busNoExist = true;
                                      });
                                    }
                                  }
                                  if (busRegExist == false && busNoExist == false) {
                                    // Navigator.pop(context);
                                    // if no duplicate are found then save the bus in the database;
                                    _saveBusToDatabase(busRegistrationController.text, busNoController.text)
                                        .then((response) {
                                      final body = jsonDecode(response.body);
                                      if (response.statusCode == 200) {
                                        Navigator.pop(context);
                                        _refreshBuses();
                                      } else if (response.statusCode == 400) {
                                        setState(() {
                                          messageColor = Theme.of(context).colorScheme.error;
                                          message = body['error']['bus_no']
                                              ? body['error']['bus_no']
                                              : body['error']['bus_registration'];
                                        });
                                      } else if (body['is_token_valid'] == false) {
                                        while (Navigator.canPop(context)) {
                                          Navigator.pop(context);
                                        }
                                        Navigator.pushNamed(context, '/login');
                                        showDialogWidget(context: context, success: false, message: 'session expired');
                                      } else {
                                        setState(() {
                                          messageColor = Theme.of(context).colorScheme.error;
                                          message = body['message'];
                                        });
                                      }
                                    });
                                  }
                                }
                              })
                        ],
                      ),
                    ),
                  ],
                ))));
  }

  Future<http.Response> _saveBusToDatabase(String busRegistration, String busNo) async {
    String token = await storage.read(key: 'token') ?? '';
    var url = Uri.https(serverUrl, '/api/admin/bus/add');
    return http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'bus': {'bus_registration': busRegistration, 'bus_no': busNo}
      }),
    );
  }

  _refreshBuses() {
    setState(() {
      isLoaded = false;
      buses.clear();

      _receiveBusListResponse().then((response) {
        final body = jsonDecode(response.body);
        buses = body['buses'];
        if (response.statusCode == 200) {
          setState(() {
            isLoaded = true;
          });
        } else if (body['is_token_valid'] == false) {
          while (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          Navigator.pushNamed(context, '/login');
          showDialogWidget(context: context, success: false, message: 'session expired');
        } else {
          showDialogWidget(context: context, success: false, message: body['message']);
        }
      });
    });
  }
}
