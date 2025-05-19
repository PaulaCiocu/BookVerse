
  String? validateField(String? value, String fieldName, {int minLength = 1}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    } else if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters long';
    }
    return null;
  }
  

  String? validateFieldNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Can not be empty';
    } 
    return null;
  }

    String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Can not be empty';
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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    String passwordRegex =
        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$";
    if (!RegExp(passwordRegex).hasMatch(value)) {
      return 'Password must contain at least 8 characters, uppercase letter, lowercase, number and special character';
    }
    return null;
  }

  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
      return 'Enter a valid name (letters and spaces only)';
    }
    if (value.trim().length < 2 || value.trim().length > 50) {
      return 'Name must be between 2 and 50 characters';
    }
    return null;
  }