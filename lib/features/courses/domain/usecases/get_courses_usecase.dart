import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class GetCoursesUseCase {
  final CourseRepository repository;

  GetCoursesUseCase(this.repository);

  Future<Either<Failure, List<CourseEntity>>> call() async {
    return await repository.getCourses();
  }
}
