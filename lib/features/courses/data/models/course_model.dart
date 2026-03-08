import 'package:mini_lms_app/features/learning/data/models/lesson_model.dart';
import 'package:mini_lms_app/features/learning/domain/entities/lesson_entity.dart';
import 'package:mini_lms_app/features/quiz/data/models/quiz_model.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/quiz_entity.dart';

import '../../domain/entities/course_entity.dart';
import 'category_model.dart';
import 'instructor_model.dart';

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    super.imageUrl,
    super.instructor,
    super.category,
    super.isFree,
    required super.lessons,
    required super.finalQuiz,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? 'بدون عنوان',
      description: json['description']?.toString() ?? '',
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      imageUrl: json['image_url']?.toString(),

      // 🛡️ درع الحماية الأقوى: نتحقق أن ما رجع هو كائن (Map) وليس رقماً (int)
      instructor: json['instructor'] is Map<String, dynamic>
          ? InstructorModel.fromJson(json['instructor'])
          : null,

      // 🛡️ درع حماية القسم
      category: json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(json['category'])
          : null,

      isFree: json['is_free'] != null
          ? (json['is_free'] == true ||
                json['is_free'] == 1 ||
                json['is_free'] == '1')
          : true,

      // 🛡️ حماية مصفوفة الدروس: نستخرج الكائنات فقط
      lessons: json['lessons'] is List
          ? (json['lessons'] as List)
                .whereType<Map<String, dynamic>>()
                .map<LessonEntity>(
                  (i) => LessonModel.fromJson(i),
                )
                .toList()
          : <LessonEntity>[],

      // 🛡️ حماية مصفوفة الاختبارات
      finalQuiz: json['final_quiz'] is List
          ? (json['final_quiz'] as List)
                .whereType<Map<String, dynamic>>()
                .map<QuizEntity>(
                  (i) => QuizModel.fromJson(i),
                )
                .toList()
          : <QuizEntity>[],
    );
  }
}
