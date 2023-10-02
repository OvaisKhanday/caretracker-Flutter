import 'package:flutter/material.dart';
import '../constants/variables.dart';

// app name on login screen widget
const Widget appNameOnLoginScreenWidget = Text(
  appName,
  style: TextStyle(
    fontSize: appNameOnLoginPageTextSize,
    // fontFamily: fontFamilyHeadline,
  ),
);

Widget appNameBigWidget({required BuildContext context, required Color color}) {
  return Text(appName,
      style: TextStyle(
        fontSize: appNameOnLoginPageTextSize,
        color: color,
      ));
}

// bottom tag line in login page
const Widget loginPageTagLineWidget = Text(
  loginScreenBottomTagLineText,
);
