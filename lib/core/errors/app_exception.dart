import 'package:equatable/equatable.dart';
import 'package:nice_image/core/utils/utils.dart';

/// Base exception class for all application errors
abstract class AppException extends Equatable implements Exception {
  const AppException(this.message, [this.details]);

  final String message;
  final ErrorDetails? details;

  @override
  List<Object?> get props => [message, details];

  @override
  String toString() {
    return 'AppException: $message${details != null ? ' - $details' : ''}';
  }
}

/// Network-related errors
class NetworkException extends AppException {
  const NetworkException(super.message, [super.details]);
}

/// Server-related errors
class ServerException extends AppException {
  const ServerException(super.message, [super.details]);
}

/// Parsing/Data errors
class DataException extends AppException {
  const DataException(super.message, [super.details]);
}

/// Generic error when cause is unknown
class UnknownException extends AppException {
  const UnknownException([
    super.message = 'An unknown error occurred',
    super.details,
  ]);
}
