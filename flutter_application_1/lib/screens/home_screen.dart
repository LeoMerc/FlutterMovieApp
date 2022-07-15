import 'package:flutter/material.dart';
import 'package:flutter_application_1/search/search_delegate.dart';
import 'package:provider/provider.dart';

import '../providers/movies_provider.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);
//     int leg = moviesProvider.onDisplayMovies.length;
//  print("Pelis: $leg");

//     int leg1 = moviesProvider.popularMovies.length;
//  print("Pelis: $leg1");


    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()), icon: Icon(Icons.search_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(movies: moviesProvider.onDisplayMovies),
            MovieSlider(movies: moviesProvider.popularMovies, title: "Popular", onNextPage: () {moviesProvider.getPopularMovies();},),
            MovieSlider(movies: moviesProvider.popularMovies, onNextPage: () {moviesProvider.getPopularMovies();} ),

           
          ],
        ),
      ),
    );
  }
}
