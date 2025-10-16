import '../services/base_services.dart';

class ApiProvider {
  static ApiProvider? _instance;
  static ApiProvider get instance {
    _instance ??= ApiProvider._internal();
    return _instance!;
  }

  ApiProvider._internal();

  BaseServices? _baseServices;

  /// Initialize the API provider
  BaseServices get baseServices {
    _baseServices ??= BaseServices();
    return _baseServices!;
  }

  /// Update base URL (useful for environment switching)
  void updateBaseUrl(String newBaseUrl) {
    BaseServices.hostUrl = newBaseUrl;
    _baseServices = null; // Force recreation with new URL
  }

  /// Get current base URL
  String get baseUrl => BaseServices.hostUrl ?? '';

  /// Common response handling
  T? handleResponse<T>(MyResponse<T, dynamic> response) {
    if (response.isSuccess) {
      return response.data;
    } else {
      throw ApiException(
        message: response.error?.toString() ?? 'Unknown error occurred',
        statusCode: response.error is Map<String, dynamic>
            ? response.error['status_code']
            : null,
      );
    }
  }

  /// Handle response with custom error handling
  T? handleResponseWithCallback<T>(
    MyResponse<T, dynamic> response,
    Function(dynamic error)? onError,
  ) {
    if (response.isSuccess) {
      return response.data;
    } else {
      if (onError != null) {
        onError(response.error);
      }
      return null;
    }
  }
}

/// Custom API Exception class
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException({required this.message, this.statusCode, this.originalError});

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException ($statusCode): $message';
    }
    return 'ApiException: $message';
  }

  /// Check if this is a network error
  bool get isNetworkError {
    return message.toLowerCase().contains('network') ||
        message.toLowerCase().contains('connection') ||
        message.toLowerCase().contains('timeout');
  }

  /// Check if this is an authentication error
  bool get isAuthError {
    return statusCode == 401 || statusCode == 403;
  }

  /// Check if this is a validation error
  bool get isValidationError {
    return statusCode == 422 || statusCode == 400;
  }

  /// Check if this is a server error
  bool get isServerError {
    return statusCode != null && statusCode! >= 500;
  }
}
