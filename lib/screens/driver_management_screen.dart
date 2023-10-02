import 'package:caretracker/screens/login_screen.dart';
import 'package:caretracker/widgets/button_widgets.dart';
import 'package:caretracker/widgets/text_fields_widgets.dart';
import '../constants/variables.dart';
import '../models/driver.dart';
import '../widgets/dialog_widgets.dart';
import '../widgets/svg_widgets.dart';
import '../widgets/text_widgets.dart';
import 'new_driver_screen.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class DriverManagementScreen extends StatefulWidget {
  const DriverManagementScreen({super.key});

  @override
  State<DriverManagementScreen> createState() => _DriverManagementScreenState();
}

class _DriverManagementScreenState extends State<DriverManagementScreen> {
  final steeringSvgAssetName = 'assets/svgs/steering.svg';
  final storage = const FlutterSecureStorage();
  List<Driver> drivers = [];
  bool isLoaded = false;

  @override
  void initState() {
    isLoaded = false;
    _loadDrivers().then((response) {
      final body = jsonDecode(response.body);
      final message = body['message'];
      if (response.statusCode == 200) {
        for (var driver in body['drivers']) {
          driver['bus_id'] = null;
          drivers.add(Driver.fromJson(driver));
        }
      } else if (body['is_token_valid'] == false) {
        while (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        Navigator.pushNamed(context, '/login');
        showDialogWidget(context: context, success: false, message: 'session expired');
      } else {
        showDialogWidget(context: context, success: false, message: message);
      }
      setState(() {
        isLoaded = true;
      });
    }).catchError((onError) {
      showDialogWidget(context: context, success: false, message: onError.toString());
    });
    super.initState();
  }

  Future<http.Response> _loadDrivers() async {
    String token = await storage.read(key: 'token') ?? '';
    var url = Uri.https(serverUrl, '/api/admin/driver/all');
    return http.get(
      url,
      headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'authorization': 'Bearer $token'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !isLoaded
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  svgHeadlineWidget(context: context, assetName: steeringSvgAssetName, height: 96),
                  titleTextWidget(title: 'driver management'),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: drivers.length,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          titleTextWidget(title: drivers[index].name ?? ''),
                                          Text('username: ${drivers[index].username}'),
                                          drivers[index].residence == ''
                                              ? const Text('')
                                              : Text('residence: ${drivers[index].residence}'),
                                          drivers[index].phoneNo == ''
                                              ? const Text('no phone number')
                                              : Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      flex: 2,
                                                      child: Wrap(
                                                          crossAxisAlignment: WrapCrossAlignment.center,
                                                          children: [
                                                            const Icon(Icons.phone_outlined),
                                                            descriptionTextWidget(
                                                                description: drivers[index].phoneNo ?? '')
                                                          ]),
                                                    ),
                                                    drivers[index].age == -1
                                                        ? const Text('')
                                                        : Flexible(
                                                            child: Text('age: ${drivers[index].age}'),
                                                          )
                                                  ],
                                                )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Flexible(
                                        child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // EDIT BUTTON
                                        smallButtonWidget(
                                            context: context,
                                            icon: Icons.edit_outlined,
                                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                            iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                                            onPressed: () {
                                              _showDialogForDriverUpdate(index);
                                            }),
                                        const SizedBox(height: 4),
                                        // DELETE BUTTON
                                        smallButtonWidget(
                                            context: context,
                                            icon: Icons.delete_outline,
                                            backgroundColor: Theme.of(context).colorScheme.error,
                                            iconColor: Theme.of(context).colorScheme.onError,
                                            onPressed: () {
                                              _showDeletePrompt(drivers[index].id);
                                            })
                                      ],
                                    )),
                                  ])),
                        );
                      }),
                  const SizedBox(height: 12),
                  smallButtonWidget(
                      //   ADD NEW DRIVER
                      context: context,
                      icon: Icons.add_outlined,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      iconColor: Theme.of(context).colorScheme.onSecondary,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewDriverScreen()));
                      }),
                  const SizedBox(height: 24),
                ],
              )));
  }

  _showDeletePrompt(String? driverId) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Remove this driver from the institute.'),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.error),
                  ),
                  onPressed: () {
                    // remove the driver with _id driverId from the database and refresh.
                    _removeDriverById(driverId).then((response) {
                      final body = jsonDecode(response.body);
                      String message = body['message'];
                      Navigator.pop(context);
                      if (response.statusCode == 200) {
                        showDialogWidget(context: context, success: true, message: message);
                        _refresh();
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
                  child: Text('remove', style: TextStyle(color: Theme.of(context).colorScheme.onError)),
                )
              ],
            ));
  }

  _removeDriverById(String? id) async {
    final token = await storage.read(key: 'token') ?? '';
    var url = Uri.https(serverUrl, '/api/admin/driver/delete');
    return http.post(url,
        headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'authorization': 'Bearer $token'},
        body: jsonEncode(<String, dynamic>{'_id': id}));
  }

  _showDialogForDriverUpdate(int index) {
    final updateFormKey = GlobalKey<FormState>();
    final updatedNameController = TextEditingController();
    final updatedResidenceController = TextEditingController();
    final updatedPhoneNoController = TextEditingController();
    final updatedAgeController = TextEditingController();

    String errorMessage = '';

    updatedNameController.text = drivers[index].name ?? '';
    updatedResidenceController.text = drivers[index].residence ?? '';
    updatedPhoneNoController.text = drivers[index].phoneNo ?? '';
    updatedAgeController.text = drivers[index].age.toString();

    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => SimpleDialog(
                  alignment: Alignment.center,
                  insetPadding: const EdgeInsets.all(12),
                  contentPadding: const EdgeInsets.all(24),
                  children: [
                    Form(
                        key: updateFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            titleTextWidget(title: 'edit driver details'),
                            const SizedBox(height: 12),
                            Text(
                              errorMessage,
                              style: TextStyle(color: Theme.of(context).colorScheme.error),
                            ),
                            nameTextFieldWidget(controller: updatedNameController),
                            const SizedBox(height: 12),
                            residenceTextFieldWidget(controller: updatedResidenceController),
                            const SizedBox(height: 12),
                            phoneNoTextFieldWidget(controller: updatedPhoneNoController),
                            const SizedBox(height: 12),
                            ageTextFieldWidget(controller: updatedAgeController),
                            const SizedBox(height: 24),
                            // todo: validate details and push them to server and respond according
                            smallButtonWidget(
                                context: context,
                                icon: Icons.done_outlined,
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                                // Validate the form
                                onPressed: () {
                                  if (updateFormKey.currentState!.validate()) {
                                    var ageInInteger = int.tryParse(updatedAgeController.text);
                                    if (ageInInteger == null) {
                                      showDialogWidget(context: context, success: false, message: 'age is invalid');
                                      return;
                                    }
                                    _updateDriverDetails(
                                            id: drivers[index].id ?? '',
                                            name: updatedNameController.text,
                                            residence: updatedResidenceController.text,
                                            phoneNo: updatedPhoneNoController.text,
                                            age: ageInInteger)
                                        .then((response) {
                                      final body = jsonDecode(response.body);
                                      if (response.statusCode == 200) {
                                        Navigator.pop(context);
                                        _refresh();
                                        showDialogWidget(context: context, success: true, message: body['message']);
                                      } else if (body['is_token_valid'] == false) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute<void>(
                                              builder: (BuildContext context) => const LoginScreen()),
                                          ModalRoute.withName('/'),
                                        );
                                        showDialogWidget(context: context, success: false, message: 'session expired');
                                      } else {
                                        showDialogWidget(context: context, success: false, message: body['message']);
                                      }
                                    }).catchError((onError) {
                                      showDialogWidget(context: context, success: false, message: onError.toString());
                                    });
                                  }
                                }),
                          ],
                        ))
                  ],
                ))));
  }

  _refresh() async {
    drivers.clear();
    setState(() {
      isLoaded = false;
    });
    _loadDrivers().then((response) {
      final body = jsonDecode(response.body);
      final message = body['message'];
      if (response.statusCode == 200) {
        for (var driver in body['drivers']) {
          drivers.add(Driver.fromJson(driver));
        }
      } else if (body['is_token_valid'] == false) {
        while (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        Navigator.pushNamed(context, '/login');
        showDialogWidget(context: context, success: false, message: 'session expired');
      } else {
        showDialogWidget(context: context, success: false, message: message);
      }
      setState(() {
        isLoaded = true;
      });
    });
  }

  Future<http.Response> _updateDriverDetails({
    required String id,
    required String name,
    String? residence,
    String? phoneNo,
    int? age,
  }) async {
    final token = await storage.read(key: 'token') ?? '';
    var url = Uri.https(serverUrl, '/api/admin/driver/update');
    return http.post(url,
        headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'authorization': 'Bearer $token'},
        body: jsonEncode(<String, dynamic>{
          '_id': id,
          'driver': {'name': name, 'residence': residence, 'phone_no': phoneNo, 'age': age}
        }));
  }
}
