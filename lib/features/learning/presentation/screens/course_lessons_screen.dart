import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.lessons.length,
              itemBuilder: (context, index) {
                return LessonTile(lesson: state.lessons[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
