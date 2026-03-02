import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/lesson_entity.dart';

abstract class LearningRepository {
  Future<Either<Failure, void>> enrollInCourse(int courseId);
  Future<Either<Failure, List<LessonEntity>>> getCourseLessons(int courseId);
}
