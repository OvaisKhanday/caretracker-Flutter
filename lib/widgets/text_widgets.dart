import 'package:flutter/material.dart';

import '../constants/variables.dart';

// school name widget
Widget schoolNameWidget({required String schoolName}) {
  return Text(
    schoolName,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontFamily: fontFamilyHeadline,
      fontSize: schoolNameTextSize,
    ),
  );
}

// title eg ('bus management')
Widget titleTextWidget({required String title}) {
  return Text(title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: titleFontSize,
      ));
}

// description text widget
Widget descriptionTextWidget({required String description}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
    child: Text(
      description,
      textAlign: TextAlign.center,
    ),
  );
}

Widget phoneIconWithNumber({required String phone}) {
  return Wrap(
    direction: Axis.horizontal,
    children: [
      const Icon(Icons.phone_rounded),
      descriptionTextWidget(description: phone)
    ],
  );
}

// bus no in top banner
Widget busNoInTopNotch({required String busNo}) {
  return Text(busNo,
      style: const TextStyle(
        fontSize: 24,
      ));
}

// big bus no
Widget bigBusNoTextWidget({required String busNo}) {
  return Text(
    busNo,
    style: const TextStyle(fontSize: 36),
  );
}
