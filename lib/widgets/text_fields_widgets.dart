import 'package:flutter/material.dart';

import '../constants/variables.dart';
import '../utilities/validators.dart';

// username field
Widget usernameTextFieldWidget({
  required TextEditingController? controller,
  required String labelText,
  required Function(String?) validator,
}) {
  return SizedBox(
    // to give width to the username field.
    width: loginInputFieldWidth,

    child: TextFormField(
      // USERNAME INPUT FIELD
      autocorrect: false,
      enableSuggestions: false,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding: const EdgeInsets.all(loginFieldsContentPaddingAll),
        border: const OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(loginInputBorderRadius))),
      ),
      validator: (value) => loginUsernameValidator(value),
    ),
  );
}

// password field
Widget passwordTextFieldWidget({
  required TextEditingController? controller,
  required bool isPasswordObscured,
  required String labelText,
  required VoidCallback toggleVisibility,
}) {
  return SizedBox(
    width: loginInputFieldWidth,
    child: TextFormField(
      autocorrect: false,
      enableSuggestions: false,
      controller: controller,
      obscureText: isPasswordObscured,
      validator: (value) => passwordValidator(value),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(loginFieldsContentPaddingAll),
        suffixIcon: InkWell(
          onTap: toggleVisibility,
          child: Icon(
            isPasswordObscured ? Icons.visibility : Icons.visibility_off,
          ),
        ),
        labelText: labelText,
        border: const OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(loginInputBorderRadius))),
      ),
    ),
  );
}

// confirm password field
Widget confirmPasswordTextFieldWidget({
  required TextEditingController? controller,
  required TextEditingController? parentController,
  required bool isPasswordObscured,
  required String labelText,
  required VoidCallback toggleVisibility,
}) {
  return SizedBox(
    width: loginInputFieldWidth,
    child: TextFormField(
      autocorrect: false,
      enableSuggestions: false,
      controller: controller,
      obscureText: isPasswordObscured,
      validator: (value) {
        String? validityParameter = passwordValidator(value);
        if (validityParameter == null) {
          // no problem in a simple password
          if (controller!.text != parentController!.text) {
            return 'password did not match';
          }
        }
        return validityParameter;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(loginFieldsContentPaddingAll),
        suffixIcon: InkWell(
          onTap: toggleVisibility,
          child: Icon(
            isPasswordObscured ? Icons.visibility : Icons.visibility_off,
          ),
        ),
        labelText: labelText,
        border: const OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(loginInputBorderRadius))),
      ),
    ),
  );
}

// InputDecoration loginPasswordInputDecoration(
//     {required bool isPasswordObscured,
//     required VoidCallback togglePasswordVisibility}) {
//   return InputDecoration(
//     contentPadding: const EdgeInsets.all(loginFieldsContentPaddingAll),
//     suffixIcon: InkWell(
//       onTap: togglePasswordVisibility,
//       child: Icon(
//         isPasswordObscured ? Icons.visibility : Icons.visibility_off,
//       ),
//     ),
//     labelText: loginFieldPasswordHintText,
//     border: const OutlineInputBorder(
//         borderRadius:
//             BorderRadius.all(Radius.circular(loginInputBorderRadius))),
//   );
// }

// typical text field decoration
InputDecoration typicalTextFieldInputDecoration({required String labelText}) {
  return InputDecoration(
    labelText: labelText,
    contentPadding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
    border: const OutlineInputBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(typicalTextFieldBorderRadius))),
  );
}

// typical name text field
Widget nameTextFieldWidget(
    {isReadonly = false, TextEditingController? controller}) {
  return TextFormField(
    controller: controller,
    readOnly: isReadonly,
    decoration: typicalTextFieldInputDecoration(labelText: 'name'),
    validator: (value) => nameValidator(value),
  );
}

// typical roll text field
Widget rollNoTextFieldWidget(
    {isReadonly = false, TextEditingController? controller}) {
  return TextFormField(
    controller: controller,
    readOnly: isReadonly,
    decoration: typicalTextFieldInputDecoration(labelText: 'roll no'),
    keyboardType: TextInputType.number,
    validator: (value) => rollNoValidator(value),
  );
}

// typical age text field
Widget ageTextFieldWidget(
    {isReadonly = false, TextEditingController? controller}) {
  return TextFormField(
    controller: controller,
    readOnly: isReadonly,
    decoration: typicalTextFieldInputDecoration(labelText: 'age'),
    keyboardType: TextInputType.number,
    validator: (value) => ageValidator(value),
  );
}

// typical phone no text field
Widget phoneNoTextFieldWidget(
    {isReadonly = false, TextEditingController? controller}) {
  return TextFormField(
    controller: controller,
    readOnly: isReadonly,
    decoration: typicalTextFieldInputDecoration(labelText: 'phone no'),
    keyboardType: TextInputType.phone,
    validator: (value) => phoneNoValidator(value),
  );
}

// typical residence text field
Widget residenceTextFieldWidget(
    {isReadonly = false, TextEditingController? controller}) {
  return TextFormField(
    controller: controller,
    readOnly: isReadonly,
    decoration: typicalTextFieldInputDecoration(labelText: 'residence'),
    validator: (value) => residenceValidator(value),
  );
}

// bus registration no
Widget busRegTextFieldWidget(
    {required TextEditingController controller,
    required Function(String) onChanged}) {
  return TextFormField(
    onChanged: (value) => onChanged(value),
    validator: (value) => busRegValidator(value),
    controller: controller,
    decoration: typicalTextFieldInputDecoration(labelText: 'registration'),
  );
}

// bus no
Widget busNoTextFieldWidget(
    {required TextEditingController controller,
    required Function(String) onChanged}) {
  return TextFormField(
    // bus no
    onChanged: (value) => onChanged(value),
    validator: (value) => busNoValidator(value),
    controller: controller,
    decoration: typicalTextFieldInputDecoration(labelText: 'bus no'),
  );
}
