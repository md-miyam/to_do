import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import '../services/validation_message_service.dart';

final class PhoneValidator {
  PhoneValidator._();

  static String? validate(String? value, {String? countryCode}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationMessageService.requiredField('Phone number');
    }

    try {
      IsoCode? isoCode;
      if (countryCode != null) {
        try {
          isoCode = IsoCode.fromJson(countryCode.toUpperCase());
        } catch (_) {
          // If invalid country code, continue without it
        }
      }

      final phone = PhoneNumber.parse(value, destinationCountry: isoCode);

      if (!phone.isValid()) {
        return ValidationMessageService.invalidPhone();
      }

      return null;
    } catch (_) {
      return ValidationMessageService.invalidPhone();
    }
  }
}
