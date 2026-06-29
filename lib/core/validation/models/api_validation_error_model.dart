class ApiValidationErrorModel {
  final Map<String, List<String>> errors;

  const ApiValidationErrorModel({
    required this.errors,
  });

  factory ApiValidationErrorModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawErrors = json['errors'] as Map<String, dynamic>? ?? {};

    return ApiValidationErrorModel(
      errors: rawErrors.map(
        (key, value) => MapEntry(
          key,
          List<String>.from(value),
        ),
      ),
    );
  }
}
