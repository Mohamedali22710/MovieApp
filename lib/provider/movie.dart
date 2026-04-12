import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/services/movie_serv.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MovieProvider with ChangeNotifier {
  final MovieService _movieService = MovieService(); 
  List<MovieModel> popularMovies = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchMovies() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      popularMovies = await _movieService.getPopularMovies();
    } catch (e) {
      errorMessage = e.toString();
    }
    
    isLoading = false;
    notifyListeners();
  }

  // lib/providers/movie_provider.dart

Future<void> search(String query) async {
  if (query.isEmpty) {
    fetchMovies(); // لو السيرش فاضي، نرجع للأفلام الـ Popular
    return;
  }

  isLoading = true;
  notifyListeners();

  try {
    popularMovies = await _movieService.searchMovies(query);
    errorMessage = '';
  } catch (e) {
    errorMessage = e.toString();
  }

  isLoading = false;
  notifyListeners();
}


List<MovieModel> _favoriteMovies = [];
  List<MovieModel> get favoriteMovies => _favoriteMovies;


  bool isFavorite(MovieModel movie) {
    return _favoriteMovies.any((m) => m.id == movie.id);
  }

  
  void toggleFavorite(MovieModel movie) {
    final index = _favoriteMovies.indexWhere((m) => m.id == movie.id);
    if (index >= 0) {
      _favoriteMovies.removeAt(index);
    } else {
      _favoriteMovies.add(movie);
    }
    _favoriteMovies = List.from(_favoriteMovies);
    _saveFavoritesToDisk();
    notifyListeners();
  }



  Future<void> _saveFavoritesToDisk() async {
    final prefs = await SharedPreferences.getInstance();
 
    final String encodedData = jsonEncode(
      _favoriteMovies.map((movie) => movie.toJson()).toList(),
    );
    await prefs.setString('favorite_movies', encodedData);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('favorite_movies');
    if (savedData != null) {
      final List decodedData = jsonDecode(savedData);
      _favoriteMovies = decodedData.map((m) => MovieModel.fromJson(m)).toList();
      notifyListeners();
    }
  }
  
}