import '../models/api_validation_error_model.dart';

final class ApiErrorParser {
  ApiErrorParser._();

  static Map<String, String> parse(
    Map<String, dynamic> json,
  ) {
    final model = ApiValidationErrorModel.fromJson(json);

    return model.errors.map(
      (key, value) => MapEntry(
        key,
        value.first,
      ),
    );
  }
}
