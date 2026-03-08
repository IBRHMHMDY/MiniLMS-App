import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_lms_app/features/quiz/domain/entities/quiz_entity.dart';
import '../../domain/entities/quiz_result_entity.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizResultEntity result;
  final QuizEntity? quiz;
  
  const QuizResultScreen({super.key, required this.result, required this.quiz});

  @override
  Widget build(BuildContext context) {
    final isPassed = result.passed;
    final color = isPassed ? Colors.green : Colors.red;
    final icon = isPassed ? Icons.emoji_events : Icons.cancel;
    final wrongAnswers = result.totalQuestions - result.correctAnswers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('نتيجة الاختبار'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الأيقونة الدائرية للنتيجة
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 80, color: color),
              ),
              const SizedBox(height: 24),

              // النسبة المئوية
              Text(
                '${result.score}%',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 16),

              // رسالة التهنئة أو الحظ الأوفر
              Text(
                result.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // إحصائيات الإجابات (صحيح، خاطئ، المجموع)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn(
                      'الأسئلة',
                      '${result.totalQuestions}',
                      Colors.blue.shade700,
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    _buildStatColumn(
                      'صحيحة',
                      '${result.correctAnswers}',
                      Colors.green,
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    _buildStatColumn('خاطئة', '$wrongAnswers', Colors.red),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // زر مراجعة الإجابات
              OutlinedButton.icon(
                onPressed: () {
                 
                  context.push(
                    '/course/1/quiz/review',
                    extra: {'result': result, 'quiz': quiz},
                  );
                },
                icon: const Icon(Icons.rule),
                label: const Text(
                  'مراجعة إجاباتي',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // زر العودة
              ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'العودة للصفحة الرئيسية',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت مساعدة لبناء أعمدة الإحصائيات
  Widget _buildStatColumn(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
