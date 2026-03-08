import 'package:dartz/dartz.dart';
import 'package:mini_lms_app/core/error/failures.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/quiz_result_entity.dart';
import 'package:mini_lms_app/features/quiz/domain/repositories/quiz_repository.dart';


class SubmitQuizUseCase {
  final QuizRepository repository;

  SubmitQuizUseCase(this.repository);

  Future<Either<Failure, QuizResultEntity>> call(
    int courseId,
    List<Map<String, int>> answers,
  ) async {
    return await repository.submitQuiz(courseId, answers);
  }
}
