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
    // يقوم الـ API بإرجاع رسالة نجاح، لا نحتاج لتحويلها إلى Model حالياً
    await dioClient.post('/courses/$courseId/enroll');
  }

  @override
  Future<List<LessonModel>> getCourseLessons(int courseId) async {
    final response = await dioClient.get('/courses/$courseId/lessons');

    // سطر الطباعة لكشف شكل البيانات الحقيقي
    print('💡 استجابة الدروس: ${response.data}');

    // 👈 اللمسة المعمارية: التعامل مع التغليف المزدوج من لارافيل
    var responseData = response.data['data'];

    // إذا كان لارافيل قد أرسلها كـ Map بداخلها data، نستخرجها
    if (responseData is Map && responseData.containsKey('data')) {
      responseData = responseData['data'];
    }

    // الآن نحن متأكدون بنسبة 100% أنها List
    final List dataList = responseData as List;

    return dataList
        .map((json) {
          if (json is List) return null;
          return LessonModel.fromJson(json as Map<String, dynamic>);
        })
        .whereType<LessonModel>()
        .toList(); // استبعاد أي قيم null
  }

  @override
  Future<void> toggleLessonCompletion(int lessonId) async {
    await dioClient.post('/lessons/$lessonId/toggle-completion');
  }
}
