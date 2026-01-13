/// Abstract HTTP client contract for network operations
///
/// ignore: one_member_abstracts
abstract class HttpClient {
  /// Performs a GET request
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
}
