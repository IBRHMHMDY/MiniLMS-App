import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/enroll_in_course_usecase.dart';
import '../../domain/usecases/get_course_lessons_usecase.dart';
import 'learning_event.dart';
import 'learning_state.dart';

class LearningBloc extends Bloc<LearningEvent, LearningState> {
  final EnrollInCourseUseCase enrollInCourseUseCase;
  final GetCourseLessonsUseCase getCourseLessonsUseCase;

  LearningBloc({
    required this.enrollInCourseUseCase,
    required this.getCourseLessonsUseCase,
  }) : super(LearningInitial()) {
    on<EnrollInCourseEvent>(_onEnrollInCourse);
    on<GetCourseLessonsEvent>(_onGetCourseLessons);
  }

  Future<void> _onEnrollInCourse(
    EnrollInCourseEvent event,
    Emitter<LearningState> emit,
  ) async {
    emit(LearningLoading());
    final result = await enrollInCourseUseCase(event.courseId);
    result.fold(
      (failure) => emit(LearningError(message: failure.message)),
      (_) => emit(
        const EnrollmentSuccess(message: 'تم الاشتراك في الكورس بنجاح!'),
      ),
    );
  }

  Future<void> _onGetCourseLessons(
    GetCourseLessonsEvent event,
    Emitter<LearningState> emit,
  ) async {
    emit(LearningLoading());
    final result = await getCourseLessonsUseCase(event.courseId);
    result.fold(
      (failure) => emit(LearningError(message: failure.message)),
      (lessons) => emit(LessonsLoaded(lessons: lessons)),
    );
  }
}
