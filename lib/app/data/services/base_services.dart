import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HttpRequestType { GET, POST, PUT, DELETE }

class MyResponse<T, E> {
  MyResponse.complete(this.data, {this.headers})
    : error = null,
      isSuccess = true;

  MyResponse.error(this.error, {this.headers}) : data = null, isSuccess = false;
  final T? data;
  final E? error;
  final Map<String, List<String>>? headers;
  final bool isSuccess;
}

class JsonParsing {
  JsonParsing(this.data);
  final dynamic data;

  Map<String, dynamic> toJson() {
    if (data is Map<String, dynamic>) {
      return data as Map<String, dynamic>;
    }
    return {'error': data.toString()};
  }
}

/// A base class to unified all the required common fields and functions
class BaseServices {
  BaseServices() {
    _init();
  }

  static BaseServices? _instance;
  static String? hostUrl = 'https://massage-therapy-backend.onrender.com';

  String apiUrl() => hostUrl ?? '';

  /// private access dio instance and accessible using dio() getter
  Dio? _dio;

  /// eg: single dio instance will created and reuse by all services.
  /// remove the needs to create new Dio() instance in every services
  Dio? get dio {
    if (_instance == null || _instance?._dio == null) {
      _init();
    }
    return _instance?._dio;
  }

  /// Generate the token strings with Bearer Authentication format
  Future<String> get authToken async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return token.isNotEmpty ? 'Bearer $token' : '';
  }

  Future<void> _requestInterceptor(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requiresAuth = (options.extra['requiresAuth'] as bool?) ?? true;
    if (requiresAuth) {
      final accessToken = await authToken;
      if (accessToken.isNotEmpty) {
        options.headers.addAll({'Authorization': accessToken});
      }
    }
    handler.next(options);
  }

  /// Function to include all required initialization steps
  /// 1. Create Dio() instance with Options
  /// 2. Added AuthenticationInterceptor to handle JWT Authentication Feature
  void _init() {
    _instance = this;

    _dio = Dio(
      BaseOptions(
        baseUrl: hostUrl ?? '', // Add baseUrl here
        headers: <String, String>{'Content-Type': ContentType.json.value},
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    _dio?.interceptors.add(
      QueuedInterceptorsWrapper(onRequest: _requestInterceptor),
    );

    // Add logging interceptor for debugging
    _dio?.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        logPrint: (obj) =>
            debugPrint('🌐 DIO: $obj'), // Use print for easier debugging
      ),
    );
  }

  /// Standardized api calling with try-catch block
  /// Respond with MyResponse object for consistent data/error handling in services layer
  /// Accessible by all inheriting classes
  Future<MyResponse<dynamic, dynamic>> callAPI(
    HttpRequestType requestType,
    String path, {
    Map<String, dynamic>? postBody,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      debugPrint('🚀 Making API call: ${requestType.name} $path');
      debugPrint('📦 Request body: $postBody');

      dio?.options.contentType = Headers.jsonContentType;
      Response<dynamic>? response;

      // Set requiresAuth in options
      final finalOptions = options ?? Options();
      finalOptions.extra = {
        ...(finalOptions.extra ?? {}),
        'requiresAuth': requiresAuth,
      };

      switch (requestType) {
        case HttpRequestType.GET:
          response = await dio?.get<dynamic>(path, options: finalOptions);
        case HttpRequestType.POST:
          response = await dio?.post<dynamic>(
            path,
            data: postBody,
            options: finalOptions,
          );
        case HttpRequestType.PUT:
          response = await dio?.put<dynamic>(
            path,
            data: postBody,
            options: finalOptions,
          );
        case HttpRequestType.DELETE:
          response = await dio?.delete<dynamic>(
            path,
            data: postBody,
            options: finalOptions,
          );
      }

      debugPrint('📥 Response status: ${response?.statusCode}');
      debugPrint('📥 Response data: ${response?.data}');

      if (response?.statusCode == HttpStatus.ok ||
          response?.statusCode == HttpStatus.created) {
        return MyResponse.complete(
          response?.data,
          headers: response?.headers.map,
        );
      } else {
        debugPrint('❌ Unexpected status code: ${response?.statusCode}');
        return MyResponse.error(
          'HTTP ${response?.statusCode}: ${response?.statusMessage}',
        );
      }
    } catch (e) {
      debugPrint('💥 API Error: $e');
      if (e is DioException) {
        debugPrint('🔍 DioException type: ${e.type}');
        debugPrint('🔍 DioException message: ${e.message}');
        debugPrint('🔍 Response data: ${e.response?.data}');
        debugPrint('🔍 Response status: ${e.response?.statusCode}');

        if (e.response?.data != null && e.response?.data != '') {
          return MyResponse.error(
            JsonParsing(e.response?.data).toJson(),
            headers: e.response?.headers.map,
          );
        }
      }
      return MyResponse.error(e.toString());
    }
  }

  Future<MyResponse<dynamic, dynamic>> callAPIUsingFormData(
    HttpRequestType requestType,
    String path, {
    FormData? formData,
    Options? options,
  }) async {
    try {
      Response<dynamic>? response;

      switch (requestType) {
        case HttpRequestType.GET:
          response = await dio?.get<dynamic>(path);
        case HttpRequestType.POST:
          response = await dio?.post<dynamic>(path, data: formData);
        case HttpRequestType.PUT:
          response = await dio?.put<dynamic>(path, data: formData);
        case HttpRequestType.DELETE:
          response = await dio?.delete<dynamic>(path, data: formData);
      }

      if (response?.statusCode == HttpStatus.ok ||
          response?.statusCode == HttpStatus.created) {
        return MyResponse.complete(response?.data);
      }
    } catch (e) {
      debugPrint('Form data API error: $e');
      if (e is DioException &&
          e.response?.data != null &&
          e.response?.data != '') {
        return MyResponse.error(JsonParsing(e.response?.data).toJson());
      }
      return MyResponse.error(e);
    }
    final error = MyResponse<dynamic, dynamic>.error(
      DioException(requestOptions: RequestOptions(path: path)),
    );
    debugPrint('Form data error: $error');
    return error;
  }

  Future<MyResponse<dynamic, dynamic>> callUpload(
    String path,
    File file,
  ) async {
    try {
      dio?.options.contentType = 'multipart/form-data';

      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await dio?.post<dynamic>(path, data: formData);

      if (response?.statusCode == HttpStatus.ok) {
        return MyResponse.complete(response?.data);
      }
    } catch (e) {
      if (e is DioException && e.response?.data != null) {
        return MyResponse.error(JsonParsing(e.response?.data).toJson());
      }
      return MyResponse.error(e);
    }
    return MyResponse.error(
      DioException(requestOptions: RequestOptions(path: path)),
    );
  }
}
