import 'package:flutter/material.dart';
import '../constants/variables.dart';

// login register button
Widget loginRegisterButtonWidget({
  required BuildContext context,
  required String buttonText,
  required VoidCallback onPressed,
}) {
  return SizedBox(
      width: loginInputFieldWidth,
      child: ElevatedButton(
        style: loginRegisterButtonStyle(context),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: loginLogoutRegisterButtonTextSize,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ));
}

// login register button style
ButtonStyle loginRegisterButtonStyle(BuildContext context) {
  return ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(loginInputBorderRadius),
      ),
    ),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.all(buttonPaddingAll)),
    backgroundColor:
        MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
  );
}

// typical in-app button
Widget typicalInAppButtonWidget(
    {required BuildContext context,
    required String buttonText,
    required VoidCallback onPressed}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 9, 0, 9),
    child: SizedBox(
      width: loginInputFieldWidth,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(loginInputBorderRadius),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(buttonPaddingAll)),
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.primaryContainer),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          )),
    ),
  );
}

// typical in-app button with high importance eg. next, save...
Widget nextAndSaveButtonWidget(
    {required BuildContext context,
    required String buttonText,
    required VoidCallback onPressed}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 9, 0, 9),
    child: SizedBox(
      width: loginInputFieldWidth,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(loginInputBorderRadius),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(buttonPaddingAll)),
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.primary),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          )),
    ),
  );
}

// stop tracking
Widget stopTrackingButton(
    {required BuildContext context,
    required String buttonText,
    required VoidCallback onPressed}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 9, 0, 9),
    child: SizedBox(
      width: loginInputFieldWidth,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(loginInputBorderRadius),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(buttonPaddingAll)),
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.errorContainer),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          )),
    ),
  );
}

// logout button
Widget logoutButtonWidget(
    {required BuildContext context,
    required buttonText,
    required VoidCallback onPressed}) {
  return SizedBox(
    width: loginInputFieldWidth,
    child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(loginInputBorderRadius),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(buttonPaddingAll)),
          backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.error),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: loginLogoutRegisterButtonTextSize,
            color: Theme.of(context).colorScheme.onError,
          ),
        )),
  );
}

// dropdown button list creation
List<DropdownMenuItem<String>>? dropdownButtonList(
    {required BuildContext context, required List<String> list}) {
  return list.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        style:
            TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
    );
  }).toList();
}

// dropdown button
Widget dropdownButtonWidget(
    {required BuildContext context,
    required String hint,
    required String? selectedItem,
    required List<String> items,
    required Function(String?) onChanged}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(typicalTextFieldBorderRadius),
        border: Border.all(color: Theme.of(context).colorScheme.secondary)),
    child: DropdownButton(
      borderRadius: BorderRadius.circular(10),
      dropdownColor: Theme.of(context).colorScheme.primaryContainer,
      underline: Container(),
      hint: Text(hint),
      value: selectedItem,
      items: dropdownButtonList(context: context, list: items),
      onChanged: (value) => onChanged(value),
    ),
  );
}

Widget smallButtonWidget({
  required BuildContext context,
  required IconData icon,
  required Color backgroundColor,
  required Color iconColor,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(12)),
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
      ),
      child: Icon(
        icon,
        color: iconColor,
      ));
}

// // search button
// Widget searchButtonWidget(
//     {required BuildContext context, required VoidCallback onPressed}) {
//   return ElevatedButton(
//       onPressed: onPressed,
//       style: ButtonStyle(
//         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//           RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//             const EdgeInsets.all(12)),
//         backgroundColor: MaterialStateProperty.all<Color>(
//             Theme.of(context).colorScheme.primary),
//       ),
//       child: Icon(
//         Icons.search_outlined,
//         color: Theme.of(context).colorScheme.onPrimary,
//       ));
// }

// // delete button
// Widget deleteButtonWidget(
//     {required BuildContext context, required VoidCallback onPressed}) {
//   return ElevatedButton(
//       onPressed: onPressed,
//       style: ButtonStyle(
//         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//           RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//             const EdgeInsets.all(12)),
//         backgroundColor: MaterialStateProperty.all<Color>(
//             Theme.of(context).colorScheme.error),
//       ),
//       child: Icon(
//         Icons.delete_outlined,
//         color: Theme.of(context).colorScheme.onError,
//       ));
// }
