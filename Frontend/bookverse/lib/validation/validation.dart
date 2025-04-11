
String? validateField(String? value, String fieldName, {int minLength = 1}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  } else if (value.length < minLength) {
    return '$fieldName must be at least $minLength characters long';
  }
  return null;
}

String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }