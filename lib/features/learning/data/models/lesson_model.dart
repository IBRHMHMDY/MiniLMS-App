import 'package:mini_lms_app/features/quiz/domain/entities/quiz_entity.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../../quiz/data/models/quiz_model.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    required super.title,
    super.content,
    super.videoUrl,
    required super.orderNumber,
    required super.isCompleted,
    super.quiz,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? 'بدون عنوان',
      content: json['content']?.toString(),
      videoUrl: json['video_url']?.toString(),
      orderNumber: json['order_number'] != null
          ? int.tryParse(json['order_number'].toString()) ?? 0
          : 0,
      isCompleted:
          json['is_completed'] == true ||
          json['is_completed'] == 1 ||
          json['is_completed'] == '1',
      // 🚀 درع الحماية العميق لمنع تسلل الـ int أو الـ null
      quiz: json['quiz'] is List
          ? (json['quiz'] as List)
                .whereType<Map<String, dynamic>>() // السماح بمرور الكائنات فقط
                .map<QuizEntity>((i) => QuizModel.fromJson(i))
                .toList()
          : <QuizEntity>[],
    );
  }
}
