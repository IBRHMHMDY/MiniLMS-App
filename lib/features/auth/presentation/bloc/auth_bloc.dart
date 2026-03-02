import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_lms_app/features/auth/domain/usecases/check_auth_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final CheckAuthUseCase checkAuthUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.forgotPasswordUseCase,
    required this.resetPasswordUseCase,
    required this.checkAuthUseCase,
    
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<CheckAuthRequested>(_onCheckAuthRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(event.email, event.password);
    result.fold(
      (failure) =>
          emit(AuthFailure(message: failure.message, errors: failure.errors)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await registerUseCase(
      event.name,
      event.email,
      event.password,
      event.passwordConfirmation,
    );
    result.fold(
      (failure) =>
          emit(AuthFailure(message: failure.message, errors: failure.errors)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await logoutUseCase();
    result.fold(
      (failure) =>
          emit(AuthFailure(message: failure.message, errors: failure.errors)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await forgotPasswordUseCase(event.email);
    result.fold(
      (failure) =>
          emit(AuthFailure(message: failure.message, errors: failure.errors)),
      (_) => emit(
        const PasswordResetTokenSent(message: 'تم إرسال رمز الاستعادة بنجاح'),
      ),
    );
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await resetPasswordUseCase(
      event.email,
      event.token,
      event.password,
      event.passwordConfirmation,
    );
    result.fold(
      (failure) =>
          emit(AuthFailure(message: failure.message, errors: failure.errors)),
      (_) => emit(
        const PasswordResetSuccess(message: 'تم إعادة تعيين كلمة المرور بنجاح'),
      ),
    );
  }

  Future<void> _onCheckAuthRequested(
    CheckAuthRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // محاكاة تأخير بسيط لتظهر الـ Splash Screen بشكل جمالي
    await Future.delayed(const Duration(seconds: 2));
    final result = await checkAuthUseCase();
    result.fold((failure) => emit(AuthUnauthenticated()), (isAuthenticated) {
      if (isAuthenticated) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

}
