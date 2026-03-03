import 'package:equatable/equatable.dart';
import '../../domain/entities/quiz_entities.dart';

abstract class QuizState extends Equatable {
  const QuizState();
  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final QuizEntity quiz;
  final Map<int, int>
  selectedAnswers; // قاموس يربط معرف السؤال بمعرف الإجابة المختارة

  const QuizLoaded({required this.quiz, this.selectedAnswers = const {}});

  QuizLoaded copyWith({QuizEntity? quiz, Map<int, int>? selectedAnswers}) {
    return QuizLoaded(
      quiz: quiz ?? this.quiz,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
    );
  }

  @override
  List<Object?> get props => [quiz, selectedAnswers];
}

class QuizSubmitting extends QuizState {}

class QuizResultSuccess extends QuizState {
  final QuizResultEntity result;
  const QuizResultSuccess({required this.result});
  @override
  List<Object> get props => [result];
}

class QuizError extends QuizState {
  final String message;
  const QuizError({required this.message});
  @override
  List<Object> get props => [message];
}
