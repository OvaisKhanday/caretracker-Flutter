import 'dart:convert';
import 'package:caretracker/widgets/button_widgets.dart';
import 'package:caretracker/widgets/dialog_widgets.dart';
import 'package:caretracker/widgets/text_widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/variables.dart';
import '../models/driver.dart';
import '../utilities/validators.dart';
import '../widgets/text_fields_widgets.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'driver_management_screen.dart';
import 'login_screen.dart';

class RegisterNewDriverScreen extends StatefulWidget {
  const RegisterNewDriverScreen({super.key, this.driver});
  final Driver? driver;

  @override
  State<RegisterNewDriverScreen> createState() => _RegisterNewDriverScreenState();
}

class _RegisterNewDriverScreenState extends State<RegisterNewDriverScreen> {
  final _globalFormKey = GlobalKey<FormState>();
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final storage = const FlutterSecureStorage();

  bool _isPasswordObscured = true;
  @override
  void initState() {
    super.initState();
    _isPasswordObscured = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, // keyboard will not push the content up.

        body: Padding(
          padding: const EdgeInsets.all(allScreensPaddingAll),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              titleTextWidget(title: 'set username and password for the driver'),
              const SizedBox(height: 24),
              descriptionTextWidget(
                  description:
                      'These credentials are sensitive as these are required to handle a potential bus. If disclosed with anyone, he can disguise as a driver and manipulate the location of a bus alloted to him by the administration.'),
              const SizedBox(height: 24),
              Form(
                key: _globalFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    usernameTextFieldWidget(
                        controller: _usernameTextController,
                        labelText: 'username',
                        validator: (value) => registerUsernameValidator(value)),
                    const SizedBox(height: distanceBetweenUsernamePasswordLoginButton),
                    passwordTextFieldWidget(
                        controller: _passwordTextController,
                        isPasswordObscured: _isPasswordObscured,
                        labelText: 'password',
                        toggleVisibility: () {
                          setState(() {
                            _isPasswordObscured = !_isPasswordObscured;
                          });
                        }),
                    const SizedBox(height: distanceBetweenUsernamePasswordLoginButton),
                    confirmPasswordTextFieldWidget(
                        controller: _confirmPasswordTextController,
                        parentController: _passwordTextController,
                        isPasswordObscured: _isPasswordObscured,
                        labelText: 'confirm password',
                        toggleVisibility: () {
                          setState(() {
                            _isPasswordObscured = !_isPasswordObscured;
                          });
                        }),
                  ],
                ),
              ),
              Expanded(child: Container()),
              loginRegisterButtonWidget(
                  context: context,
                  buttonText: 'register',
                  onPressed: () {
                    //todo: validate the form
                    // username validator used above will check the database
                    // send the data to the server for storing
                    // read the response and show the success dialog to the user.

                    if (_globalFormKey.currentState!.validate()) {
                      _sendDriverAndUserData().then((response) {
                        final body = jsonDecode(response.body);
                        if (response.statusCode == 200) {
                          // navigate to the driver page and show success dialog
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => const DriverManagementScreen()));
                          showDialogWidget(context: context, success: true, message: body['message']);
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
                        showDialogWidget(context: context, success: false, message: 'something went wrong');
                      });
                    }
                  })
            ],
          ),
        ));
  }

  Future<http.Response> _sendDriverAndUserData() async {
    final token = await storage.read(key: 'token') ?? '';
    var url = Uri.https(serverUrl, '/api/admin/driver/add');
    return http.post(url,
        headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'authorization': 'Bearer $token'},
        body: jsonEncode(<String, dynamic>{
          'driver': widget.driver!.toJson(),
          'username': _usernameTextController.text,
          'password': _passwordTextController.text,
        }));
  }
}
