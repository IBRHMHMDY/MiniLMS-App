import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_course_quiz_usecase.dart';
import '../../domain/usecases/submit_quiz_usecase.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetCourseQuizUseCase getCourseQuizUseCase;
  final SubmitQuizUseCase submitQuizUseCase;

  QuizBloc({
    required this.getCourseQuizUseCase,
    required this.submitQuizUseCase,
  }) : super(QuizInitial()) {
    on<GetCourseQuizEvent>(_onGetCourseQuiz);
    on<InitializeLessonQuizEvent>(_onInitializeLessonQuiz); // 👈 تسجيل المستمع
    on<SelectAnswerEvent>(_onSelectAnswer);
    on<SubmitQuizEvent>(_onSubmitQuiz);
  }

  Future<void> _onGetCourseQuiz(
    GetCourseQuizEvent event,
    Emitter<QuizState> emit,
  ) async {
    emit(QuizLoading());
    final result = await getCourseQuizUseCase(event.courseId);
    result.fold(
      (failure) => emit(QuizError(message: failure.message)),
      (quiz) => emit(QuizLoaded(quiz: quiz, selectedAnswers: const {})),
    );
  }

  // 👈 دالة التهيئة للاختبار الموجود مسبقاً
  void _onInitializeLessonQuiz(
    InitializeLessonQuizEvent event,
    Emitter<QuizState> emit,
  ) {
    emit(QuizLoaded(quiz: event.quiz, selectedAnswers: const {}));
  }

  void _onSelectAnswer(SelectAnswerEvent event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      final updatedAnswers = Map<int, int>.from(currentState.selectedAnswers);
      updatedAnswers[event.questionId] = event.answerId;
      emit(currentState.copyWith(selectedAnswers: updatedAnswers));
    }
  }

  Future<void> _onSubmitQuiz(
    SubmitQuizEvent event,
    Emitter<QuizState> emit,
  ) async {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;

      final List<Map<String, int>> formattedAnswers = currentState
          .selectedAnswers
          .entries
          .map((entry) => {'question_id': entry.key, 'answer_id': entry.value})
          .toList();

      if (formattedAnswers.isEmpty) {
        emit(const QuizError(message: 'يجب الإجابة على سؤال واحد على الأقل.'));
        emit(currentState);
        return;
      }

      emit(QuizSubmitting());
      final result = await submitQuizUseCase(event.courseId, formattedAnswers);
      result.fold((failure) {
        emit(QuizError(message: failure.message));
        emit(currentState);
      }, (quizResult) => emit(QuizResultSuccess(result: quizResult)));
    }
  }
}
