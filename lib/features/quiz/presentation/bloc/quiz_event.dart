import 'package:equatable/equatable.dart';
import '../../domain/entities/quiz_entity.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class GetCourseQuizEvent extends QuizEvent {
  final int courseId;
  const GetCourseQuizEvent({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

// 👈 إضافة مهمة معمارياً: لتهيئة الاختبار المحمل مسبقاً (اختبار الدرس)
class InitializeLessonQuizEvent extends QuizEvent {
  final QuizEntity quiz;
  const InitializeLessonQuizEvent({required this.quiz});

  @override
  List<Object?> get props => [quiz];
}

class SelectAnswerEvent extends QuizEvent {
  final int questionId;
  final int answerId;

  const SelectAnswerEvent({required this.questionId, required this.answerId});

  @override
  List<Object?> get props => [questionId, answerId];
}

class SubmitQuizEvent extends QuizEvent {
  final int courseId;
  const SubmitQuizEvent({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}
