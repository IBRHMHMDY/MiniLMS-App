import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/category_entity.dart';
import '../entities/course_entity.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<CourseEntity>>> getCourses();
  Future<Either<Failure, CourseEntity>> getCourseDetails(int courseId);
}
