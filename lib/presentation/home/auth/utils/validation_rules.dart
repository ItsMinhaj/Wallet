class ValidationRules {
  static String? email(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter something";
    } else if (!text.contains('@')) {
      return "Please write a valid email address";
    } else {
      return null;
    }
  }

  static String? password(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter your password";
    } else if (text.length < 8) {
      return "Password length should be minimum 8";
    } else {
      return null;
    }
  }
}
