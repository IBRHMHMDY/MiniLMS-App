import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;

  const AuthSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;
  final Map<String, dynamic>? errors;

  const AuthFailure({required this.message, this.errors});

  @override
  List<Object?> get props => [message, errors];
}

class AuthUnauthenticated extends AuthState {}

class PasswordResetTokenSent extends AuthState {
  final String message;
  const PasswordResetTokenSent({required this.message});
  @override
  List<Object?> get props => [message];
}

class PasswordResetSuccess extends AuthState {
  final String message;
  const PasswordResetSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}
