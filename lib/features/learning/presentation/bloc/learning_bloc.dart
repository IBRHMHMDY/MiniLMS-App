import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/enroll_in_course_usecase.dart';
import '../../domain/usecases/get_course_lessons_usecase.dart';
import '../../domain/usecases/toggle_lesson_completion_usecase.dart';
import 'learning_event.dart';
import 'learning_state.dart';

class LearningBloc extends Bloc<LearningEvent, LearningState> {
  final EnrollInCourseUseCase enrollInCourseUseCase;
  final GetCourseLessonsUseCase getCourseLessonsUseCase;
  final ToggleLessonCompletionUseCase
  toggleLessonCompletionUseCase; // 👈 الـ UseCase الجديد

  LearningBloc({
    required this.enrollInCourseUseCase,
    required this.getCourseLessonsUseCase,
    required this.toggleLessonCompletionUseCase, // 👈 استقباله هنا
  }) : super(LearningInitial()) {
    on<EnrollInCourseEvent>(_onEnrollInCourse);
    on<GetCourseLessonsEvent>(_onGetCourseLessons);
    on<ToggleLessonCompletionEvent>(_onToggleLesson); // 👈 ربط الحدث بالدالة
  }

  Future<void> _onEnrollInCourse(
    EnrollInCourseEvent event,
    Emitter<LearningState> emit,
  ) async {
    emit(LearningLoading());
    final result = await enrollInCourseUseCase(event.courseId);
    result.fold(
      (failure) => emit(LearningError(message: failure.message)),
      (_) =>
          emit(const EnrollmentSuccess(message: 'تم الاشتراك في الكورس بنجاح')),
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

  // 👈 الدالة الكاملة لتغيير حالة الدرس فوراً في الـ UI
  Future<void> _onToggleLesson(
    ToggleLessonCompletionEvent event,
    Emitter<LearningState> emit,
  ) async {
    if (state is LessonsLoaded) {
      final currentState = state as LessonsLoaded;

      // تغيير الحالة محلياً أولاً لتجربة مستخدم سريعة (Optimistic UI Update)
      final updatedLessons = currentState.lessons.map((lesson) {
        if (lesson.id == event.lessonId) {
          return lesson.copyWith(isCompleted: !lesson.isCompleted);
        }
        return lesson;
      }).toList();

      emit(LessonsLoaded(lessons: updatedLessons));

      // إرسال الطلب للسيرفر في الخلفية
      final result = await toggleLessonCompletionUseCase(event.lessonId);

      result.fold(
        (failure) {
          // في حال فشل السيرفر، نعيد الحالة القديمة (Rollback)
          emit(LearningError(message: failure.message));
          emit(currentState);
        },
        (_) {
          // نجح التحديث في السيرفر، لا حاجة لعمل شيء لأننا قمنا بتحديث الـ UI مسبقاً
        },
      );
    }
  }
}
