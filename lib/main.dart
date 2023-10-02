import 'package:caretracker/screens/add_student_to_existing_parent_screen.dart';
import 'package:caretracker/screens/add_student_to_new_parent_screen.dart';
import 'package:caretracker/screens/admin_screen.dart';
import 'package:caretracker/screens/bus_management_screen.dart';
import 'package:caretracker/screens/delete_student_screen.dart';
import 'package:caretracker/screens/driver_bus_mapping_screen.dart';
import 'package:caretracker/screens/driver_driving_screen.dart';
import 'package:caretracker/screens/driver_main_screen.dart';
import 'package:caretracker/screens/driver_management_screen.dart';
import 'package:caretracker/screens/init_screen.dart';
import 'package:caretracker/screens/new_driver_screen.dart';
import 'package:caretracker/screens/parent_main_screen.dart';
import 'package:caretracker/screens/register_new_driver_screen.dart';
import 'package:caretracker/screens/register_new_parent_screen.dart';
import 'package:caretracker/screens/show_all_students.dart';
import 'package:caretracker/screens/student_section_screen.dart';
import 'package:caretracker/screens/update_student_screen.dart';
import 'package:caretracker/screens/user_forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/variables.dart';
import 'constants/color_schemes.g.dart';
import 'screens/login_screen.dart';

void main() {
  // We need to call it manually,
  // because we going to call setPreferredOrientations()
  // before the runApp() call
  WidgetsFlutterBinding.ensureInitialized();

  // Than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => runApp(const MyApp()));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    // Material app is the root
    // MaterialApp.router();
    return MaterialApp(
      debugShowCheckedModeBanner: false, // remove debug banner

      title: appName,

      // defining theme data for light
      theme: ThemeData(
        colorScheme: lightColorScheme, // using material theme builder from google
        useMaterial3: true,
        fontFamily: fontFamilyBody,
      ),

      // defining theme data for dark
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
        fontFamily: fontFamilyBody,
      ),

      themeMode: ThemeMode.system,

      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => const InitialScreen(),
        '/login': (context) => const LoginScreen(),
        // '/login': (context) => const LoginScreen(),
        '/admin': (context) => const AdminScreen(institute: null),
        '/admin/student': (context) => const StudentSectionScreen(),
        '/admin/student/showAll': (context) => const ShowAllStudentsScreen(),
        '/admin/student/addNewWithParent': (context) => const AddNewStudentToNewParentScreen(),
        '/admin/student/addNewWithParent/register': (context) => const RegisterNewParentScreen(),
        '/admin/student/addNewWithoutParent/': (context) => const AddNewStudentToExistingParentScreen(),
        '/admin/student/update': (context) => const StudentUpdateScreen(),
        '/admin/student/delete': (context) => const DeleteStudentScreen(),
        '/admin/bus': (context) => const BusManagementScreen(),
        '/admin/driver': (context) => const DriverManagementScreen(),
        '/admin/driver/new': (context) => const AddNewDriverScreen(),
        '/admin/driver/new/register': (context) => const RegisterNewDriverScreen(),
        '/admin/driverBusMapping': (context) => const DriverBusMappingScreen(),
        '/admin/forgotPassword': (context) => const UserForgotPasswordScreen(),
        '/parent': (context) => const ParentMainScreen(),
        '/parent/tracking': (context) => const ParentMainScreen(),
        '/driver': (context) => const DriverMainScreen(),
        '/driver/driving': (context) => const DrivingLocationScreen(),
      },
    );
  }
}
