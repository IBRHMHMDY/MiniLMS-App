import 'package:dartz/dartz.dart';
import 'package:mini_lms_app/core/error/failures.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/quiz_entity.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/quiz_result_entity.dart';


abstract class QuizRepository {
  Future<Either<Failure, QuizEntity>> getCourseQuiz(int courseId);
  Future<Either<Failure, QuizResultEntity>> submitQuiz(
    int courseId,
    List<Map<String, int>> answers,
  );
}
