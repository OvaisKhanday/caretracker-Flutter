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

class StudentUpdateScreen extends StatefulWidget {
  const StudentUpdateScreen({super.key});

  @override
  State<StudentUpdateScreen> createState() => _StudentUpdateScreenState();
}

class _StudentUpdateScreenState extends State<StudentUpdateScreen> {
  final storage = const FlutterSecureStorage();
  final _searchFormKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();

  List<String> classes = [];
  List<String> genders = [];
  List<String> buses = [];

  String? selectedSearchClass;
  String? selectedClass;
  String? selectedGender;
  String? selectedBus;
  final _nameController = TextEditingController();
  final _searchRollNoController = TextEditingController();
  final _rollNoController = TextEditingController();
  final _ageController = TextEditingController();

  bool studentFound = false;
  bool isLoaded = false;
  Student? student;

  @override
  void initState() {
    studentFound = false;
    isLoaded = false;
    _getClassGenderBusLists().then((response) {
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (var bus in body['buses']) {
          buses.add(bus['bus_no'].toString());
        }
        for (var gender in body['student_genders']) {
          genders.add(gender.toString());
        }
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

  Future<http.Response> _sendUpdatedStudentInformation(
      {String? id, String? name, String? class_, int? rollNo, int? age, String? gender, int? busNo}) async {
    final token = await storage.read(key: 'token') ?? '';
    final url = Uri.https(serverUrl, '/api/admin/student/update');
    return http.post(url,
        headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'authorization': 'Bearer $token'},
        body: jsonEncode(<String, dynamic>{
          '_id': id,
          'student': {
            'name': name,
            'age': age,
            'class': class_,
            'roll_no': rollNo,
            'gender': gender,
            'bus_no': busNo,
          },
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                                selectedItem: selectedSearchClass,
                                items: classes,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSearchClass = value;
                                  });
                                }),
                            const SizedBox(width: 12),
                            Expanded(child: rollNoTextFieldWidget(controller: _searchRollNoController)),
                            const SizedBox(width: 12),
                            smallButtonWidget(
                                // search
                                context: context,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                iconColor: Theme.of(context).colorScheme.onPrimary,
                                icon: Icons.search_outlined,
                                onPressed: () {
                                  if (_searchFormKey.currentState!.validate()) {
                                    if (selectedSearchClass == null) {
                                      showDialogWidget(context: context, success: false, message: 'enter class');
                                    }
                                    //todo: update the UI as per the response from the server.
                                    else {
                                      var rollNoInteger = int.tryParse(_searchRollNoController.text);
                                      if (rollNoInteger == null) {
                                        showDialogWidget(
                                            context: context, success: false, message: 'roll no is invalid');
                                        return;
                                      }
                                      setState(() {
                                        studentFound = false;
                                      });
                                      _searchStudentByClassAndRollNo(selectedSearchClass ?? '', rollNoInteger)
                                          .then((response) {
                                        final body = jsonDecode(response.body);
                                        if (response.statusCode == 200) {
                                          student = Student.fromJson(body['student']);
                                          _nameController.text = student!.name;
                                          _rollNoController.text = student!.rollNo.toString();
                                          _ageController.text = student!.age.toString();
                                          selectedClass = student!.class_;
                                          selectedGender = student!.gender;
                                          selectedBus = student!.busNo == -1 ? null : student!.busNo.toString();
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
                                          showDialogWidget(
                                              context: context, success: false, message: 'session expired');
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
                            children: [
                              const SizedBox(height: 12),
                              Form(
                                key: _formKey,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Theme.of(context).colorScheme.secondaryContainer,
                                  ),
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    children: [
                                      titleTextWidget(title: 'update student'),
                                      const SizedBox(height: 12),
                                      nameTextFieldWidget(controller: _nameController), // name of the student
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          dropdownButtonWidget(
                                              // class
                                              context: context,
                                              hint: 'class',
                                              items: classes,
                                              selectedItem: selectedClass,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedClass = value;
                                                });
                                              }),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: rollNoTextFieldWidget(controller: _rollNoController), // roll no
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          dropdownButtonWidget(
                                              // gender
                                              // Gender
                                              context: context,
                                              hint: 'gender',
                                              items: genders,
                                              selectedItem: selectedGender,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedGender = value;
                                                });
                                              }),
                                          const SizedBox(width: 12),
                                          SizedBox(width: 100, child: ageTextFieldWidget(controller: _ageController)),
                                          const SizedBox(width: 12),
                                          dropdownButtonWidget(
                                              // bus no
                                              // bus
                                              context: context,
                                              hint: 'bus no',
                                              items: buses,
                                              selectedItem: selectedBus,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedBus = value;
                                                });
                                              }),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              nextAndSaveButtonWidget(
                                  context: context,
                                  buttonText: 'update',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (selectedBus == null || selectedClass == null || selectedGender == null) {
                                        showDialogWidget(
                                            context: context,
                                            success: false,
                                            message: 'bus, class or gender not selected');
                                        return;
                                      }
                                      var rollNoInteger = int.tryParse(_rollNoController.text);
                                      var busNoInteger = int.tryParse(selectedBus ?? '');
                                      var ageInteger = int.tryParse(_ageController.text);
                                      _sendUpdatedStudentInformation(
                                              id: student!.id,
                                              name: _nameController.text,
                                              class_: selectedClass,
                                              rollNo: rollNoInteger,
                                              gender: selectedGender,
                                              age: ageInteger,
                                              busNo: busNoInteger)
                                          .then((response) {
                                        final body = jsonDecode(response.body);
                                        if (response.statusCode == 200) {
                                          // goto
                                          Navigator.pop(context);
                                          showDialogWidget(context: context, success: true, message: 'student updated');
                                        } else if (body['is_token_valid'] == false) {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute<void>(
                                                builder: (BuildContext context) => const LoginScreen()),
                                            ModalRoute.withName('/'),
                                          );
                                          showDialogWidget(
                                              context: context, success: false, message: 'session expired');
                                        } else {
                                          showDialogWidget(context: context, success: false, message: body['message']);
                                        }
                                      }).catchError((onError) {
                                        showDialogWidget(
                                            context: context, success: false, message: 'something went wrong');
                                      });
                                    }
                                    //todo: validate class, gender, bus_no.
                                  })
                            ],
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
