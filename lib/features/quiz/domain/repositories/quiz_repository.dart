import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/quiz_entities.dart';

abstract class QuizRepository {
  Future<Either<Failure, QuizEntity>> getCourseQuiz(int courseId);
  Future<Either<Failure, QuizResultEntity>> submitQuiz(
    int courseId,
    List<Map<String, int>> answers,
  );
}
