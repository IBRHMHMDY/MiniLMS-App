import '../../../../core/network/dio_client.dart';
import '../models/lesson_model.dart';

abstract class LearningRemoteDataSource {
  Future<void> enrollInCourse(int courseId);
  Future<List<LessonModel>> getCourseLessons(int courseId);
  Future<void> toggleLessonCompletion(int lessonId) async {}
}

class LearningRemoteDataSourceImpl implements LearningRemoteDataSource {
  final DioClient dioClient;

  LearningRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<void> enrollInCourse(int courseId) async {
    await dioClient.post('/courses/$courseId/enroll');
  }

  @override
  Future<List<LessonModel>> getCourseLessons(int courseId) async {
    final response = await dioClient.get('/courses/$courseId/lessons');

    var responseData = response.data['data'];
    if (responseData is Map && responseData.containsKey('data')) {
      responseData = responseData['data'];
    }

    final List dataList = responseData is List ? responseData : [];

    // 🚀 تنظيف البيانات وجلب الكائنات فقط (Map)
    return dataList
        .whereType<Map<String, dynamic>>()
        .map((json) => LessonModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> toggleLessonCompletion(int lessonId) async {
    await dioClient.post('/lessons/$lessonId/toggle-completion');
  }
}
