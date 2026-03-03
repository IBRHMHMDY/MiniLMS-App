import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/learning_repository.dart';

class ToggleLessonCompletionUseCase {
  final LearningRepository repository;

  ToggleLessonCompletionUseCase(this.repository);

  Future<Either<Failure, void>> call(int lessonId) async {
    return await repository.toggleLessonCompletion(lessonId);
  }
}
