import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_lms_app/core/widgets/main_screen.dart';
import 'package:mini_lms_app/features/learning/presentation/screens/my_courses_screen.dart';
import 'package:mini_lms_app/features/profile/presentation/screens/forgot_password_screen.dart';
import 'package:mini_lms_app/features/profile/presentation/screens/reset_password_screen.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/quiz_entities.dart';
import 'package:mini_lms_app/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:mini_lms_app/features/quiz/presentation/screens/quiz_result_screen.dart';
import 'package:mini_lms_app/features/quiz/presentation/screens/quiz_screen.dart';

// Auth
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';


// Profile
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_event.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

// Courses
import '../../features/courses/presentation/bloc/category_bloc.dart';
import '../../features/courses/presentation/bloc/course_bloc.dart';
import '../../features/courses/presentation/screens/home_screen.dart';
import '../../features/courses/presentation/screens/course_details_screen.dart';

// Learning
import '../../features/learning/presentation/bloc/learning_bloc.dart';
import '../../features/learning/presentation/screens/course_lessons_screen.dart';

import '../../injection/injection_container.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // التوجيه الافتراضي هو الـ Splash Screen
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => sl<CategoryBloc>()),
                BlocProvider(create: (_) => sl<CourseBloc>()),
              ],
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/my-courses',
            builder: (context, state) => const MyCoursesScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => sl<ProfileBloc>()..add(GetProfileEvent()),
                ),
                BlocProvider(create: (_) => sl<AuthBloc>()),
              ],
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: ResetPasswordScreen(email: email),
          );
        },
      ),
      
      GoRoute(
        path: '/course/:id',
        builder: (context, state) {
          final courseId = int.parse(state.pathParameters['id']!);
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<CourseBloc>()),
              BlocProvider(create: (_) => sl<LearningBloc>()),
            ],
            child: CourseDetailsScreen(courseId: courseId),
          );
        },
      ),
      GoRoute(
        path: '/course/:id/lessons',
        builder: (context, state) {
          final courseId = int.parse(state.pathParameters['id']!);
          return BlocProvider(
            create: (_) => sl<LearningBloc>(),
            child: CourseLessonsScreen(courseId: courseId),
          );
        },
      ),
      GoRoute(
        path: '/course/:id/quiz',
        builder: (context, state) {
          final courseId = int.parse(state.pathParameters['id']!);
          return BlocProvider(
            create: (_) => sl<QuizBloc>(),
            child: QuizScreen(courseId: courseId),
          );
        },
      ),
      GoRoute(
        path: '/course/:id/quiz/result',
        builder: (context, state) {
          final result = state.extra as QuizResultEntity;
          return QuizResultScreen(result: result);
        },
      ),
      
    ],
  );
}
