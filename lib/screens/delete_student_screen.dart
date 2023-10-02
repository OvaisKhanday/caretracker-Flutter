import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/variables.dart';
import '../models/student.dart';
import '../widgets/button_widgets.dart';
import '../widgets/dialog_widgets.dart';
import '../widgets/text_fields_widgets.dart';
import '../widgets/text_widgets.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class DeleteStudentScreen extends StatefulWidget {
  const DeleteStudentScreen({super.key});

  @override
  State<DeleteStudentScreen> createState() => _DeleteStudentScreenState();
}

class _DeleteStudentScreenState extends State<DeleteStudentScreen> {
  final storage = const FlutterSecureStorage();
  final _searchFormKey = GlobalKey<FormState>();

  List<String> classes = [];
  Student? student;

  String? selectedClass;
  final _rollNoController = TextEditingController();
  bool studentFound = false;
  bool isLoaded = false;

  @override
  void initState() {
    isLoaded = false;
    studentFound = false;
    _getClassGenderBusLists().then((response) {
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (var studentClass in body['classes']) {
          classes.add(studentClass.toString());
        }
        setState(() {
          isLoaded = true;
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
      showDialogWidget(context: context, success: false, message: 'something went wrong');
    });

    super.initState();
  }

  Future<http.Response> _getClassGenderBusLists() async {
    final token = await storage.read(key: 'token') ?? '';
    final url = Uri.https(serverUrl, '/api/admin/student/getClassGenderBuses');
    return http.get(
      url,
      headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'authorization': 'Bearer $token'},
    );
  }

  Future<http.Response> _searchStudentByClassAndRollNo(String class_, int rollNo) async {
    final token = await storage.read(key: 'token') ?? '';
    final url = Uri.https(serverUrl, '/api/admin/student/search');
    return http.post(url,
        headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'authorization': 'Bearer $token'},
        body: jsonEncode(<String, dynamic>{
          'class': class_,
          'roll_no': rollNo,
        }));
  }

  Future<http.Response> _deleteStudentById(String? id) async {
    final token = await storage.read(key: 'token') ?? '';
    final url = Uri.https(serverUrl, '/api/admin/student/delete');
    return http.post(url,
        headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'authorization': 'Bearer $token'},
        body: jsonEncode(<String, String>{'_id': id ?? ''}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoaded
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                titleTextWidget(title: 'search the student'),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Form(
                      key: _searchFormKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          dropdownButtonWidget(
                              context: context,
                              hint: 'class',
                              selectedItem: selectedClass,
                              items: classes,
                              onChanged: (value) {
                                setState(() {
                                  selectedClass = value;
                                });
                              }),
                          const SizedBox(width: 12),
                          Expanded(child: rollNoTextFieldWidget(controller: _rollNoController)),
                          const SizedBox(width: 12),
                          smallButtonWidget(
                              // search
                              context: context,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              iconColor: Theme.of(context).colorScheme.onPrimary,
                              icon: Icons.search_outlined,
                              onPressed: () {
                                if (_searchFormKey.currentState!.validate()) {
                                  if (selectedClass == null) {
                                    showDialogWidget(context: context, success: false, message: 'enter class');
                                  }
                                  //todo: update the UI as per the response from the server.
                                  else {
                                    setState(() {
                                      studentFound = false;
                                    });
                                    var rollNoInteger = int.tryParse(_rollNoController.text);
                                    if (rollNoInteger == null) {
                                      showDialogWidget(context: context, success: false, message: 'roll no is invalid');
                                      return;
                                    }
                                    _searchStudentByClassAndRollNo(selectedClass ?? '', rollNoInteger).then((response) {
                                      final body = jsonDecode(response.body);
                                      if (response.statusCode == 200) {
                                        student = Student.fromJson(body['student']);
                                        setState(() {
                                          studentFound = true;
                                        });
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
                                      showDialogWidget(
                                          context: context, success: false, message: 'something went wrong');
                                    });
                                  }
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                ),
                !studentFound
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.secondaryContainer,
                              ),
                              padding: const EdgeInsets.all(24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                                      minRadius: 50,
                                      child: const Icon(Icons.person_rounded, size: 36)),
                                  const SizedBox(width: 12),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      titleTextWidget(title: student!.name),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('class: ${student!.class_}'),
                                          const SizedBox(width: 24),
                                          Text('roll no: ${student!.rollNo}'),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('gender: ${student!.gender}'),
                                          const SizedBox(width: 24),
                                          Text('age: ${student!.age}'),
                                        ],
                                      ),
                                      Text('bus no: ${student!.busNo == -1 ? 'not alloted' : student!.busNo}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            nextAndSaveButtonWidget(
                                context: context,
                                buttonText: 'delete',
                                onPressed: () {
                                  _showDeletePrompt();
                                }),
                          ],
                        ),
                      ),
              ],
            ),
    );
  }

  _showDeletePrompt() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Remove this student from the institute.'),
              actions: [
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.error)),
                    onPressed: () {
                      String? studentId = student!.id;

                      _deleteStudentById(studentId).then((response) {
                        final body = jsonDecode(response.body);
                        if (response.statusCode == 200) {
                          // goto back screen and show +ve dialog
                          Navigator.pop(context);
                          Navigator.pop(context);
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
                    },
                    child: Text('remove', style: TextStyle(color: Theme.of(context).colorScheme.onError)))
              ],
            ));
  }
}
