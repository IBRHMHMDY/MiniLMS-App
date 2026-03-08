import '../../domain/entities/quiz_entity.dart';
import 'question_model.dart';

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
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      passMark: json['pass_mark'] != null
          ? int.tryParse(json['pass_mark'].toString()) ?? 50
          : 50,
      // 🚀 الحماية من أي بيانات تالفة داخل قائمة الأسئلة
      questions: json['questions'] is List
          ? (json['questions'] as List)
                .whereType<Map<String, dynamic>>()
                .map<QuestionModel>((i) => QuestionModel.fromJson(i))
                .toList()
          : <QuestionModel>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'pass_mark': passMark,
      'questions': (questions as List<QuestionModel>)
          .map((v) => v.toJson())
          .toList(),
    };
  }
}
