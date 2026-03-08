import 'package:mini_lms_app/features/quiz/domain/entities/quiz_result_entity.dart';

class QuizResultModel extends QuizResultEntity {
  const QuizResultModel({
    required super.score,
    required super.passed,
    required super.message,
    required super.correctAnswers,
    required super.totalQuestions,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      score: json['score'] ?? 0,
      passed:
          json['passed'] == true ||
          json['passed'] == 1 ||
          json['passed'] == '1',
      message: json['message']?.toString() ?? '',
      correctAnswers: json['correct_answers'] is int
          ? json['correct_answers']
          : int.tryParse(json['correct_answers'].toString()) ?? 0,
      totalQuestions: json['total_questions'] is int
          ? json['total_questions']
          : int.tryParse(json['total_questions'].toString()) ?? 0,
    );
  }
}
