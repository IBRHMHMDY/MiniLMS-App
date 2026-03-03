import '../../domain/entities/quiz_entities.dart';

class AnswerModel extends AnswerEntity {
  const AnswerModel({required super.id, required super.text});

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      // استخدام التحويل الآمن (Safe Parsing) لتجنب انهيار التطبيق
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      text: json['answer_text']?.toString() ?? 'إجابة غير معروفة',
    );
  }
}

class QuestionModel extends QuestionEntity {
  const QuestionModel({
    required super.id,
    required super.text,
    required super.answers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      text: json['question_text']?.toString() ?? 'سؤال غير معروف',
      // التأكد من أن الإجابات ليست null قبل عمل Map
      answers: json['answers'] != null
          ? (json['answers'] as List)
                .map((a) => AnswerModel.fromJson(a))
                .toList()
          : [],
    );
  }
}

class QuizModel extends QuizEntity {
  const QuizModel({
    required super.id,
    required super.title,
    required super.passMark,
    required super.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? 'اختبار بدون عنوان',
      // تحويل درجة النجاح بأمان سواء جاءت كنص أو رقم
      passMark: json['pass_mark'] is int
          ? json['pass_mark']
          : int.tryParse(json['pass_mark'].toString()) ?? 50,
      // التأكد من أن الأسئلة ليست null
      questions: json['questions'] != null
          ? (json['questions'] as List)
                .map((q) => QuestionModel.fromJson(q))
                .toList()
          : [],
    );
  }
}

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
