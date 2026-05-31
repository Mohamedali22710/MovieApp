// lib/models/movie_model.dart

class MovieModel {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double rating;
  final String releaseDate;

  MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.rating,
    required this.releaseDate,
  });

  // 1. تحويل البيانات القادمة من TMDB API (JSON) إلى كائن MovieModel
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      overview: json['overview'] ?? '',
      // ندمج رابط TMDB الأساسي مع المسار النسبي للصورة
      posterPath: json['poster_path'] != null 
          ? "https://image.tmdb.org/t/p/w500${json['poster_path']}" 
          : "https://via.placeholder.com/500x750?text=No+Image",
      backdropPath: json['backdrop_path'] != null 
          ? "https://image.tmdb.org/t/p/w1280${json['backdrop_path']}" 
          : "https://via.placeholder.com/1280x720?text=No+Image",
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] ?? '',
    );
  }

  // 2. تحويل الكائن إلى Map لحفظه في Firestore (المفضلة)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'rating': rating,
      'releaseDate': releaseDate,
    };
  }

  // 3. إنشاء كائن من بيانات Firestore
  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      id: map['id'],
      title: map['title'],
      overview: map['overview'],
      posterPath: map['posterPath'],
      backdropPath: map['backdropPath'],
      rating: (map['rating'] as num).toDouble(),
      releaseDate: map['releaseDate'],
    );
  }
}