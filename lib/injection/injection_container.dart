import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mini_lms_app/core/network/dio_client.dart';
import 'package:mini_lms_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mini_lms_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mini_lms_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mini_lms_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:mini_lms_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:mini_lms_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mini_lms_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:mini_lms_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:mini_lms_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mini_lms_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mini_lms_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mini_lms_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:mini_lms_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:mini_lms_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:mini_lms_app/features/profile/presentation/bloc/profile_bloc.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // --- Features - Auth ---
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      forgotPasswordUseCase: sl(),
      resetPasswordUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: sl(), secureStorage: sl()),
  );

  // --- Features - Profile ---
  sl.registerFactory(
    () => ProfileBloc(getProfileUseCase: sl(), updateProfileUseCase: sl()),
  );

  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dioClient: sl()),
  );

  // --- Core ---
  sl.registerLazySingleton(() => DioClient(dio: sl(), secureStorage: sl()));

  // --- External ---
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
