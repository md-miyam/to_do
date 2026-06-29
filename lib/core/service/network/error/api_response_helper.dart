class ApiResponseHelper {
  ApiResponseHelper._();

  static const String fallbackMessage = "Something went wrong";

  static Map<String, dynamic>? asMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    return null;
  }

  static String message(
    Map<String, dynamic>? response, {
    String fallback = fallbackMessage,
  }) {
    final msg = response?["message"]?.toString();
    if (msg != null && msg.isNotEmpty) return msg;
    return fallback;
  }

  static bool isSuccess(Map<String, dynamic>? response) {
    return response?["success"] == true;
  }

  static String? token(Map<String, dynamic>? response) {
    final data = response?["data"];
    if (data is! Map<String, dynamic>) return null;

    final lowerToken = data["token"]?.toString();
    if (lowerToken != null && lowerToken.isNotEmpty) return lowerToken;

    final upperToken = data["Token"]?.toString();
    if (upperToken != null && upperToken.isNotEmpty) return upperToken;

    return null;
  }
}
