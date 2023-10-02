import 'package:caretracker/constants/variables.dart';
import 'package:caretracker/screens/show_all_students.dart';
import 'package:caretracker/screens/update_student_screen.dart';
import 'package:caretracker/widgets/button_widgets.dart';
import 'package:flutter/material.dart';

import '../widgets/svg_widgets.dart';
import '../widgets/text_widgets.dart';
import 'add_student_to_existing_parent_screen.dart';
import 'add_student_to_new_parent_screen.dart';
import 'delete_student_screen.dart';

class StudentSectionScreen extends StatelessWidget {
  const StudentSectionScreen({super.key});
  final studentSvgAssetName = 'assets/svgs/student.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset:
            false, // keyboard will not push the content up.

        body: Padding(
          padding: const EdgeInsets.all(allScreensPaddingAll),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 100),
              Expanded(child: Container()),
              svgHeadlineWidget(
                  context: context, assetName: studentSvgAssetName, height: 96),
              titleTextWidget(title: 'Student Management'),
              const SizedBox(height: 24),
              descriptionTextWidget(
                  description:
                      'Register a new student, update the existing student’s details, or remove a student.'),
              Expanded(child: Container()),
              typicalInAppButtonWidget(
                  context: context,
                  buttonText: 'add student',
                  onPressed: () {
                    _showAlertDialogOfStudentRegistration(context: context);
                  }),
              typicalInAppButtonWidget(
                  context: context,
                  buttonText: 'show all students',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ShowAllStudentsScreen()));
                  }),
              typicalInAppButtonWidget(
                  context: context,
                  buttonText: 'update student',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                const StudentUpdateScreen())));
                  }),
              typicalInAppButtonWidget(
                  context: context,
                  buttonText: 'delete student',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                const DeleteStudentScreen())));
                  }),
              Expanded(child: Container()),
            ],
          ),
        ));
  }

  _showAlertDialogOfStudentRegistration({required BuildContext context}) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              alignment: Alignment.center,
              contentPadding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
              children: [
                typicalInAppButtonWidget(
                    context: context,
                    buttonText: 'add to existing parent',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AddNewStudentToExistingParentScreen()),
                      );
                    }),
                typicalInAppButtonWidget(
                    context: context,
                    buttonText: 'add to new parent',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AddNewStudentToNewParentScreen()),
                      );
                    })
              ],
            ));
  }
}
