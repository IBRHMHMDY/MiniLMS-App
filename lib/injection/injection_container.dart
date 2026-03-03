import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mini_lms_app/core/network/dio_client.dart';
import 'package:mini_lms_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mini_lms_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mini_lms_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mini_lms_app/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:mini_lms_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:mini_lms_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:mini_lms_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mini_lms_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:mini_lms_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:mini_lms_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mini_lms_app/features/courses/data/datasources/course_remote_data_source.dart';
import 'package:mini_lms_app/features/courses/data/repositories/course_repository_impl.dart';
import 'package:mini_lms_app/features/courses/domain/repositories/course_repository.dart';
import 'package:mini_lms_app/features/courses/domain/usecases/get_categories_usecase.dart';
import 'package:mini_lms_app/features/courses/domain/usecases/get_course_details_usecase.dart';
import 'package:mini_lms_app/features/courses/domain/usecases/get_courses_usecase.dart';
import 'package:mini_lms_app/features/courses/presentation/bloc/category_bloc.dart';
import 'package:mini_lms_app/features/courses/presentation/bloc/course_bloc.dart';
import 'package:mini_lms_app/features/learning/data/datasources/learning_remote_data_source.dart';
import 'package:mini_lms_app/features/learning/data/repositories/learning_repository_impl.dart';
import 'package:mini_lms_app/features/learning/domain/repositories/learning_repository.dart';
import 'package:mini_lms_app/features/learning/domain/usecases/enroll_in_course_usecase.dart';
import 'package:mini_lms_app/features/learning/domain/usecases/get_course_lessons_usecase.dart';
import 'package:mini_lms_app/features/learning/domain/usecases/toggle_lesson_completion_usecase.dart';
import 'package:mini_lms_app/features/learning/presentation/bloc/learning_bloc.dart';
import 'package:mini_lms_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mini_lms_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mini_lms_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:mini_lms_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:mini_lms_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:mini_lms_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mini_lms_app/features/quiz/data/datasources/quiz_remote_data_source.dart';
import 'package:mini_lms_app/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:mini_lms_app/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:mini_lms_app/features/quiz/domain/usecases/get_course_quiz_usecase.dart';
import 'package:mini_lms_app/features/quiz/domain/usecases/submit_quiz_usecase.dart';
import 'package:mini_lms_app/features/quiz/presentation/bloc/quiz_bloc.dart';


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
      checkAuthUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthUseCase(sl()));

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
// --- Features - Courses ---
  // Blocs
  sl.registerFactory(() => CategoryBloc(getCategoriesUseCase: sl()));
  sl.registerFactory(
    () => CourseBloc(getCoursesUseCase: sl(), getCourseDetailsUseCase: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetCoursesUseCase(sl()));
  sl.registerLazySingleton(() => GetCourseDetailsUseCase(sl()));

  // Repository & Data Source
  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(dioClient: sl()),
  );

// --- Features - Learning ---
  // --- Features - Learning ---
  sl.registerFactory(
    () => LearningBloc(
      enrollInCourseUseCase: sl(),
      getCourseLessonsUseCase: sl(),
      toggleLessonCompletionUseCase: sl(), // 👈 حقن الـ UseCase الجديد
    ),
  );
  sl.registerLazySingleton(() => EnrollInCourseUseCase(sl()));
  sl.registerLazySingleton(() => GetCourseLessonsUseCase(sl()));
  sl.registerLazySingleton(
    () => ToggleLessonCompletionUseCase(sl()),
  ); // 👈 تسجيله

  sl.registerLazySingleton<LearningRepository>(
    () => LearningRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<LearningRemoteDataSource>(
    () => LearningRemoteDataSourceImpl(dioClient: sl()),
  );

// --- Features - Quiz ---
  sl.registerFactory(
    () => QuizBloc(getCourseQuizUseCase: sl(), submitQuizUseCase: sl()),
  );
  sl.registerLazySingleton(() => GetCourseQuizUseCase(sl()));
  sl.registerLazySingleton(() => SubmitQuizUseCase(sl()));
  sl.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<QuizRemoteDataSource>(
    () => QuizRemoteDataSourceImpl(dioClient: sl()),
  );

  // --- Core ---
  sl.registerLazySingleton(() => DioClient(dio: sl(), secureStorage: sl()));

  // --- External ---
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
