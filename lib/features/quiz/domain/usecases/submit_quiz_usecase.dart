import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/quiz_entities.dart';
import '../repositories/quiz_repository.dart';

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
