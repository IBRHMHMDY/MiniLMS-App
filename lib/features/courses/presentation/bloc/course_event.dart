import 'package:equatable/equatable.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();
  @override
  List<Object> get props => [];
}

class GetCoursesEvent extends CourseEvent {}

class GetCourseDetailsEvent extends CourseEvent {
  final int courseId;
  const GetCourseDetailsEvent({required this.courseId});
  @override
  List<Object> get props => [courseId];
}
class GetMyCoursesEvent extends CourseEvent {}
