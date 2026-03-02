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
  Future<void> logout();
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(
    String email,
    String token,
    String password,
    String passwordConfirmation,
  );
  Future<bool> checkAuth();
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

  @override
  Future<void> logout() async {
    await dioClient.post('/auth/logout');
    await secureStorage.delete(key: 'auth_token');
  }

  @override
  Future<void> forgotPassword(String email) async {
    await dioClient.post('/auth/forgot-password', data: {'email': email});
  }

  @override
  Future<void> resetPassword(
    String email,
    String token,
    String password,
    String passwordConfirmation,
  ) async {
    await dioClient.post(
      '/auth/reset-password',
      data: {
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }
  
  @override
  Future<bool> checkAuth() async {
    final token = await secureStorage.read(key: 'auth_token');
    return token != null && token.isNotEmpty;
  }
}
