import '../constants/regex_constants.dart';

final class ValidationHelper {
  ValidationHelper._();

  static bool hasUppercase(String value) {
    return RegexConstants.uppercase.hasMatch(value);
  }

  static bool hasLowercase(String value) {
    return RegexConstants.lowercase.hasMatch(value);
  }

  static bool hasNumber(String value) {
    return RegexConstants.number.hasMatch(value);
  }

  static bool hasSpecialCharacter(String value) {
    return RegexConstants.specialCharacter.hasMatch(value);
  }
}
