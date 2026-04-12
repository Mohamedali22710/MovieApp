class MovieModel {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double rating;
  final String releaseDate;

  MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.rating,
    required this.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      // رابط الصورة الكامل
      posterPath: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
      rating: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'] ?? '',
    );
  }

  // تحويل الموديل لـ Map عشان نخزنه في SharedPreferences
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'overview': overview,
    'poster_path': posterPath.replaceAll('https://image.tmdb.org/t/p/w500', ''),
    'vote_average': rating,
    'release_date': releaseDate,
  };
}