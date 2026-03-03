import 'package:equatable/equatable.dart';

class LessonEntity extends Equatable {
  final int id;
  final String title;
  final String? content;
  final String? videoUrl;
  final int orderNumber;
  final bool isCompleted;

  const LessonEntity({
    required this.id,
    required this.title,
    this.content,
    this.videoUrl,
    required this.orderNumber,
    required this.isCompleted
  });

LessonEntity copyWith({
    int? id,
    int? courseId,
    String? title,
    String? content,
    String? videoUrl,
    int? orderNumber,
    bool? isCompleted,
  }) {
    return LessonEntity(
      id: id ?? this.id,
      // courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      content: content ?? this.content,
      videoUrl: videoUrl ?? this.videoUrl,
      orderNumber: orderNumber ?? this.orderNumber,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
  @override
  List<Object?> get props => [id, title, content, videoUrl, orderNumber, isCompleted];
}
