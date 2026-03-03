import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';

class QuizScreen extends StatefulWidget {
  final int courseId;

  const QuizScreen({super.key, required this.courseId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(GetCourseQuizEvent(courseId: widget.courseId));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الاختبار النهائي')),
      body: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state is QuizResultSuccess) {
            context.pushReplacement('/course/${widget.courseId}/quiz/result', extra: state.result);
          }
        },
        builder: (context, state) {
          // 1. حالة التهيئة
          if (state is QuizInitial) {
            return const Center(child: Text('جاري تهيئة الاختبار...', style: TextStyle(fontSize: 18)));
          } 
          // 2. حالة التحميل
          else if (state is QuizLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جاري جلب الأسئلة من السيرفر...'),
                ],
              ),
            );
          } 
          // 3. حالة الخطأ (هنا سيظهر الخطأ إذا حدثت مشكلة في السيرفر أو الـ JSON)
          else if (state is QuizError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.orange),
                    const SizedBox(height: 16),
                    Text(
                      state.message, 
                      textAlign: TextAlign.center, 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('العودة للدروس'),
                    ),
                  ],
                ),
              ),
            );
          } 
          // 4. حالة نجاح جلب البيانات
          else if (state is QuizLoaded) {
            final quiz = state.quiz;
            final questions = quiz.questions;
            
            if (questions.isEmpty) {
               return const Center(child: Text('لا توجد أسئلة مضافة في هذا الاختبار بعد.'));
            }

            return Column(
              children: [
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / questions.length,
                  backgroundColor: Colors.grey.shade300,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('السؤال ${_currentIndex + 1} من ${questions.length}', 
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(question.text, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 24),
                            ...question.answers.map((answer) {
                              final isSelected = state.selectedAnswers[question.id] == answer.id;
                              return Card(
                                color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300),
                                ),
                                child: RadioListTile<int>(
                                  title: Text(answer.text),
                                  value: answer.id,
                                  groupValue: state.selectedAnswers[question.id],
                                  activeColor: Theme.of(context).colorScheme.primary,
                                  onChanged: (value) {
                                    if (value != null) {
                                      context.read<QuizBloc>().add(SelectAnswerEvent(questionId: question.id, answerId: value));
                                    }
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentIndex > 0)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // 👈 السر هنا: تحجيم العرض لإلغاء الـ Infinity الموروثة
                            minimumSize: const Size(100, 45),
                          ),
                          onPressed: () {
                            setState(() => _currentIndex--);
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text('السابق'),
                        )
                      else
                        const SizedBox.shrink(),

                      if (_currentIndex < questions.length - 1)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // 👈 تحجيم العرض هنا أيضاً
                            minimumSize: const Size(100, 45),
                          ),
                          onPressed: () {
                            setState(() => _currentIndex++);
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text('التالي'),
                        )
                      else
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            // 👈 تحجيم العرض لزر الإنهاء لإنقاذ الـ Row من الانهيار
                            minimumSize: const Size(120, 45),
                          ),
                          onPressed: () {
                            context.read<QuizBloc>().add(
                              SubmitQuizEvent(courseId: widget.courseId),
                            );
                          },
                          child: state is QuizSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'إنهاء الاختبار',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          }
          else if (state is QuizSubmitting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'جاري إرسال الإجابات وحساب النتيجة...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            );
          }
          
          // 5. الحالة الافتراضية (Ultimate Fallback) تكشف لنا المشكلة إذا كانت الـ State مفقودة
          return Center(
            child: Text(
              'حالة غير معروفة: ${state.runtimeType}\nالرجاء فحص الـ Terminal.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
