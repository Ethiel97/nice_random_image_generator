import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nice_image/core/errors/errors.dart';
import 'package:nice_image/core/network/http_client.dart';
import 'package:nice_image/core/utils/utils.dart';

/// Dio implementation of HttpClient
@LazySingleton(as: HttpClient)
class DioHttpClient implements HttpClient {
  DioHttpClient(this._dio);

  final Dio _dio;

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      if (response.data == null) {
        throw const DataException('Response data is null');
      }

      return response.data!;
    } on DioException catch (e, stackTrace) {
      throw _mapDioException(e, stackTrace);
    } catch (e, stackTrace) {
      throw UnknownException(
        'Unexpected error: $e',
        ErrorDetails(message: e.toString(), stackTrace: stackTrace),
      );
    }
  }

  AppException _mapDioException(DioException e, StackTrace stackTrace) {
    final details = ErrorDetails(
      message: e.message ?? 'Unknown error',
      errorCode: e.response?.statusCode,
      stackTrace: stackTrace,
    );

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout', details);
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection', details);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode != null && statusCode >= 500) {
          return ServerException('Server error ($statusCode)', details);
        }
        return ServerException('Request failed ($statusCode)', details);
      case DioExceptionType.cancel:
        return NetworkException('Request cancelled', details);
      case DioExceptionType.badCertificate:
        return NetworkException('Invalid certificate', details);
      case DioExceptionType.unknown:
        return UnknownException('Network error: ${e.message}', details);
    }
  }
}
