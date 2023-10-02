import 'dart:convert';

import 'package:caretracker/screens/student_section_screen.dart';
import 'package:caretracker/widgets/button_widgets.dart';
import 'package:caretracker/widgets/dialog_widgets.dart';
import 'package:caretracker/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/variables.dart';
import '../models/parent.dart';
import '../models/student.dart';
import '../utilities/validators.dart';
import '../widgets/text_fields_widgets.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class RegisterNewParentScreen extends StatefulWidget {
  const RegisterNewParentScreen({super.key, this.student, this.parent});
  final Student? student;
  final Parent? parent;

  @override
  State<RegisterNewParentScreen> createState() => _RegisterNewParentScreenState();
}

class _RegisterNewParentScreenState extends State<RegisterNewParentScreen> {
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
              titleTextWidget(title: 'set username and password for the parent'),
              const SizedBox(height: 24),
              descriptionTextWidget(
                  description:
                      'These credentials are sensitive as these are required to track a child. If disclosed with anyone, he can locate the child. Share the username and password with the respected parent so he/she can track the bus of his/her beloved child.'),
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
                      _sendStudentParentAndUserData().then((response) {
                        final body = jsonDecode(response.body);
                        if (response.statusCode == 200) {
                          // navigate to the student page and show success dialog
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => const StudentSectionScreen()));
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

  Future<http.Response> _sendStudentParentAndUserData() async {
    final token = await storage.read(key: 'token') ?? '';
    var url = Uri.https(serverUrl, '/api/admin/student/add/new');
    return http.post(url,
        headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'authorization': 'Bearer $token'},
        body: jsonEncode(<String, dynamic>{
          'student': widget.student!.toJson(),
          'parent': widget.parent!.toJson(),
          'username': _usernameTextController.text,
          'password': _passwordTextController.text,
        }));
  }
}
