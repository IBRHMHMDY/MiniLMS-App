import 'package:dartz/dartz.dart';
import 'package:mini_lms_app/core/error/failures.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/quiz_entity.dart';
import 'package:mini_lms_app/features/quiz/domain/repositories/quiz_repository.dart';


class GetCourseQuizUseCase {
  final QuizRepository repository;

  GetCourseQuizUseCase(this.repository);

  Future<Either<Failure, QuizEntity>> call(int courseId) async {
    return await repository.getCourseQuiz(courseId);
  }
}
