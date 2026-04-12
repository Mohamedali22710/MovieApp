import 'package:dio/dio.dart';
import 'package:movie_app/model/movie_model.dart';


class MovieService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = '340d9c279a9102b33e1f1f0246e5194f';

  Future<List<MovieModel>> getPopularMovies() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/movie/popular',
        queryParameters: {'api_key': _apiKey},
      );
      
 
      final List results = response.data['results'];
      

      return results.map((m) => MovieModel.fromJson(m)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch movies: ${e.message}');
    }
  }

  // lib/data/services/movie_service.dart

Future<List<MovieModel>> searchMovies(String query) async {
  try {
    final response = await _dio.get(
      '$_baseUrl/search/movie',
      queryParameters: {
        'api_key': _apiKey,
        'query': query, // كلمة البحث اللي اليوزر كتبها
      },
    );
    
    final List results = response.data['results'];
    return results.map((m) => MovieModel.fromJson(m)).toList();
  } on DioException catch (e) {
    throw Exception('Search failed: ${e.message}');
  }
}
}