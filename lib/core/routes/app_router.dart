import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_lms_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mini_lms_app/features/auth/presentation/screens/login_screen.dart';
import 'package:mini_lms_app/features/auth/presentation/screens/register_screen.dart';
import 'package:mini_lms_app/features/courses/presentation/bloc/category_bloc.dart';
import 'package:mini_lms_app/features/courses/presentation/bloc/course_bloc.dart';
import 'package:mini_lms_app/features/courses/presentation/screens/course_details_screen.dart';
import 'package:mini_lms_app/features/courses/presentation/screens/home_screen.dart';
import 'package:mini_lms_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mini_lms_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:mini_lms_app/features/profile/presentation/screens/forgot_password_screen.dart';
import 'package:mini_lms_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:mini_lms_app/features/profile/presentation/screens/reset_password_screen.dart';
import 'package:mini_lms_app/injection/injection_container.dart';


class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home', // التوجيه الافتراضي الآن هو الصفحة الرئيسية
    routes: [
      // --- مسارات المصادقة ---
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

      // --- مسارات التطبيق الداخلي ---
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
        path: '/course/:id',
        builder: (context, state) {
          final courseId = int.parse(state.pathParameters['id']!);
          return BlocProvider(
            create: (_) => sl<CourseBloc>(),
            child: CourseDetailsScreen(courseId: courseId),
          );
        },
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
  );
}
