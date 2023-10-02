import 'package:caretracker/screens/parent_main_screen.dart';
import 'package:caretracker/utilities/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/variables.dart';
import '../widgets/button_widgets.dart';
import '../widgets/dialog_widgets.dart';
import '../widgets/text_fields_widgets.dart';
import 'admin_screen.dart';
import '../widgets/login_widgets.dart';
import 'driver_main_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  bool _isPasswordObscured = true;
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // keyboard will not push the content up.
      body: Padding(
        padding: const EdgeInsets.all(allScreensPaddingAll),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Container()), // to keep the main content down
              appNameOnLoginScreenWidget,
              Expanded(child: Container()), // to keep the main content down

              // Form to enter username and password in.
              // validate the username and password and send it to the server for processing.
              Form(
                key: _loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    usernameTextFieldWidget(
                        controller: _usernameTextController,
                        labelText: 'username',
                        validator: (value) => loginUsernameValidator(value)),
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
                    loginRegisterButtonWidget(
                        context: context,
                        buttonText: 'login',
                        onPressed: () {
                          if (_loginFormKey.currentState!.validate()) {
                            // send request to the server and wait for response to come.
                            dynamic body;
                            try {
                              _sendUserData().then((response) {
                                body = jsonDecode(response.body);
                                final token = response.headers['token'];

                                // if user was found
                                if (response.statusCode == 200) {
                                  // save the token;
                                  storage.write(key: 'token', value: token);
                                  if (body['role'] == 'admin') {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AdminScreen(
                                                  institute: body['institute'],
                                                )),
                                        ModalRoute.withName('/'));
                                  } else if (body['role'] == 'parent') {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => const ParentMainScreen()));
                                  } else if (body['role'] == 'driver') {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => const DriverMainScreen()));
                                  } else {
                                    // show error dialog.
                                    throw Exception('no role found');
                                  }
                                } else {
                                  showDialogWidget(context: context, success: false, message: body['message']);
                                  // show error dialog
                                }
                              });
                            } catch (error) {
                              // show error dialog.
                              showDialogWidget(context: context, success: false, message: error.toString());
                            }
                          }
                        }),
                  ],
                ),
              ),
              Expanded(flex: 2, child: Container()), // to keep the main content down

              loginPageTagLineWidget,
            ],
          ),
        ),
      ),
    );
  }

  Future<http.Response> _sendUserData() {
    var url = Uri.https(serverUrl, '/api/login');
    return http.post(
      url,
      body: jsonEncode(
          <String, String>{"username": _usernameTextController.text, "password": _passwordTextController.text}),
      headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _usernameTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }
}
