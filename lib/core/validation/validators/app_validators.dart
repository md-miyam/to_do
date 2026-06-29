import '../constants/regex_constants.dart';
import '../constants/validation_constants.dart';
import '../helpers/validation_helper.dart';
import '../services/validation_message_service.dart';
import '../typedefs/validator_typedefs.dart';

final class AppValidators {
  AppValidators._();

  static String? required(
    String? value, {
    required String fieldName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return ValidationMessageService.requiredField(
        fieldName,
      );
    }

    return null;
  }

  static String? email(String? value) {
    final requiredError = required(
      value,
      fieldName: 'Email',
    );

    if (requiredError != null) {
      return requiredError;
    }

    if (!RegexConstants.email.hasMatch(value!.trim())) {
      return ValidationMessageService.invalidEmail();
    }

    return null;
  }

  static String? password(String? value) {
    final requiredError = required(
      value,
      fieldName: 'Password',
    );

    if (requiredError != null) {
      return requiredError;
    }

    final password = value!.trim();

    if (password.length <
        ValidationConstants.minPasswordLength) {
      return ValidationMessageService.weakPassword();
    }

    if (!ValidationHelper.hasUppercase(password)) {
      return ValidationMessageService.weakPassword();
    }

    if (!ValidationHelper.hasLowercase(password)) {
      return ValidationMessageService.weakPassword();
    }

    if (!ValidationHelper.hasNumber(password)) {
      return ValidationMessageService.weakPassword();
    }

    if (!ValidationHelper.hasSpecialCharacter(password)) {
      return ValidationMessageService.weakPassword();
    }

    return null;
  }

  static String? confirmPassword(
    String? value,
    String password,
  ) {
    final requiredError = required(
      value,
      fieldName: 'Confirm Password',
    );

    if (requiredError != null) {
      return requiredError;
    }

    if (value != password) {
      return ValidationMessageService.passwordMismatch();
    }

    return null;
  }

  static String? otp(String? value) {
    final requiredError = required(
      value,
      fieldName: 'OTP',
    );

    if (requiredError != null) {
      return requiredError;
    }

    if (value!.length != 4) {
      return ValidationMessageService.invalidOtpLength(4);
    }

    if (!RegexConstants.otp.hasMatch(value)) {
      return ValidationMessageService.invalidOtp();
    }

    return null;
  }

  static String? pin(String? value) {
    final requiredError = required(
      value,
      fieldName: 'PIN',
    );

    if (requiredError != null) {
      return requiredError;
    }

    if (!RegexConstants.pin.hasMatch(value!)) {
      return ValidationMessageService.invalidPin();
    }

    return null;
  }

  static String? username(String? value) {
    final requiredError = required(
      value,
      fieldName: 'Username',
    );

    if (requiredError != null) {
      return requiredError;
    }

    if (!RegexConstants.username.hasMatch(value!)) {
      return ValidationMessageService.invalidUsername();
    }

    return null;
  }

  static String? fullName(String? value) {
    final requiredError = required(
      value,
      fieldName: 'Full Name',
    );

    if (requiredError != null) {
      return requiredError;
    }

    if (!RegexConstants.fullName.hasMatch(value!)) {
      return ValidationMessageService.invalidName();
    }

    return null;
  }

  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (!RegexConstants.url.hasMatch(value.trim())) {
      return ValidationMessageService.invalidUrl();
    }

    return null;
  }

  static String? amount(String? value) {
    final requiredError = required(
      value,
      fieldName: 'Amount',
    );

    if (requiredError != null) {
      return requiredError;
    }

    if (!RegexConstants.amount.hasMatch(value!)) {
      return ValidationMessageService.invalidAmount();
    }

    return null;
  }

  static String? optional(
    String? value,
    Validator validator,
  ) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    return validator(value);
  }
}
