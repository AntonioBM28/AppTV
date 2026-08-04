import 'package:flutter/material.dart';
import 'package:smart_app/data/mock_movies.dart';
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
                  Icon(Icons.favorite, color: Colors.red, size: 32),
                  SizedBox(width: 12,),
                  Text(
                    'Mis peliculas Favoritas',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w400
                    ),
                  )
                ],
              ),

              //LISTADO DE PELICULAS
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // elementos que se mostraran en un grid de una fila con N elementos que uno defina
                    mainAxisSpacing: 24, //espaciado entre cada elemento del grid
                    crossAxisSpacing: 24,
                    childAspectRatio: 0.75 // efecto cuando se selecciona
                  ),
                  itemCount: mockMovies.length, 
                  itemBuilder: (context, index) {
                    final movie = mockMovies[index];

                    return MovieCard(
                      movie: movie,
                      autofocus: index == 0,
                      onSelect: () {
                        // TODO: navegar al detalle de la película
                      },
                    );
                  }
                )
              )
            ],
          ),
        )
      )
    );
  }
}