import 'package:flutter/material.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/provider/movie.dart';

import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        title: const Text(
          "MY FAVORITES",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
      ),
      // داخل ملف favorites_page.dart
body: StreamBuilder<List<MovieModel>>(
  stream: context.read<MovieProvider>().favoriteMoviesStream,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator(color: Colors.amber));
    }
    
    final favorites = snapshot.data ?? [];

    if (favorites.isEmpty) {
      return const Center(child: Text("No favorites yet!", style: TextStyle(color: Colors.white70)));
    }

    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final movie = favorites[index];
        return ListTile(
          leading: Image.network(movie.posterPath, width: 50),
          title: Text(movie.title, style: const TextStyle(color: Colors.white)),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => context.read<MovieProvider>().toggleFavorite(movie),
          ),
        );
      },
    );
  },
),
    );
  }
}