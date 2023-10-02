import '../constants/variables.dart';

// login username validator
String? loginUsernameValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'field is required';
  } else if (!usernameRegExp.hasMatch(value)) {
    return 'invalid username';
  } else if (value.length < minUsernameLength) {
    return 'username must be at least $minUsernameLength characters long';
  }
  return null;
}

// register username validator
String? registerUsernameValidator(String? value) {
  String? usernameParameters = loginUsernameValidator(value);
  if (usernameParameters == null || usernameParameters.trim().isEmpty) {
    //todo: check in database
  }
  return usernameParameters;
}

// password validator
String? passwordValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'field is required';
  } else if (value.length < minPasswordLength) {
    return 'password must be at least $minPasswordLength characters long';
  }
  return null;
}

// name validator
String? nameValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'field is required';
  } else if (!nameRegExp.hasMatch(value)) {
    return 'invalid name';
  } else if (value.length < minNameLength || value.length > maxNameLength) {
    return 'name is not in 4 - 25 range';
  }
  return null;
}

// residence validator
String? residenceValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'field is required';
  } else if (!residenceRegExp.hasMatch(value)) {
    return 'invalid residence';
  } else if (value.length < minResidenceLength) {
    return 'residence at least 4 chars';
  } else if (value.length > maxResidenceLength) {
    return 'residence is more than 25 chars';
  }
  return null;
}

// phone no validator
String? phoneNoValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'field is required';
  } else if (!phoneNoRegExp.hasMatch(value)) {
    return 'invalid phone no';
  } else if (value.length != 10) {
    return 'phone should be 10 chars';
  }
  return null;
}

// age validator
String? ageValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'field is required';
  } else if (!ageRegExp.hasMatch(value)) {
    return 'invalid age';
  } else if (value.length >= 3) {
    return 'too old';
  }
  return null;
}

// roll no validator
String? rollNoValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'field is required';
  } else if (!rollNoRegExp.hasMatch(value)) {
    return 'invalid roll no';
  }
  return null;
}

// bus registration validator
String? busRegValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'field is required';
  } else if (!busRegistrationNoRegExp.hasMatch(value)) {
    return 'invalid reg no.';
  }
  return null;
}

String? busNoValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'field is required';
  } else if (!busNoRegExp.hasMatch(value)) {
    return 'invalid bus no';
  }
  return null;
}
