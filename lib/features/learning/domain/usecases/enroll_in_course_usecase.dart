import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/learning_repository.dart';

class EnrollInCourseUseCase {
  final LearningRepository repository;

  EnrollInCourseUseCase(this.repository);

  Future<Either<Failure, void>> call(int courseId) async {
    return await repository.enrollInCourse(courseId);
  }
}
