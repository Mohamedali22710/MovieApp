import 'package:flutter/material.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/provider/movie.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatelessWidget {
  final MovieModel movie;

  const DetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.read<MovieProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: CustomScrollView(
        slivers: [
          // الـ Header مع الصورة وزر الرجوع والمفضلة
          SliverAppBar(
            expandedHeight: 500,
            pinned: true,
            backgroundColor: const Color(0xFF1B263B),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                // إضافة معالج للأخطاء في حال فشل تحميل الصورة
                errorBuilder: (context, error, stackTrace) => 
                  const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.white24)),
              ),
            ),
            actions: [
              // زر المفضلة المرتبط بـ Firestore
              FutureBuilder<bool>(
                future: movieProvider.isMovieFavorite(movie.id),
                builder: (context, snapshot) {
                  // حالة التحميل المبدئية للقلب
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  }

                  final isFav = snapshot.data ?? false;

                  return StatefulBuilder( // لاستخدام تحديث محلي سريع للون القلب
                    builder: (context, setState) {
                      bool localIsFav = isFav;
                      return IconButton(
                        icon: Icon(
                          localIsFav ? Icons.favorite : Icons.favorite_border,
                          color: localIsFav ? Colors.red : Colors.white,
                          size: 28,
                        ),
                        onPressed: () async {
                          // تحديث قاعدة البيانات
                          await movieProvider.toggleFavorite(movie);
                          // تحديث شكل القلب فوراً
                          (context as Element).markNeedsBuild();
                        },
                      );
                    }
                  );
                },
              ),
            ],
          ),

          // محتوى الصفحة (العنوان، الوصف، التقييم)
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان والتقييم
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "⭐ ${movie.rating}",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // تاريخ الإصدار
                    Text(
                      "Release Date: ${movie.releaseDate}",
                      style: const TextStyle(color: Colors.white60, fontSize: 14, letterSpacing: 1.1),
                    ),
                    const SizedBox(height: 30),

                    // قصة الفيلم (Overview)
                    const Text(
                      "Overview",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      movie.overview,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 100), 
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}