import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({String baseUrl = 'https://bored-api.appbrewery.com/'})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 5), // 5 seconds
          receiveTimeout: const Duration(seconds: 3), // 3 seconds
        ),
      ) {
    // Optional: Add interceptors for logging, authentication, etc.
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
      );
      // TODO: Add more specific success handling if needed
      return response;
    } on DioException {
      // Handle Dio-specific errors (network, timeout, status codes, etc.)
      // TODO: Implement proper error handling/logging
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Example POST request
  Future<Response<T>> post<T>(String path, {dynamic data}) async {
    try {
      final response = await _dio.post<T>(path, data: data);
      // TODO: Add more specific success handling if needed
      return response;
    } on DioException catch (e) {
      // Handle Dio-specific errors
      // TODO: Implement proper error handling/logging
      print('Dio error!: ${e.message}');
      rethrow;
    } catch (e) {
      // Handle other potential errors
      print('Unexpected error: $e');
      rethrow;
    }
  }

  // TODO: Add methods for other HTTP verbs (PUT, DELETE, etc.) as needed
}
