// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:movie_app/model/movie_model.dart';
// import 'package:movie_app/services/movie_serv.dart';
// import 'package:shared_preferences/shared_preferences.dart';


// class MovieProvider with ChangeNotifier {
//   final MovieService _movieService = MovieService(); 
//   List<MovieModel> popularMovies = [];
//   bool isLoading = false;
//   String errorMessage = '';

//   Future<void> fetchMovies() async {
//     isLoading = true;
//     errorMessage = '';
//     notifyListeners();

//     try {
//       popularMovies = await _movieService.getPopularMovies();
//     } catch (e) {
//       errorMessage = e.toString();
//     }
    
//     isLoading = false;
//     notifyListeners();
//   }

//   // lib/providers/movie_provider.dart

// Future<void> search(String query) async {
//   if (query.isEmpty) {
//     fetchMovies(); // لو السيرش فاضي، نرجع للأفلام الـ Popular
//     return;
//   }

//   isLoading = true;
//   notifyListeners();

//   try {
//     popularMovies = await _movieService.searchMovies(query);
//     errorMessage = '';
//   } catch (e) {
//     errorMessage = e.toString();
//   }

//   isLoading = false;
//   notifyListeners();
// }


// List<MovieModel> _favoriteMovies = [];
//   List<MovieModel> get favoriteMovies => _favoriteMovies;


//   bool isFavorite(MovieModel movie) {
//     return _favoriteMovies.any((m) => m.id == movie.id);
//   }

  
//   void toggleFavorite(MovieModel movie) {
//     final index = _favoriteMovies.indexWhere((m) => m.id == movie.id);
//     if (index >= 0) {
//       _favoriteMovies.removeAt(index);
//     } else {
//       _favoriteMovies.add(movie);
//     }
//     _favoriteMovies = List.from(_favoriteMovies);
//     _saveFavoritesToDisk();
//     notifyListeners();
//   }



//   Future<void> _saveFavoritesToDisk() async {
//     final prefs = await SharedPreferences.getInstance();
 
//     final String encodedData = jsonEncode(
//       _favoriteMovies.map((movie) => movie.toJson()).toList(),
//     );
//     await prefs.setString('favorite_movies', encodedData);
//   }

//   Future<void> loadFavorites() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? savedData = prefs.getString('favorite_movies');
//     if (savedData != null) {
//       final List decodedData = jsonDecode(savedData);
//       _favoriteMovies = decodedData.map((m) => MovieModel.fromJson(m)).toList();
//       notifyListeners();
//     }
//   }
  
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/movie_model.dart';

class MovieProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // لجلب الـ UID الخاص بالمستخدم الحالي
  String get _userId => _auth.currentUser?.uid ?? "";

  // إضافة أو حذف من المفضلة في Firestore
  Future<void> toggleFavorite(MovieModel movie) async {
    if (_userId.isEmpty) return;

    final docRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .doc(movie.id.toString());

    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete(); // إذا كان موجوداً، نحذفه
    } else {
      await docRef.set(movie.toMap()); // إذا لم يكن موجوداً، نضيفه باستخدام الـ toMap اللي عملناها
    }
    notifyListeners();
  }

  // Stream لمراقبة الأفلام المفضلة لحظياً من Firestore
  Stream<List<MovieModel>> get favoriteMoviesStream {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MovieModel.fromMap(doc.data()))
            .toList());
  }


  Future<bool> isMovieFavorite(int movieId) async {
  final doc = await _firestore
      .collection('users')
      .doc(_userId)
      .collection('favorites')
      .doc(movieId.toString())
      .get();
  return doc.exists;
}
}

