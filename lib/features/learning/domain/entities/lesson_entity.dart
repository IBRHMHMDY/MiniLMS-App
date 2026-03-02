import 'package:equatable/equatable.dart';

class LessonEntity extends Equatable {
  final int id;
  final String title;
  final String? content;
  final String? videoUrl;
  final int orderNumber;

  const LessonEntity({
    required this.id,
    required this.title,
    this.content,
    this.videoUrl,
    required this.orderNumber,
  });

  @override
  List<Object?> get props => [id, title, content, videoUrl, orderNumber];
}
