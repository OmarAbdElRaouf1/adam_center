class Validators {
  static String? firstNameValidator(String? firstName) {
    if (firstName == null || firstName.isEmpty) {
      return "Name must not be empty";
    }
    if (firstName.length < 2 || firstName.length > 30) {
      return "Invalid name";
    }
    return null;
  }

  static String? lastNameValidator(String? lastName) {
    if (lastName == null || lastName.isEmpty) {
      return "Last name must not be empty";
    }
    if (lastName.length < 2 || lastName.length > 30) {
      return "Invalid last name";
    }
    return null;
  }

  static String? notesOnAddress(String? notesOnAddress) {
    if (notesOnAddress == null || notesOnAddress.isEmpty) {
      return "Notes on address must not be empty";
    }
    if (notesOnAddress.length < 3 || notesOnAddress.length > 30) {
      return "Invalid notes on address";
    }
    return null;
  }

  static String? usernameValidator(String? username) {
    if (username == null || username.isEmpty) {
      return null; // يسمح بأن يكون فارغًا
    }
    if (username.trim().isEmpty) {
      return "Username cannot be only spaces";
    }
    if (username.startsWith(' ')) {
      return "Username cannot Start With Space";
    }
    return null;
  }

  static String? editProfileNameValidator(String? displayName) {
    if (displayName!.length < 3 || displayName.length > 20) {
      return "Invalid Name";
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Email must not be empty";
    }
    if (!RegExp(
      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
    ).hasMatch(value)) {
      return "Enter Valid Email";
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a password";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }

  // ignore: non_constant_identifier_names
  static String? repeatPasswordValidator({String? value, String? Password}) {
    if (value != Password) {
      return "Passwords Do Not Match";
    }
    return null;
  }

  static String? phoneNumberValidator(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return "Phone number must not be empty";
    }
    if (phoneNumber.length != 11) {
      return "Invalid phone number length";
    }
    if (!RegExp(r'^01[0-2,5]\d{8}$').hasMatch(phoneNumber)) {
      return "Invalid phone number format";
    }
    return null;
  }

  static String? locationValidator(String? location) {
    if (location == null || location.isEmpty) {
      return "Location must not be empty";
    }
    return null;
  }

  static String? validateEmpty(String? text) {
    if (text == null || text.isEmpty) {
      return "Field must not be empty";
    }
    return null;
  }

  static String? timeValidator(String? time) {
    if (time == null || time.isEmpty) {
      return "Time must not be empty";
    }
    if (!RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d:[0-5]\d$').hasMatch(time)) {
      return "Invalid time format";
    }
    return null;
  }

  static String? ageValidator(String? age) {
    if (age == null || age.isEmpty) {
      return null;
    }
    int? ageValue = int.tryParse(age);
    if (ageValue == null || ageValue < 18 || ageValue > 48) {
      return "Invalid age";
    }
    return null;
  }

  static String? countryValidator(String? country) {
    if (country == null || country.isEmpty) {
      return "Country must not be empty";
    }
    return null;
  }

  static String? cityValidator(String? city) {
    if (city == null || city.isEmpty) {
      return "City must not be empty";
    }
    return null;
  }

  /// Validates an Egyptian national ID (الرقم القومي المصري).
  /// Requirements: exactly 14 characters and digits only.
  static String? nationalIdValidator(String? id) {
    if (id == null || id.isEmpty) {
      return "National ID must not be empty";
    }
    // exactly 14 digits
    if (!RegExp(r'^\d{14}$').hasMatch(id)) {
      return "Invalid national ID";
    }
    return null;
  }

  /// Returns true if the input contains only ASCII digits 0-9.
  /// This excludes Arabic-Indic digits (٠١٢٣٤٥٦٧٨٩) and Eastern-Arabic digits (۰۱۲۳۴۵۶۷۸۹).
  static bool isAsciiDigitsOnly(String input) {
    return RegExp(r'^[0-9]+$').hasMatch(input);
  }

  static String? englishDigitsOnlyValidator(
    String? value, {
    bool allowEmpty = false,
  }) {
    if (value == null || value.isEmpty) {
      return allowEmpty ? null : "Field must not be empty";
    }
    if (!isAsciiDigitsOnly(value)) {
      return "Only English digits are allowed";
    }
    return null;
  }
}
