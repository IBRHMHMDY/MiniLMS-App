import 'package:equatable/equatable.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/review_detail_entity.dart';

class QuizResultEntity extends Equatable {
  final num score;
  final bool passed;
  final String message;
  final int correctAnswers;
  final int totalQuestions;
  final List<ReviewDetailEntity> details;

  const QuizResultEntity({
    required this.score,
    required this.passed,
    required this.message,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.details
  });

  @override
  List<Object?> get props => [
    score,
    passed,
    message,
    correctAnswers,
    totalQuestions,
    details
  ];
}
