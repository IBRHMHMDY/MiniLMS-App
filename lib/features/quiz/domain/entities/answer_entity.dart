import 'package:equatable/equatable.dart';

class AnswerEntity extends Equatable {
  final int id;
  final String text;

  const AnswerEntity({required this.id, required this.text});

  @override
  List<Object?> get props => [id, text];
}
