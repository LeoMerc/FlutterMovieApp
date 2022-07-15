import "package:flutter/material.dart";

import '../models/models.dart';

class MovieSlider extends StatelessWidget {
final List<Movie> movies;
 String title;

   MovieSlider({super.key, required this.movies, this.title = ""});
  @override
  Widget build(BuildContext context) {
    
    var padTitle = Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Populares',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );

bool titleAvailable = false;
if (title.isNotEmpty){
  titleAvailable = true;
} 
// int leg = movies.length;
// print("Pelis: $leg");


    return Container(
      width: double.infinity,
      height: 275,
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        titleAvailable ?  padTitle : Container(),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (_, int index) {
                          final movie = movies[index];

               return _MoviePoster(movie: movie);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
   
          final movie;

  const _MoviePoster({super.key, required this.movie});


  @override
  Widget build(BuildContext context) {

    return Container(
      width: 130,
      height: 190,
      //  color: Colors.green,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details',
                arguments: 'movie-instance'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                // height: 185,
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
