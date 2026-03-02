import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;
  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(
    String email,
    String token,
    String password,
    String passwordConfirmation,
  ) async {
    return await repository.resetPassword(
      email,
      token,
      password,
      passwordConfirmation,
    );
  }
}
