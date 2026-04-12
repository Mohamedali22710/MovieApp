
import 'package:dio/dio.dart';
import 'package:movie_app/model/user_model.dart';


class AuthService {
  final Dio _dio = Dio();
  final String _loginUrl = 'https://dummyjson.com/auth/login';

  Future<UserModel> login(String username, String password) async {
    try {
      final response = await _dio.post(_loginUrl, data: {
        'username': username,
        'password': password,
      });
      
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }
}