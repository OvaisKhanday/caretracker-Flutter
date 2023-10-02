import 'dart:convert';

import 'package:caretracker/screens/register_new_parent_screen.dart';
import 'package:caretracker/widgets/dialog_widgets.dart';
import 'package:caretracker/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/variables.dart';
import '../models/parent.dart';
import '../models/student.dart';
import '../widgets/button_widgets.dart';
import '../widgets/text_fields_widgets.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class AddNewStudentToNewParentScreen extends StatefulWidget {
  const AddNewStudentToNewParentScreen({super.key});

  @override
  State<AddNewStudentToNewParentScreen> createState() => _AddNewStudentToNewParentScreenState();
}

class _AddNewStudentToNewParentScreenState extends State<AddNewStudentToNewParentScreen> {
  final _globalFormKey = GlobalKey<FormState>();

  bool isLoaded = false;
  List<String> classes = [];
  List<String> studentGenders = [];
  List<String> parentGenders = [];
  List<String> buses = [];
  String? selectedClass;
  String? selectedStudentGender;
  String? selectedParentGender;
  String? selectedBus;

  final _studentNameController = TextEditingController();
  final _studentRollNoController = TextEditingController();
  final _studentAgeController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentPhoneNoController = TextEditingController();
  final _parentResidenceController = TextEditingController();
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    isLoaded = false;
    // get the bus number list
    // get the gender list
    // get the class list

    _getClassGenderBusLists().then((response) {
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (var bus in body['buses']) {
          buses.add(bus['bus_no'].toString());
        }
        for (var gender in body['student_genders']) {
          studentGenders.add(gender.toString());
        }
        for (var gender in body['parent_genders']) {
          parentGenders.add(gender.toString());
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
      showDialogWidget(context: context, success: false, message: onError.toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _globalFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: titleTextWidget(title: 'add student and parent details'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.secondaryContainer,
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            titleTextWidget(title: 'student'),
                            const SizedBox(height: 12),
                            nameTextFieldWidget(controller: _studentNameController),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dropdownButtonWidget(
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
                                  child: rollNoTextFieldWidget(
                                    controller: _studentRollNoController,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dropdownButtonWidget(
                                    // Gender
                                    context: context,
                                    hint: 'gender',
                                    items: studentGenders,
                                    selectedItem: selectedStudentGender,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedStudentGender = value;
                                      });
                                    }),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width: 100,
                                  child: ageTextFieldWidget(controller: _studentAgeController),
                                ),
                                const SizedBox(width: 12),
                                dropdownButtonWidget(
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
                    // const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.secondaryContainer,
                        ),
                        child: Column(
                          children: [
                            titleTextWidget(title: 'parent'),
                            const SizedBox(height: 12),
                            nameTextFieldWidget(controller: _parentNameController),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dropdownButtonWidget(
                                    // Gender
                                    context: context,
                                    hint: 'gender',
                                    items: parentGenders,
                                    selectedItem: selectedParentGender,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedParentGender = value;
                                      });
                                    }),
                                const SizedBox(width: 12),
                                Expanded(child: phoneNoTextFieldWidget(controller: _parentPhoneNoController))
                              ],
                            ),
                            const SizedBox(height: 12),
                            residenceTextFieldWidget(controller: _parentResidenceController),
                          ],
                        ),
                      ),
                    ),
                    nextAndSaveButtonWidget(
                        context: context,
                        buttonText: 'next',
                        onPressed: () {
                          if (_globalFormKey.currentState!.validate()) {
                            if (_areDropdownValidated()) {
                              // generate the Student and Parent objects and pass them to next screen.
                              var studentRollNoInteger = int.tryParse(_studentRollNoController.text);
                              var studentAgeInteger = int.tryParse(_studentAgeController.text);
                              var studentBusNoInteger = int.tryParse(selectedBus ?? '');
                              print(_studentRollNoController.text);
                              print(_studentAgeController.text);
                              print(selectedBus);
                              if (studentRollNoInteger == null ||
                                  studentAgeInteger == null ||
                                  studentBusNoInteger == null) {
                                showDialogWidget(
                                    context: context, success: false, message: 'roll no, bus no, or age is invalid');
                                return;
                              }
                              Student student = Student(
                                name: _studentNameController.text,
                                class_: selectedClass ?? '',
                                rollNo: studentRollNoInteger,
                                age: studentAgeInteger,
                                gender: selectedStudentGender ?? '',
                                busNo: studentBusNoInteger,
                              );
                              Parent parent = Parent(
                                name: _parentNameController.text,
                                residence: _parentResidenceController.text,
                                gender: selectedParentGender ?? '',
                                phoneNo: _parentPhoneNoController.text,
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterNewParentScreen(student: student, parent: parent)));
                            }
                          }
                        })
                  ],
                ),
              ),
            ),
    );
  }

  bool _areDropdownValidated() {
    if (selectedClass == null) {
      showDialogWidget(context: context, success: false, message: 'add student class');
      return false;
    } else if (selectedStudentGender == null) {
      showDialogWidget(context: context, success: false, message: 'add student gender');
      return false;
    } else if (selectedBus == null) {
      showDialogWidget(context: context, success: false, message: 'add student bus no');
      return false;
    } else if (selectedParentGender == null) {
      showDialogWidget(context: context, success: false, message: 'add parent gender');
      return false;
    }
    return true;
  }
}
