final class RegexConstants {
  RegexConstants._();

  static final RegExp email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static final RegExp uppercase = RegExp(r'[A-Z]');

  static final RegExp lowercase = RegExp(r'[a-z]');

  static final RegExp number = RegExp(r'[0-9]');

  static final RegExp specialCharacter = RegExp(
    r'[!@#$%^&*(),.?":{}|<>]',
  );

  static final RegExp username = RegExp(
    r'^[a-zA-Z0-9_.]{3,20}$',
  );

  static final RegExp fullName = RegExp(
    r"^[a-zA-Z\s.'-]{3,50}$",
  );

  static final RegExp otp = RegExp(r'^\d{4}$');

  static final RegExp pin = RegExp(r'^\d{4,6}$');

  static final RegExp url = RegExp(
    r'^(https?:\/\/)?([\w\-])+\.{1}[a-zA-Z]{2,}(\/.*)?$',
  );

  static final RegExp amount = RegExp(
    r'^\d+(\.\d{1,2})?$',
  );
}
