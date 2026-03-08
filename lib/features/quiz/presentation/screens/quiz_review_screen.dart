import 'package:flutter/material.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/entities/quiz_result_entity.dart';
import '../../domain/entities/review_detail_entity.dart';

class QuizReviewScreen extends StatelessWidget {
  final QuizEntity quiz;
  final QuizResultEntity result;

  const QuizReviewScreen({super.key, required this.quiz, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مراجعة الإجابات'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: result.details.length,
        itemBuilder: (context, index) {
          final ReviewDetailEntity detail = result.details[index];

          // 👈 التعديل المعماري الآمن (Safe Iterable Parsing)
          final matchedQuestions = quiz.questions.where(
            (q) => q.id == detail.questionId,
          );
          final question = matchedQuestions.isNotEmpty
              ? matchedQuestions.first
              : quiz.questions.first; // Fallback آمن بدون أخطاء Casting

          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        detail.isCorrect ? Icons.check_circle : Icons.cancel,
                        color: detail.isCorrect ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'سؤال ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question.questionText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...question.answers.map(
                    (answer) {
                      final isSelected = answer.id == detail.selectedAnswerId;
                      final isCorrect = answer.id == detail.correctAnswerId;

                      Color tileColor = Colors.transparent;
                      Color borderColor = Colors.grey.shade300;
                      IconData? icon;
                      Color? iconColor;

                      if (isCorrect) {
                        tileColor = Colors.green.withOpacity(0.1);
                        borderColor = Colors.green;
                        icon = Icons.check_circle;
                        iconColor = Colors.green;
                      } else if (isSelected && !isCorrect) {
                        tileColor = Colors.red.withOpacity(0.1);
                        borderColor = Colors.red;
                        icon = Icons.cancel;
                        iconColor = Colors.red;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: tileColor,
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            if (icon != null)
                              Icon(icon, color: iconColor, size: 20)
                            else
                              const SizedBox(width: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                answer.text,
                                style: TextStyle(
                                  fontWeight: (isSelected || isCorrect)
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ), // 👈 تم التعديل هنا لعدم استخدام .toList() حيث وفرنا استخدام Spread Operator (...)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
