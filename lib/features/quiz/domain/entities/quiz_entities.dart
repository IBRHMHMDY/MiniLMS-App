import 'package:equatable/equatable.dart';

// كيان الإجابة (لاحظ عدم وجود isCorrect)
class AnswerEntity extends Equatable {
  final int id;
  final String text;

  const AnswerEntity({required this.id, required this.text});

  @override
  List<Object?> get props => [id, text];
}

// كيان السؤال
class QuestionEntity extends Equatable {
  final int id;
  final String text;
  final List<AnswerEntity> answers;

  const QuestionEntity({
    required this.id,
    required this.text,
    required this.answers,
  });

  @override
  List<Object?> get props => [id, text, answers];
}

// كيان الاختبار
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
