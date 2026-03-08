import '../../domain/entities/question_entity.dart';
import 'answer_model.dart';

class QuestionModel extends QuestionEntity {
  const QuestionModel({
    required super.id,
    required super.questionText,
    required super.answers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      questionText: json['question_text']?.toString() ?? '',
      // 🚀 الحماية من أي بيانات تالفة داخل قائمة الإجابات
      answers: json['answers'] is List
          ? (json['answers'] as List)
                .whereType<Map<String, dynamic>>()
                .map<AnswerModel>((i) => AnswerModel.fromJson(i))
                .toList()
          : <AnswerModel>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'answers': (answers as List<AnswerModel>).map((v) => v.toJson()).toList(),
    };
  }
}
