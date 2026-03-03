import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/quiz_entities.dart';
import '../repositories/quiz_repository.dart';

class GetCourseQuizUseCase {
  final QuizRepository repository;

  GetCourseQuizUseCase(this.repository);

  Future<Either<Failure, QuizEntity>> call(int courseId) async {
    return await repository.getCourseQuiz(courseId);
  }
}
