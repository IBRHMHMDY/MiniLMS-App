import 'package:equatable/equatable.dart';
import 'category_entity.dart';
import 'instructor_entity.dart';

class CourseEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final double price;
  final String? imageUrl;
  final InstructorEntity? instructor;
  final CategoryEntity? category;

  const CourseEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl,
    this.instructor,
    this.category,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    imageUrl,
    instructor,
    category,
  ];
}
