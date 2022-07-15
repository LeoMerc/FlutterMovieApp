import "package:flutter/material.dart";

import '../models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  String title;
  final Function onNextPage;

  MovieSlider(
      {super.key,
      required this.movies,
      this.title = "",
      required this.onNextPage});

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  bool _canGetMore = true;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      print(scrollController.position.pixels);

      print(scrollController.position.maxScrollExtent);

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        //ToDo llamar provider
        print('Obtener next page');
        if (_canGetMore) {
          _canGetMore = false;
          widget.onNextPage();
        }
      } else {
        _canGetMore = true;
      }
    });
  }

  void dispose() {}

  Widget build(BuildContext context) {
    var padTitle = Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Populares',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );

    bool titleAvailable = false;
    if (widget.title.isNotEmpty) {
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
          titleAvailable ? padTitle : Container(),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int index) {
                final movie = widget.movies[index];

                return _MoviePoster(movie, '${widget.title}-${index}-${widget.movies[index].id}');
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
  final String heroId;
  const _MoviePoster(this.movie, this.heroId);

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroId;

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
            onTap: () =>
                Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: heroId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  // height: 185,
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                ),
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
