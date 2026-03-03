import '../../domain/entities/lesson_entity.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    required super.title,
    super.content,
    super.videoUrl,
    required super.orderNumber,
    required super.isCompleted
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      videoUrl: json['video_url'],
      orderNumber: json['order_number'] ?? 0,
      isCompleted: json['is_completed'] == true || json['is_completed'] == 1,
    );
  }
}

