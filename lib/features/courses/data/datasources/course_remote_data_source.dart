import '../../../../core/network/dio_client.dart';
import '../models/category_model.dart';
import '../models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<CourseModel>> getCourses();
  Future<CourseModel> getCourseDetails(int courseId);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final DioClient dioClient;

  CourseRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await dioClient.get('/categories');
    final List data = response.data['data'];
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }

  @override
  Future<List<CourseModel>> getCourses() async {
    final response = await dioClient.get('/courses');
    final List data = response.data['data'];
    return data.map((json) => CourseModel.fromJson(json)).toList();
  }

  @override
  Future<CourseModel> getCourseDetails(int courseId) async {
    final response = await dioClient.get('/courses/$courseId');
    return CourseModel.fromJson(response.data['data']);
  }
}
