import '../../domain/entities/course_entity.dart';
import 'category_model.dart';
import 'instructor_model.dart';

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    super.imageUrl,
    super.instructor,
    super.category,
    super.isFree
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      imageUrl: json['image_url'],
      instructor: json['instructor'] != null
          ? InstructorModel.fromJson(json['instructor'])
          : null,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      isFree: json['is_free'] != null
          ? (json['is_free'] == true || json['is_free'] == 1)
          : true,
    );
  }
}
