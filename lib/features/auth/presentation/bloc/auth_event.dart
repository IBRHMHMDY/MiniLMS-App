import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [name, email, password, passwordConfirmation];
}

class LogoutRequested extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  const ForgotPasswordRequested({required this.email});
  @override
  List<Object> get props => [email];
}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  final String token;
  final String password;
  final String passwordConfirmation;

  const ResetPasswordRequested({
    required this.email,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [email, token, password, passwordConfirmation];
}
class CheckAuthRequested extends AuthEvent {}
