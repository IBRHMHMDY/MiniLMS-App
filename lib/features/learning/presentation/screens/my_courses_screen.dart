import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_lms_app/features/courses/presentation/bloc/course_bloc.dart';
import 'package:mini_lms_app/features/courses/presentation/bloc/course_event.dart';
import 'package:mini_lms_app/features/courses/presentation/bloc/course_state.dart';


class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  @override
  void initState() {
    super.initState();
    // جلب دوراتي عند فتح الشاشة
    context.read<CourseBloc>().add(GetMyCoursesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دوراتي'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CourseError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is CoursesLoaded) {
            if (state.courses.isEmpty) {
              return const Center(
                child: Text(
                  'لم تشترك في أي كورس بعد.\nاذهب لاستكشاف الكورسات!',
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.courses.length,
              itemBuilder: (context, index) {
                final course = state.courses[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const Icon(
                      Icons.play_circle_fill,
                      size: 40,
                      color: Colors.blue,
                    ),
                    title: Text(
                      course.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('اضغط لمتابعة التعلم'),
                    onTap: () {
                      // التوجه مباشرة لشاشة الدروس لأن الطالب مشترك بالفعل
                      context.push('/course/${course.id}/lessons');
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
