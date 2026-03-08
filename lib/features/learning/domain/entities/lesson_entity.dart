import 'package:equatable/equatable.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/quiz_entity.dart';

class LessonEntity extends Equatable {
  final int id;
  final String title;
  final String? content;
  final String? videoUrl;
  final int orderNumber;
  final bool isCompleted;
  final List<QuizEntity> quiz; // 👈 أضفنا قائمة اختبار الدرس

  const LessonEntity({
    required this.id,
    required this.title,
    this.content,
    this.videoUrl,
    required this.orderNumber,
    required this.isCompleted,
    this.quiz = const [], // قيمة افتراضية فارغة
  });

  LessonEntity copyWith({
    int? id,
    String? title,
    String? content,
    String? videoUrl,
    int? orderNumber,
    bool? isCompleted,
    List<QuizEntity>? quiz,
  }) {
    return LessonEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      videoUrl: videoUrl ?? this.videoUrl,
      orderNumber: orderNumber ?? this.orderNumber,
      isCompleted: isCompleted ?? this.isCompleted,
      quiz: quiz ?? this.quiz,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    videoUrl,
    orderNumber,
    isCompleted,
    quiz,
  ];
}
