import 'package:dartz/dartz.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/quiz_entity.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/quiz_result_entity.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_remote_data_source.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource remoteDataSource;

  QuizRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, QuizEntity>> getCourseQuiz(int courseId) async {
    try {
      final quiz = await remoteDataSource.getCourseQuiz(courseId);
      return Right(quiz as QuizEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuizResultEntity>> submitQuiz(
    int courseId,
    List<Map<String, int>> answers,
  ) async {
    try {
      final result = await remoteDataSource.submitQuiz(courseId, answers);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
