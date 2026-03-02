import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;
  const ProfileLoaded({required this.user});
  @override
  List<Object> get props => [user];
}

class ProfileUpdateSuccess extends ProfileState {
  final UserEntity user;
  final String message;
  const ProfileUpdateSuccess({required this.user, required this.message});
  @override
  List<Object> get props => [user, message];
}

class ProfileError extends ProfileState {
  final String message;
  final Map<String, dynamic>? errors;
  const ProfileError({required this.message, this.errors});
  @override
  List<Object?> get props => [message, errors];
}
