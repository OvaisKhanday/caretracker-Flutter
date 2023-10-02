import 'dart:convert';

import 'package:caretracker/constants/variables.dart';
import 'package:caretracker/screens/driver_main_screen.dart';
import 'package:caretracker/screens/login_screen.dart';
import 'package:caretracker/screens/parent_main_screen.dart';
import 'package:caretracker/widgets/button_widgets.dart';
import 'package:caretracker/widgets/dialog_widgets.dart';
import 'package:caretracker/widgets/login_widgets.dart';
import '../utilities/check_internet.dart';
import 'admin_screen.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final storage = const FlutterSecureStorage();
  String version = '';
  String role = '';
  bool dataReceived = false;
  dynamic body;
  @override
  void initState() {
    dataReceived = false;
    isInternetAvailable().then((isAvailable) {
      if (!isAvailable) {
        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Internet connection not available'),
        ));
      } else {
        _sendTokenAndReceiveResponse().then((response) {
          body = jsonDecode(response.body);
          if (response.statusCode == 200) {
            if (body['app_details']['version'] != version) {
              // update is available
              return _showDialogForUpdating();
            }
          }
          setState(() {
            role = body['role'] ?? '';
            dataReceived = true;
          });
        }).catchError((error) {
          showDialogWidget(context: context, success: false, message: 'something went wrong');
        });
      }
    }).catchError((onError) {
      showDialogWidget(context: context, success: false, message: 'something went wrong');
    });

    super.initState();
  }

  Future<http.Response> _sendTokenAndReceiveResponse() async {
    version = await _getInstalledAppVersion();
    String token = await storage.read(key: 'token') ?? '';
    final url = Uri.https(serverUrl, '/api/init');

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
        resizeToAvoidBottomInset: false, // keyboard will not push the content up.
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              Center(
                child: appNameBigWidget(context: context, color: Theme.of(context).colorScheme.onPrimary),
              ),
              Expanded(child: Container()),
              dataReceived
                  ? smallButtonWidget(
                      context: context,
                      icon: Icons.arrow_forward_rounded,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                      onPressed: () {
                        if (role == 'admin') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminScreen(
                                        institute: body['institute'],
                                      )));
                        } else if (role == 'parent') {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ParentMainScreen()));
                        } else if (role == 'driver') {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverMainScreen()));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                        }
                      })
                  : const Text(''),
              const SizedBox(height: 12)
            ],
          ),
        ));
  }

  _getInstalledAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;

    return version;
  }

  _showDialogForUpdating() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: const Center(child: Text('Update availabe')),
              content: const Text(
                'a new update is available to the app. We are working hard for your privacy and delivering of quality services, consider updating the app.',
                textAlign: TextAlign.center,
              ),
              actions: [
                Center(
                    child:
                        //todo: on tap open the store link provided from the response .
                        ElevatedButton(
                            onPressed: () {
                              // todo: need package Id
                              // it needs to be implemented after we buy the package or domain, which is unique.
                            },
                            child: const Text('update coming soon')))
              ],
            ));
  }
}
