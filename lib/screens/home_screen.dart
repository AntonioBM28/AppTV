import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_app/data/mock_movies.dart';
import 'package:smart_app/router/app_router.dart';
import 'package:smart_app/widgets/movie_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITULO
              Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.red, size: 32),
                  const SizedBox(width: 12),
                  const Text(
                    'Mis peliculas Favoritas',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),

              //LISTADO DE PELICULAS
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: mockMovies.length,
                  itemBuilder: (context, index) {
                    final movie = mockMovies[index];

                    return MovieCard(
                      movie: movie,
                      autofocus: index == 0,
                      onSelect: () {
                        context.goNamed(
                          AppRoutes.movieDetail,
                          extra: movie,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}