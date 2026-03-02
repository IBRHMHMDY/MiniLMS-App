import 'package:equatable/equatable.dart';

class InstructorEntity extends Equatable {
  final int id;
  final String name;

  const InstructorEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
