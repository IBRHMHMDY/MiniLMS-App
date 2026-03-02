import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final user = await remoteDataSource.getProfile();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(
    String name,
    String? email,
  ) async {
    try {
      final user = await remoteDataSource.updateProfile(name, email);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
