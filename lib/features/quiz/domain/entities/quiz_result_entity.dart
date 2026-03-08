import 'package:equatable/equatable.dart';

class QuizResultEntity extends Equatable {
  final num score;
  final bool passed;
  final String message;
  final int correctAnswers;
  final int totalQuestions;

  const QuizResultEntity({
    required this.score,
    required this.passed,
    required this.message,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  @override
  List<Object?> get props => [
    score,
    passed,
    message,
    correctAnswers,
    totalQuestions,
  ];
}
