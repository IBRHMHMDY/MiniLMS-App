import 'package:equatable/equatable.dart';
import '../../domain/entities/course_entity.dart';

abstract class CourseState extends Equatable {
  const CourseState();
  @override
  List<Object?> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CoursesLoaded extends CourseState {
  final List<CourseEntity> courses;
  const CoursesLoaded({required this.courses});
  @override
  List<Object> get props => [courses];
}

class CourseDetailsLoaded extends CourseState {
  final CourseEntity course;
  const CourseDetailsLoaded({required this.course});
  @override
  List<Object> get props => [course];
}

class CourseError extends CourseState {
  final String message;
  const CourseError({required this.message});
  @override
  List<Object> get props => [message];
}
