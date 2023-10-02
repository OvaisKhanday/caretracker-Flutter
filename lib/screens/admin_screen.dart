import 'package:caretracker/screens/student_section_screen.dart';
import 'package:caretracker/screens/user_forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/variables.dart';
import '../widgets/button_widgets.dart';
import '../widgets/text_widgets.dart';
import 'bus_management_screen.dart';
import 'driver_bus_mapping_screen.dart';
import 'driver_management_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key, @required this.institute});
  final dynamic institute;
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset:
            false, // keyboard will not push the content up.

        body: Padding(
          padding: const EdgeInsets.all(allScreensPaddingAll),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 100),
              Expanded(child: Container()),
              schoolNameWidget(schoolName: institute['name']),
              const SizedBox(height: 12),
              titleTextWidget(title: 'welcome'),
              titleTextWidget(title: institute['admin']['name']),
              const SizedBox(height: 12),
              descriptionTextWidget(
                  description:
                      'As an admin, you are eligible to manipulate the data of the institution.'),
              Expanded(child: Container()),
              typicalInAppButtonWidget(
                  context: context,
                  buttonText: 'Buses Section',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BusManagementScreen()));
                  }),
              typicalInAppButtonWidget(
                  context: context,
                  buttonText: 'Drivers Section',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const DriverManagementScreen()));
                  }),
              typicalInAppButtonWidget(
                  context: context,
                  buttonText: 'Student Section',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StudentSectionScreen()),
                    );
                  }),
              typicalInAppButtonWidget(
                  context: context,
                  buttonText: 'Driver Bus Mapping',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DriverBusMappingScreen()),
                    );
                  }),
              typicalInAppButtonWidget(
                  context: context,
                  buttonText: 'User Forgot Password',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const UserForgotPasswordScreen()));
                  }),
              Expanded(child: Container()),
              logoutButtonWidget(
                  context: context,
                  buttonText: 'logout',
                  onPressed: () async {
                    await storage.delete(key: 'token');
                    while (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    Navigator.pushNamed(context, '/login');
                  }),
            ],
          ),
        ));
  }
}
