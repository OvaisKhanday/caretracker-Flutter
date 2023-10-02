import 'dart:convert';

import 'package:caretracker/widgets/dialog_widgets.dart';
import 'package:caretracker/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/variables.dart';
import '../models/student.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class ShowAllStudentsScreen extends StatefulWidget {
  const ShowAllStudentsScreen({super.key});

  @override
  State<ShowAllStudentsScreen> createState() => _ShowAllStudentsScreenState();
}

class _ShowAllStudentsScreenState extends State<ShowAllStudentsScreen> {
  final storage = const FlutterSecureStorage();
  List<Student> students = [];
  bool isLoaded = false;

  Future<http.Response> _receiveStudentList() async {
    final token = await storage.read(key: 'token') ?? '';
    var url = Uri.https(serverUrl, '/api/admin/student/getAllStudents');
    return http.get(
      url,
      headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'authorization': 'Bearer $token'},
    );
  }

  @override
  void initState() {
    isLoaded = false;

    _receiveStudentList().then((response) {
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (var st in body['students']) {
          Student student = Student.fromJson(st);
          students.add(student);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !isLoaded
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  titleTextWidget(title: 'All Students'),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).colorScheme.secondaryContainer,
                          ),
                          margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                                  minRadius: 30,
                                  child: const Icon(Icons.person_rounded, size: 36)),
                              const SizedBox(width: 12),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  titleTextWidget(title: students[index].name),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('class: ${students[index].class_}'),
                                      const SizedBox(width: 24),
                                      Text('roll no: ${students[index].rollNo}'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('gender: ${students[index].gender}'),
                                      const SizedBox(width: 12),
                                      Text('age: ${students[index].age}'),
                                      const SizedBox(width: 12),
                                      Text(students[index].busNo == -1
                                          ? 'not alloted'
                                          : students[index].busNo.toString()),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      })
                ],
              )));
  }
}
