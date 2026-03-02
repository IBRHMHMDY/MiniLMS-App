import 'package:flutter/material.dart';
import '../../domain/entities/lesson_entity.dart';

class LessonTile extends StatelessWidget {
  final LessonEntity lesson;

  const LessonTile({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.1),
          child: Text(
            lesson.orderNumber.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          lesson.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (lesson.videoUrl != null && lesson.videoUrl!.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.play_circle_fill,
                        color: Colors.red,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'رابط الفيديو: ${lesson.videoUrl}',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                if (lesson.content != null && lesson.content!.isNotEmpty) ...[
                  const Text(
                    'محتوى الدرس:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lesson.content!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ] else ...[
                  const Text('لا يوجد محتوى نصي لهذا الدرس.'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
