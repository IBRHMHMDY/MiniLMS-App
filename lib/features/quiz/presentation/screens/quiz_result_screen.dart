import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/quiz_result_entity.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizResultEntity result;

  const QuizResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isPassed = result.passed;
    final color = isPassed ? Colors.green : Colors.red;
    final icon = isPassed ? Icons.emoji_events : Icons.cancel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('نتيجة الاختبار'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 100, color: color),
              const SizedBox(height: 24),
              Text(
                '${result.score}%',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                result.message,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'الإجابات الصحيحة: ${result.correctAnswers} من أصل ${result.totalQuestions}',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('العودة للصفحة الرئيسية'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
