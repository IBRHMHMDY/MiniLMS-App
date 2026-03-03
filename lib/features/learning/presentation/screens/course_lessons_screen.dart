import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/learning_bloc.dart';
import '../bloc/learning_event.dart';
import '../bloc/learning_state.dart';
import '../widgets/lesson_tile.dart';

class CourseLessonsScreen extends StatefulWidget {
  final int courseId;

  const CourseLessonsScreen({super.key, required this.courseId});

  @override
  State<CourseLessonsScreen> createState() => _CourseLessonsScreenState();
}

class _CourseLessonsScreenState extends State<CourseLessonsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LearningBloc>().add(
      GetCourseLessonsEvent(courseId: widget.courseId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('محتوى الكورس')),
      body: BlocBuilder<LearningBloc, LearningState>(
        builder: (context, state) {
          if (state is LearningLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LearningError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (state is LessonsLoaded) {
            if (state.lessons.isEmpty) {
              return const Center(
                child: Text('لا توجد دروس متاحة في هذا الكورس حالياً.'),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: state.lessons.length,
                    itemBuilder: (context, index) {
                      return LessonTile(lesson: state.lessons[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Builder(
                    builder: (context) {
                      final totalLessons = state.lessons.length;
                      final completedLessons = state.lessons
                          .where((l) => l.isCompleted)
                          .length;
                      final canTakeQuiz =
                          totalLessons > 0 && completedLessons == totalLessons;

                      return Column(
                        children: [
                          Text(
                            'التقدم: $completedLessons / $totalLessons دروس مكتملة',
                            style: TextStyle(
                              color: canTakeQuiz ? Colors.green : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: canTakeQuiz
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade400,
                            ),
                            onPressed: canTakeQuiz
                                ? () => context.push(
                                    '/course/${widget.courseId}/quiz',
                                  )
                                : null, // null تجعل الزر Disabled تلقائياً
                            child: const Text(
                              'بدء الاختبار النهائي',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
