import '../../domain/entities/instructor_entity.dart';

class InstructorModel extends InstructorEntity {
  const InstructorModel({required super.id, required super.name});

  factory InstructorModel.fromJson(Map<String, dynamic> json) {
    return InstructorModel(id: json['id'], name: json['name']);
  }
}
