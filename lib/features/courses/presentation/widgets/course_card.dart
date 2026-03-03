import 'package:flutter/material.dart';
import 'package:mini_lms_app/core/theme/app_colors.dart';
import '../../domain/entities/course_entity.dart';

class CourseCard extends StatelessWidget {
  final CourseEntity course;
  final VoidCallback onTap;

  const CourseCard({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الكورس (أو خلفية افتراضية)
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: course.imageUrl != null
                  ? Image.network(
                      course.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(Icons.school, size: 50, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (course.category != null)
                    Text(
                      course.category!.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    course.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            course.instructor?.name ?? 'مدرب غير معروف',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Text(
                        course.isFree
                            ? 'مجانى'
                            : '\$${course.price!.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: course.isFree
                              ? AppColors.secondary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
