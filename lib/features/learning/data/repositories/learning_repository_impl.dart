import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/learning_repository.dart';
import '../datasources/learning_remote_data_source.dart';

class LearningRepositoryImpl implements LearningRepository {
  final LearningRemoteDataSource remoteDataSource;

  LearningRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> enrollInCourse(int courseId) async {
    try {
      await remoteDataSource.enrollInCourse(courseId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LessonEntity>>> getCourseLessons(
    int courseId,
  ) async {
    try {
      final lessons = await remoteDataSource.getCourseLessons(courseId);
      return Right(lessons);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
