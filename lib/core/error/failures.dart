import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final Map<String, dynamic>? errors;

  const Failure(this.message, {this.errors});

  @override
  List<Object?> get props => [message, errors];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.errors});
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
