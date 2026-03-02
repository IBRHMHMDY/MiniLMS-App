import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_lms_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mini_lms_app/features/auth/presentation/screens/login_screen.dart';
import 'package:mini_lms_app/features/auth/presentation/screens/register_screen.dart';
import 'package:mini_lms_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mini_lms_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:mini_lms_app/features/profile/presentation/screens/forgot_password_screen.dart';
import 'package:mini_lms_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:mini_lms_app/features/profile/presentation/screens/reset_password_screen.dart';
import 'package:mini_lms_app/injection/injection_container.dart';


class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation:
        '/login', // سيتم تعديلها لاحقاً لتوجيه المستخدم حسب الـ Token
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
        path: '/profile',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<ProfileBloc>()..add(GetProfileEvent()),
            ),
            BlocProvider(
              create: (_) => sl<AuthBloc>(), // للتعامل مع تسجيل الخروج
            ),
          ],
          child: const ProfileScreen(),
        ),
      ),
    ],
  );
}
