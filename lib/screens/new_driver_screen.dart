import 'package:caretracker/screens/register_new_driver_screen.dart';
import 'package:caretracker/widgets/button_widgets.dart';
import 'package:caretracker/widgets/dialog_widgets.dart';
import 'package:caretracker/widgets/text_fields_widgets.dart';
import 'package:caretracker/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

import '../models/driver.dart';

class AddNewDriverScreen extends StatefulWidget {
  const AddNewDriverScreen({super.key});

  @override
  State<AddNewDriverScreen> createState() => _AddNewDriverScreenState();
}

class _AddNewDriverScreenState extends State<AddNewDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _residenceController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset:
            false, // keyboard will not push the content up.

        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                titleTextWidget(title: 'add new driver'),
                const SizedBox(height: 12),
                nameTextFieldWidget(controller: _nameController),
                const SizedBox(height: 12),
                residenceTextFieldWidget(controller: _residenceController),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        flex: 3,
                        child: phoneNoTextFieldWidget(
                            controller: _phoneNoController)),
                    const SizedBox(width: 12),
                    Flexible(
                        child: ageTextFieldWidget(controller: _ageController)),
                  ],
                ),
                Flexible(child: Container()),
                nextAndSaveButtonWidget(
                    context: context,
                    buttonText: 'next',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // todo: move to register user interface.
                        var ageOfDriver = int.tryParse(_ageController.text);
                        if (ageOfDriver == null) {
                          showDialogWidget(
                              context: context,
                              success: false,
                              message: 'age is invalid');
                          return;
                        }
                        Driver driver = Driver(
                          name: _nameController.text,
                          residence: _residenceController.text,
                          phoneNo: _phoneNoController.text,
                          age: ageOfDriver,
                        );

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RegisterNewDriverScreen(driver: driver)));
                      }
                    })
              ],
            ),
          ),
        ));
  }
}
