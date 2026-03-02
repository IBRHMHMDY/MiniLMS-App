import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../core/network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core Plugins
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Core Network
  sl.registerLazySingleton(() => DioClient(dio: sl(), secureStorage: sl()));
}
