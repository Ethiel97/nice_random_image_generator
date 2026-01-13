import 'package:flutter/material.dart';
import 'package:nice_image/core/utils/utils.dart';
import 'package:nice_image/l10n/l10n.dart';

/// Error category for better UI representation
enum ErrorCategory {
  network,
  server,
  unknown;
}

/// Extension on ErrorDetails to provide UI-related error information
extension ErrorDetailsUI on ErrorDetails {
  /// Categorizes the error based on the message content
  ErrorCategory get category {
    final messageString = message.toString().toLowerCase();

    if (messageString.contains('connection') ||
        messageString.contains('network') ||
        messageString.contains('timeout')) {
      return ErrorCategory.network;
    }

    if (messageString.contains('server') ||
        messageString.contains('500') ||
        messageString.contains('503')) {
      return ErrorCategory.server;
    }

    return ErrorCategory.unknown;
  }

  /// Returns appropriate icon for the error category
  IconData get icon => switch (category) {
      ErrorCategory.network => Icons.wifi_off,
      ErrorCategory.server => Icons.cloud_off,
      ErrorCategory.unknown => Icons.error_outline,
    };

  /// Returns user-friendly title for the error category
  String getTitle(AppLocalizations l10n) => switch (category) {
      ErrorCategory.network => 'Connection Error',
      ErrorCategory.server => 'Server Error',
      ErrorCategory.unknown => 'Oops! Something went wrong',
    };

  /// Returns the error message as a string
  String get displayMessage => message.toString();
}
