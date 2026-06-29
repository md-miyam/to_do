final class ValidationMessageService {
  ValidationMessageService._();

  static String requiredField(String field) =>
      '$field is required';

  static String invalidEmail() =>
      'Please enter a valid email address';

  static String invalidPhone() =>
      'Please enter a valid phone number';

  static String invalidUrl() =>
      'Please enter a valid URL';

  static String invalidOtp() =>
      'Invalid OTP';

  static String invalidOtpLength(int length) =>
      'OTP must be $length digits';

  static String invalidPin() =>
      'Invalid PIN';

  static String invalidUsername() =>
      'Username format is invalid';

  static String invalidName() =>
      'Please enter a valid full name';

  static String weakPassword() =>
      'Password does not meet security requirements';

  static String invalidAmount() =>
      'Invalid amount';

  static String passwordMismatch() =>
      'Passwords do not match';
}
