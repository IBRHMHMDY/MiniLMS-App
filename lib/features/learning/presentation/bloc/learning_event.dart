import 'package:equatable/equatable.dart';

abstract class LearningEvent extends Equatable {
  const LearningEvent();
  @override
  List<Object> get props => [];
}

class EnrollInCourseEvent extends LearningEvent {
  final int courseId;
  const EnrollInCourseEvent({required this.courseId});
  @override
  List<Object> get props => [courseId];
}

class GetCourseLessonsEvent extends LearningEvent {
  final int courseId;
  const GetCourseLessonsEvent({required this.courseId});
  @override
  List<Object> get props => [courseId];
}

class ToggleLessonCompletionEvent extends LearningEvent {
  final int lessonId;

  const ToggleLessonCompletionEvent({required this.lessonId});

  @override
  List<Object> get props => [lessonId];
}
