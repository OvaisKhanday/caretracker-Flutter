import 'dart:convert';

import 'package:caretracker/widgets/button_widgets.dart';
import 'package:caretracker/widgets/dialog_widgets.dart';
import 'package:caretracker/widgets/text_fields_widgets.dart';
import 'package:caretracker/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/variables.dart';
import '../models/parent.dart';
import '../models/student.dart';
import 'login_screen.dart';

class AddNewStudentToExistingParentScreen extends StatefulWidget {
  const AddNewStudentToExistingParentScreen({super.key});

  @override
  State<AddNewStudentToExistingParentScreen> createState() => _AddNewStudentToExistingParentScreenState();
}

class _AddNewStudentToExistingParentScreenState extends State<AddNewStudentToExistingParentScreen> {
  final storage = const FlutterSecureStorage();
  final _searchFormKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();

  List<String> classes = [];
  List<String> studentGenders = [];
  List<String> buses = [];

  String? selectedSearchClass;
  String? selectedClass;
  String? selectedGender;
  String? selectedBus;
  bool parentFound = false;
  bool isLoaded = false;
  Parent? parent;

  final _searchRollNoController = TextEditingController();
  final _studentNameController = TextEditingController();
  final _studentRollNoController = TextEditingController();
  final _studentAgeController = TextEditingController();

  @override
  void initState() {
    isLoaded = false;
    parentFound = false;
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
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  titleTextWidget(title: 'enter existing parent’s child details'),
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
                                      var searchRollNoInteger = int.tryParse(_searchRollNoController.text);
                                      if (searchRollNoInteger == null) {
                                        showDialogWidget(context: context, success: false, message: 'invalid roll no');
                                        return;
                                      }
                                      setState(() {
                                        parentFound = false;
                                        _studentNameController.text = '';
                                        _studentAgeController.text = '';
                                        _studentRollNoController.text = '';
                                        selectedClass = null;
                                        selectedGender = null;
                                        selectedBus = null;
                                      });
                                      _getParentDetails(selectedSearchClass ?? '', searchRollNoInteger)
                                          .then((response) {
                                        final body = jsonDecode(response.body);
                                        if (response.statusCode == 200) {
                                          parent = Parent.fromJson(body['parent']);
                                          setState(() {
                                            parentFound = true;
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
                                          context: context,
                                          success: false,
                                          // todo: change message after debugging.
                                          message: onError.toString(),
                                        );
                                        return;
                                      });
                                      // setState(() {
                                      //   studentFound = true;
                                      // });
                                    }
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                  !parentFound
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Theme.of(context).colorScheme.secondaryContainer,
                                      ),
                                      child: Column(
                                        children: [
                                          // todo: parent details should be readonly.
                                          titleTextWidget(title: 'existing parent details'),
                                          const SizedBox(height: 12),
                                          titleTextWidget(title: parent!.name ?? ''),
                                          descriptionTextWidget(description: 'username: ${parent!.username ?? ''}'),
                                          descriptionTextWidget(description: 'residence: ${parent!.residence ?? ''}'),
                                          descriptionTextWidget(description: 'gender: ${parent!.gender ?? ''}'),
                                          phoneIconWithNumber(phone: parent!.phoneNo ?? ''),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                                      titleTextWidget(title: 'add new student'),
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
                                            child: rollNoTextFieldWidget(controller: _studentRollNoController),
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
                                              selectedItem: selectedGender,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedGender = value;
                                                });
                                              }),
                                          const SizedBox(width: 12),
                                          SizedBox(
                                              width: 100, child: ageTextFieldWidget(controller: _studentAgeController)),
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
                              // Flexible(child: Container()),
                              const SizedBox(height: 12),
                              nextAndSaveButtonWidget(
                                  context: context,
                                  buttonText: 'save',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (selectedClass == null) {
                                        showDialogWidget(context: context, success: false, message: 'enter class');
                                        return;
                                      }
                                      if (selectedGender == null) {
                                        showDialogWidget(context: context, success: false, message: 'enter gender');
                                        return;
                                      }
                                      if (selectedBus == null) {
                                        showDialogWidget(context: context, success: false, message: 'enter bus');
                                        return;
                                      }

                                      var rollNoInteger = int.tryParse(_studentRollNoController.text);
                                      var ageInteger = int.tryParse(_studentAgeController.text);
                                      var busNoInteger = int.tryParse(selectedBus ?? '');
                                      if (rollNoInteger == null || ageInteger == null || busNoInteger == null) {
                                        showDialogWidget(
                                            context: context,
                                            success: false,
                                            message: 'roll no, age, or bus-no not valid');
                                        return;
                                      }

                                      Student student = Student(
                                          name: _studentNameController.text,
                                          age: ageInteger,
                                          busNo: busNoInteger,
                                          class_: selectedClass ?? '',
                                          gender: selectedGender ?? '',
                                          rollNo: rollNoInteger);
                                      _postStudentDetailsToExistingParent(student).then((response) {
                                        final body = jsonDecode(response.body);
                                        if (response.statusCode == 200) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          showDialogWidget(context: context, success: true, message: 'student added');
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
              )));
  }

  Future<http.Response> _postStudentDetailsToExistingParent(student) async {
    final token = await storage.read(key: 'token');
    var url = Uri.https(serverUrl, '/api/admin/student/add/existing');

    return http.post(
      url,
      body: jsonEncode(<String, dynamic>{'parent_id': parent!.id, 'student': student.toJson()}),
      headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'authorization': 'Bearer $token'},
    );
  }

  Future<http.Response> _getParentDetails(String studentClass, int rollNo) async {
    final token = await storage.read(key: 'token');
    var url = Uri.https(serverUrl, '/api/admin/student/add/existing/search');
    return http.post(
      url,
      body: jsonEncode(<String, dynamic>{"class": studentClass, 'roll_no': rollNo}),
      headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'authorization': 'Bearer $token'},
    );
  }
}
