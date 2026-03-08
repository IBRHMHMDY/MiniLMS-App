import 'package:equatable/equatable.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/answer_entity.dart';

class QuestionEntity extends Equatable {
  final int id;
  final String questionText;
  final List<AnswerEntity> answers;

  const QuestionEntity({
    required this.id,
    required this.questionText,
    required this.answers,
  });

  @override
  List<Object?> get props => [id, questionText, answers];
}
