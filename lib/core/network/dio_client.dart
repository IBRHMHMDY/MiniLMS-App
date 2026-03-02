import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../error/exceptions.dart';

class DioClient {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  DioClient({required this.dio, required this.secureStorage}) {
    // إعدادات الـ Base URL (عدلها حسب بيئتك إذا كنت تستخدم هاتف حقيقي)
    dio.options.baseUrl = 'http://192.168.1.10:8000/api/v1';
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // إضافة Interceptor لحقن الـ Token تلقائياً
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await secureStorage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  // --- دوال الـ Wrapper التي تصطاد الأخطاء ---

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await dio.put(path, data: data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await dio.delete(path);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // --- المترجم الذكي لأخطاء Laravel ---

  ServerException _handleDioError(DioException e) {
    if (e.response != null && e.response?.data is Map) {
      final data = e.response!.data as Map<String, dynamic>;

      String message = data['message'] ?? 'حدث خطأ في الخادم';

      // استخراج أخطاء التحقق (Validation Errors) الخاصة بلارافيل بشكل أنيق
      Map<String, dynamic>? errors = data['errors'];
      if (errors != null && errors.isNotEmpty) {
        // جلب أول رسالة خطأ تفصيلية (مثلاً: "البريد الإلكتروني مستخدم من قبل") لعرضها للمستخدم مباشرة
        message = errors.values.first[0].toString();
      }

      return ServerException(message: message, errors: errors);
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ServerException(
        message: 'انتهى وقت الاتصال، تأكد من جودة الإنترنت.',
      );
    } else if (e.type == DioExceptionType.connectionError) {
      return ServerException(message: 'لا يوجد اتصال بالإنترنت.');
    } else {
      return ServerException(message: 'حدث خطأ غير متوقع. حاول مرة أخرى.');
    }
  }
}
