import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;
  final FlutterSecureStorage secureStorage;

  AuthRemoteDataSourceImpl({
    required this.dioClient,
    required this.secureStorage,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await dioClient.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    final data = response.data['data'];
    await secureStorage.write(key: 'auth_token', value: data['token']);
    return UserModel.fromJson(data['user']);
  }

  @override
  Future<UserModel> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final response = await dioClient.post(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    final data = response.data['data'];
    await secureStorage.write(key: 'auth_token', value: data['token']);
    return UserModel.fromJson(data['user']);
  }
}
