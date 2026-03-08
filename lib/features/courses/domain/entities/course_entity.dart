import 'package:equatable/equatable.dart';
import 'package:mini_lms_app/features/learning/domain/entities/lesson_entity.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/quiz_entity.dart';
import 'category_entity.dart';
import 'instructor_entity.dart';

class CourseEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final double? price;
  final String? imageUrl;
  final bool isFree;
  final InstructorEntity? instructor;
  final CategoryEntity? category;
  final List<LessonEntity> lessons; // 👈 أضفنا الدروس
  final List<QuizEntity> finalQuiz; // 👈 أضفنا الاختبار النهائي
  
  const CourseEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl,
    this.instructor,
    this.category, this.isFree = true, required this.lessons, required this.finalQuiz,
    
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
    isFree,
    lessons,
    finalQuiz
  ];
}
