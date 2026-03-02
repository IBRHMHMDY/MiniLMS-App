import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/lesson_entity.dart';
import '../repositories/learning_repository.dart';

class GetCourseLessonsUseCase {
  final LearningRepository repository;

  GetCourseLessonsUseCase(this.repository);

  Future<Either<Failure, List<LessonEntity>>> call(int courseId) async {
    return await repository.getCourseLessons(courseId);
  }
}
