import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../error/exceptions.dart';

class DioClient {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  // للمحاكي Android استخدم 10.0.2.2، وللـ iOS استخدم 127.0.0.1 أو الـ IP الخاص بجهازك
  static const String baseUrl = 'http://192.168.1.10:8000/api/v1';

  DioClient({required this.dio, required this.secureStorage}) {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await secureStorage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _handleDioError(e);
          return handler.next(e);
        },
      ),
    );
  }

  void _handleDioError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data != null && data is Map<String, dynamic>) {
        throw ServerException(
          message: data['message'] ?? 'Unknown error occurred',
          errors: data['errors'] as Map<String, dynamic>?,
        );
      } else {
        throw ServerException(
          message: 'Server Error: ${e.response?.statusCode}',
        );
      }
    } else {
      throw ServerException(
        message: 'Network Error: Please check your connection',
      );
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await dio.post(path, data: data);
  }
}
