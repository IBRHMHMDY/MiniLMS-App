import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_data_source.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;

  CourseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CourseEntity>>> getCourses() async {
    try {
      final courses = await remoteDataSource.getCourses();
      return Right(courses);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CourseEntity>> getCourseDetails(int courseId) async {
    try {
      final course = await remoteDataSource.getCourseDetails(courseId);
      return Right(course);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CourseEntity>>> getMyCourses() async {
    try {
      final courses = await remoteDataSource.getMyCourses();
      return Right(courses);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
