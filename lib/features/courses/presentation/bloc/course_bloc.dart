import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_lms_app/features/courses/domain/usecases/get_my_courses_usecase.dart';
import '../../domain/usecases/get_courses_usecase.dart';
import '../../domain/usecases/get_course_details_usecase.dart';
import 'course_event.dart';
import 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCoursesUseCase getCoursesUseCase;
  final GetCourseDetailsUseCase getCourseDetailsUseCase;
  final GetMyCoursesUseCase getMyCoursesUseCase;

  CourseBloc({
    required this.getCoursesUseCase,
    required this.getCourseDetailsUseCase, 
    required this.getMyCoursesUseCase,
  }) : super(CourseInitial()) {
    on<GetCoursesEvent>(_onGetCourses);
    on<GetCourseDetailsEvent>(_onGetCourseDetails);
    on<GetMyCoursesEvent>(_onGetMyCourses);
  }

  Future<void> _onGetCourses(
    GetCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    final result = await getCoursesUseCase();
    result.fold(
      (failure) => emit(CourseError(message: failure.message)),
      (courses) => emit(CoursesLoaded(courses: courses)),
    );
  }

  Future<void> _onGetCourseDetails(
    GetCourseDetailsEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    final result = await getCourseDetailsUseCase(event.courseId);
    result.fold(
      (failure) => emit(CourseError(message: failure.message)),
      (course) => emit(CourseDetailsLoaded(course: course)),
    );
  }

  Future<void> _onGetMyCourses(
    GetMyCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    final result = await getMyCoursesUseCase();
    result.fold(
      (failure) => emit(CourseError(message: failure.message)),
      (courses) => emit(CoursesLoaded(courses: courses)),
    );
  }
}
