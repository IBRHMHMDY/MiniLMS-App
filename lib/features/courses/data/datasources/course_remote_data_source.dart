import '../../../../core/network/dio_client.dart';
import '../models/category_model.dart';
import '../models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<CourseModel>> getCourses();
  Future<CourseModel> getCourseDetails(int courseId);
  Future<List<CourseModel>> getMyCourses();
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final DioClient dioClient;

  CourseRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await dioClient.get('/categories');
    final data = response.data['data'];
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    }
    return [];
  }

  @override
  Future<List<CourseModel>> getCourses() async {
    final response = await dioClient.get('/courses');
    final data = response.data['data'];
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => CourseModel.fromJson(json))
          .toList();
    }
    return [];
  }

  @override
  Future<CourseModel> getCourseDetails(int courseId) async {
    final response = await dioClient.get('/courses/$courseId');
    return CourseModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<CourseModel>> getMyCourses() async {
    final response = await dioClient.get('/my-courses');
    final data = response.data['data'];
    // 🛡️ درع الحماية أثناء جلب دوراتي
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((course) => CourseModel.fromJson(course))
          .toList();
    }
    return [];
  }
}
