import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class CheckAuthUseCase {
  final AuthRepository repository;
  CheckAuthUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.checkAuth();
  }
}
