import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/variables.dart';
import '../utilities/validators.dart';
import '../widgets/button_widgets.dart';
import '../widgets/dialog_widgets.dart';
import '../widgets/text_fields_widgets.dart';
import '../widgets/text_widgets.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class UserForgotPasswordScreen extends StatefulWidget {
  const UserForgotPasswordScreen({super.key});

  @override
  State<UserForgotPasswordScreen> createState() => _UserForgotPasswordScreenState();
}

class _UserForgotPasswordScreenState extends State<UserForgotPasswordScreen> {
  final storage = const FlutterSecureStorage();
  final _globalFormKey = GlobalKey<FormState>();
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

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
              titleTextWidget(title: 'forgot password'),
              const SizedBox(height: 24),
              descriptionTextWidget(
                  description:
                      'If a driver or a parent has forgot the password, admin can reset their password. Enter the username and set the new password.'),
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
                        labelText: 'new password',
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
                        labelText: 'confirm new password',
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
                  buttonText: 'update',
                  onPressed: () {
                    //todo: validate the form
                    // username validator used above will check the database
                    // send the data to the server for storing
                    // read the response and show the success dialog to the user.

                    if (_globalFormKey.currentState!.validate()) {
                      _forgotPasswordRequestToServer().then((response) {
                        final body = jsonDecode(response.body);
                        if (response.statusCode == 200) {
                          Navigator.pop(context);
                          showDialogWidget(context: context, success: true, message: 'password changed');
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

  Future<http.Response> _forgotPasswordRequestToServer() async {
    final token = await storage.read(key: 'token') ?? '';
    final url = Uri.https(serverUrl, '/api/admin/forgotPassword');
    return http.post(url,
        headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'authorization': 'Bearer $token'},
        body: jsonEncode(<String, String>{
          'username': _usernameTextController.text,
          'new_password': _passwordTextController.text,
        }));
  }
}
