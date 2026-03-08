import 'package:equatable/equatable.dart';

class ReviewDetailEntity extends Equatable {
  final int questionId;
  final int? selectedAnswerId;
  final int? correctAnswerId;
  final bool isCorrect;

  const ReviewDetailEntity({
    required this.questionId,
    required this.selectedAnswerId,
    required this.correctAnswerId,
    required this.isCorrect,
  });

  @override
  List<Object?> get props => [
    questionId,
    selectedAnswerId,
    correctAnswerId,
    isCorrect,
  ];
}
