import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/answer_entity.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/question_entity.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/quiz_entity.dart';
import 'package:mini_lms_app/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:mini_lms_app/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:mini_lms_app/features/quiz/presentation/bloc/quiz_state.dart';


class QuizScreen extends StatefulWidget {
  final QuizEntity? quiz;
  final int courseId;
  const QuizScreen({super.key, this.quiz, required this.courseId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  QuizEntity? _fetchedQuiz;

  @override
  void initState() {
    super.initState();
    // التهيئة الذكية: من السيرفر إذا كان الاختبار نهائياً، ومن الدرس إذا كان ممرراً
    if (widget.quiz != null) {
      context.read<QuizBloc>().add(
        InitializeLessonQuizEvent(quiz: widget.quiz!),
      );
    } else {
      context.read<QuizBloc>().add(
        GetCourseQuizEvent(courseId: widget.courseId),
      );
    }
  }

  void _nextQuestion(int totalQuestions) {
    if (_currentQuestionIndex < totalQuestions - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _confirmSubmit() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الإرسال'),
        content: const Text(
          'هل أنت متأكد أنك تريد إنهاء الاختبار وإرسال إجاباتك للتقييم؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('مراجعة إجاباتي'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext); // إغلاق الديالوج
              // 👈 إرسال الحدث الحقيقي للـ API عبر الـ Bloc
              context.read<QuizBloc>().add(
                SubmitQuizEvent(courseId: widget.courseId),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('إرسال النتيجة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // استخدمنا BlocConsumer لنتمكن من الانتقال لشاشة النتيجة عند النجاح
    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state is QuizError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is QuizResultSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تسجيل إجاباتك بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );

          // 👈 التعديل الذكي: نستخدم الاختبار الممرر أو الذي حفظناه في الشاشة
          final currentQuiz = widget.quiz ?? _fetchedQuiz!;

          context.pushReplacement(
            '/course/${widget.courseId}/quiz/result',
            extra: {'result': state.result, 'quiz': currentQuiz},
          );
        }
      },
      builder: (context, state) {
        // عرض دائرة التحميل أثناء جلب الأسئلة أو أثناء إرسال الإجابات
        if (state is QuizLoading || state is QuizSubmitting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'جاري معالجة البيانات...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is QuizLoaded) {
          _fetchedQuiz = state.quiz; // 👈 حفظ الاختبار هنا بمجرد تحميله!

          final QuizEntity activeQuiz = state.quiz;
          final Map<int, int> selectedAnswers = state.selectedAnswers;

          if (activeQuiz.questions.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: Text(activeQuiz.title)),
              body: const Center(
                child: Text(
                  'عذراً، لا توجد أسئلة في هذا الاختبار حالياً.',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            );
          }

          final QuestionEntity currentQuestion =
              activeQuiz.questions[_currentQuestionIndex];
          final bool isLastQuestion =
              _currentQuestionIndex == activeQuiz.questions.length - 1;
          final bool isFirstQuestion = _currentQuestionIndex == 0;
          final bool hasAnsweredCurrent = selectedAnswers.containsKey(
            currentQuestion.id,
          );

          return Scaffold(
            appBar: AppBar(
              title: Text(activeQuiz.title),
              centerTitle: true,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value:
                        (_currentQuestionIndex + 1) /
                        activeQuiz.questions.length,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                    minHeight: 8.0,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'سؤال ${_currentQuestionIndex + 1} من ${activeQuiz.questions.length}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    currentQuestion.questionText,
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentQuestion.answers.length,
                      itemBuilder: (context, index) {
                        final AnswerEntity answer =
                            currentQuestion.answers[index];
                        final bool isSelected =
                            selectedAnswers[currentQuestion.id] == answer.id;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: InkWell(
                            // 👈 تحديث الإجابة عبر الـ Bloc
                            onTap: () => context.read<QuizBloc>().add(
                              SelectAnswerEvent(
                                questionId: currentQuestion.id,
                                answerId: answer.id,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.shade300,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                                color: isSelected
                                    ? Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.05)
                                    : Colors.transparent,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 16.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 12.0),
                                  Expanded(
                                    child: Text(
                                      answer.text,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: isSelected
                                            ? Theme.of(context).primaryColor
                                            : Colors.black87,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!isFirstQuestion)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousQuestion,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'السابق',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        )
                      else
                        const Spacer(),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: hasAnsweredCurrent
                              ? (isLastQuestion
                                    ? _confirmSubmit
                                    : () => _nextQuestion(
                                        activeQuiz.questions.length,
                                      ))
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor: isLastQuestion
                                ? Colors.green
                                : Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            isLastQuestion ? 'إنهاء الاختبار' : 'التالي',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(child: Text('حدث خطأ أثناء تحميل الاختبار.')),
        );
      },
    );
  }
}
