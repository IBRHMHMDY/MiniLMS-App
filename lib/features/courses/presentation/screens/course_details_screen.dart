import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_lms_app/core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../../../learning/presentation/bloc/learning_bloc.dart';
import '../../../learning/presentation/bloc/learning_event.dart';
import '../../../learning/presentation/bloc/learning_state.dart';

class CourseDetailsScreen extends StatefulWidget {
  final int courseId;

  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  
  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(
      GetCourseDetailsEvent(courseId: widget.courseId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الكورس')),
      body: BlocConsumer<LearningBloc, LearningState>(
        listener: (context, learningState) {
          if (learningState is EnrollmentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(learningState.message),
                backgroundColor: Colors.green,
              ),
            );
            // context.push('/course/${widget.courseId}/lessons');
            context.go('/my-courses');
          } else if (learningState is LearningError) {
            if (learningState.message.toLowerCase().contains(
              'already enrolled',
            )) {
              context.push('/course/${widget.courseId}/lessons');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(learningState.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        builder: (context, learningState) {
          return BlocBuilder<CourseBloc, CourseState>(
            builder: (context, courseState) {
              if (courseState is CourseLoading) {
                // Shimmer لتفاصيل الكورس
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerBox(
                        width: double.infinity,
                        height: 200,
                        borderRadius: 0,
                      ),
                      const SizedBox(height: 16),
                      const ShimmerBox(width: 100, height: 20),
                      const SizedBox(height: 8),
                      const ShimmerBox(width: double.infinity, height: 30),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerBox(width: 150, height: 20),
                          ShimmerBox(width: 80, height: 30),
                        ],
                      ),
                      const Divider(height: 32),
                      const ShimmerBox(width: 120, height: 24),
                      const SizedBox(height: 8),
                      const ShimmerBox(width: double.infinity, height: 16),
                      const SizedBox(height: 4),
                      const ShimmerBox(width: double.infinity, height: 16),
                      const SizedBox(height: 4),
                      const ShimmerBox(width: 200, height: 16),
                    ],
                  ),
                );
              } else if (courseState is CourseError) {
                return Center(
                  child: Text(
                    courseState.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (courseState is CourseDetailsLoaded) {
                final course = courseState.course;
                bool isFree = course.isFree;
                String buttonText = course.isFree
                    ? 'اشترك الآن مجاناً'
                    : 'شراء الكورس مقابل \$${course.price}';
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: course.imageUrl != null
                            ? Image.network(course.imageUrl!, fit: BoxFit.cover)
                            : const Icon(
                                Icons.school,
                                size: 80,
                                color: Colors.grey,
                              ),
                      ),
                      const SizedBox(height: 16),
                      if (course.category != null)
                        Text(
                          course.category!.name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        course.title,
                        style: Theme.of(
                          context,
                        ).textTheme.displayLarge?.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                course.instructor?.name ?? 'غير معروف',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          Text(
                            course.isFree ? 'مجانى' : '\$${course.price!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: course.isFree ? AppColors.secondary : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      Text(
                        'عن الكورس',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        course.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        onPressed: () {
                          if (!isFree) {
                            // 👈 المنطق التجاري: إظهار رسالة للكورسات المدفوعة
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Row(
                                  children: [
                                    Icon(Icons.payment, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text('بوابة الدفع'),
                                  ],
                                ),
                                content: const Text(
                                  'سيتم ربط بوابة الدفع قريباً. شكراً لاهتمامك بهذا الكورس المتميز!',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('حسناً'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // 👈 الكورس مجاني: تسجيل فوري
                            context.read<LearningBloc>().add(
                              EnrollInCourseEvent(courseId: course.id),
                            );
                          }
                        },
                        text: buttonText,
                        backgroundColor: isFree ? AppColors.success : AppColors.primary,
                        isLoading: learningState is LearningLoading,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
