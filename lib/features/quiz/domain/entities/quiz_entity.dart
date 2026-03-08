import 'package:equatable/equatable.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/question_entity.dart';

class QuizEntity extends Equatable {
  final int id;
  final String title;
  final int passMark;
  final List<QuestionEntity> questions;

  const QuizEntity({
    required this.id,
    required this.title,
    required this.passMark,
    required this.questions,
  });

  @override
  List<Object?> get props => [id, title, passMark, questions];
}

// كيان نتيجة الاختبار (ما يرجع من السيرفر بعد التصحيح)
