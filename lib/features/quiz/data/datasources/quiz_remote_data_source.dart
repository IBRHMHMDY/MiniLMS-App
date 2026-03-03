import '../../../../core/network/dio_client.dart';
import '../models/quiz_models.dart';

abstract class QuizRemoteDataSource {
  Future<QuizModel> getCourseQuiz(int courseId);
  Future<QuizResultModel> submitQuiz(
    int courseId,
    List<Map<String, int>> answers,
  );
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final DioClient dioClient;

  QuizRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<QuizModel> getCourseQuiz(int courseId) async {
    final response = await dioClient.get('/courses/$courseId/quiz');
    return QuizModel.fromJson(response.data['data']);
  }

  @override
  Future<QuizResultModel> submitQuiz(
    int courseId,
    List<Map<String, int>> answers,
  ) async {
    final response = await dioClient.post(
      '/courses/$courseId/quiz/submit',
      data: {'answers': answers}, // شكل البيانات الذي يتوقعه Laravel
    );
    return QuizResultModel.fromJson(response.data['data']);
  }
}
