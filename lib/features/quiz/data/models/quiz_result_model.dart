import 'package:mini_lms_app/features/quiz/domain/entities/quiz_result_entity.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/review_detail_entity.dart';

class QuizResultModel extends QuizResultEntity {
  const QuizResultModel({
    required super.score,
    required super.passed,
    required super.message,
    required super.correctAnswers,
    required super.totalQuestions,
    required super.details
  });

factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    // Parsing مصفوفة التفاصيل بأمان
    var detailsList = json['details'] as List?;
    List<ReviewDetailEntity> parsedDetails = [];
    if (detailsList != null) {
      parsedDetails = detailsList
          .map<ReviewDetailEntity>(
            (i) => ReviewDetailEntity(
              questionId: i['question_id'] ?? 0,
              selectedAnswerId: i['selected_answer_id'],
              correctAnswerId: i['correct_answer_id'],
              isCorrect: i['is_correct'] ?? false,
            ),
          )
          .toList();
    }

    return QuizResultModel(
      score: (json['score'] ?? 0).toDouble(),
      passed: json['passed'] ?? false,
      correctAnswers: json['correct_answers'] ?? 0,
      totalQuestions: json['total_questions'] ?? 0,
      message: json['message'] ?? '',
      details: parsedDetails, // 👈 تمرير التفاصيل
    );
  }
}
