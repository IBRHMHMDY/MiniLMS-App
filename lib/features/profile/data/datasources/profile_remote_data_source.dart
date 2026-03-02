import '../../../../core/network/dio_client.dart';
import '../../../auth/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile(String name, String? email);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> getProfile() async {
    final response = await dioClient.get('/profile');
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<UserModel> updateProfile(String name, String? email) async {
    final Map<String, dynamic> data = {'name': name};
    if (email != null && email.isNotEmpty) {
      data['email'] = email;
    }

    final response = await dioClient.post(
      '/profile',
      data: {
        '_method': 'PUT', // Laravel workaround for PUT requests with form data
        ...data,
      },
    );
    return UserModel.fromJson(response.data['data']);
  }
}
