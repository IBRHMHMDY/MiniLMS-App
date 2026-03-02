import '../../../../core/network/dio_client.dart';
import '../models/lesson_model.dart';

abstract class LearningRemoteDataSource {
  Future<void> enrollInCourse(int courseId);
  Future<List<LessonModel>> getCourseLessons(int courseId);
}

class LearningRemoteDataSourceImpl implements LearningRemoteDataSource {
  final DioClient dioClient;

  LearningRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<void> enrollInCourse(int courseId) async {
    // يقوم الـ API بإرجاع رسالة نجاح، لا نحتاج لتحويلها إلى Model حالياً
    await dioClient.post('/courses/$courseId/enroll');
  }

  @override
  Future<List<LessonModel>> getCourseLessons(int courseId) async {
    final response = await dioClient.get('/courses/$courseId/lessons');
    final List data = response.data['data'];
    return data.map((json) => LessonModel.fromJson(json)).toList();
  }
}
