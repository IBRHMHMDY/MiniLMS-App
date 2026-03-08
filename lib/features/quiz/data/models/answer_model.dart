import '../../domain/entities/answer_entity.dart';

class AnswerModel extends AnswerEntity {
  const AnswerModel({required super.id, required super.text});

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      text: json['answer_text']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'answer_text': text};
  }
}
