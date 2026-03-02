import 'package:equatable/equatable.dart';
import '../../domain/entities/lesson_entity.dart';

abstract class LearningState extends Equatable {
  const LearningState();
  @override
  List<Object?> get props => [];
}

class LearningInitial extends LearningState {}

class LearningLoading extends LearningState {}

class EnrollmentSuccess extends LearningState {
  final String message;
  const EnrollmentSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class LessonsLoaded extends LearningState {
  final List<LessonEntity> lessons;
  const LessonsLoaded({required this.lessons});
  @override
  List<Object> get props => [lessons];
}

class LearningError extends LearningState {
  final String message;
  const LearningError({required this.message});
  @override
  List<Object> get props => [message];
}
