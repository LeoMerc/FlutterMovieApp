import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/debouncers.dart';
import 'package:flutter_application_1/models/search_movies_response.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class MoviesProvider extends ChangeNotifier {
  String _baseUrl = "api.themoviedb.org";
  String _apiKey = "34c5e4713e8895e86c0925f23ceb7ac2";
  String _language = "es-Es";
  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> moviesCast = {};
  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
    
  );

  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast ();
  Stream<List<Movie>> get suggestionsStream => this._suggestionStreamController.stream;

  MoviesProvider() {
    print('MoviesProvider inicializado');
    getOnDisplayMovies();
    getPopularMovies();
  }
  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final JsonData = await _getJsonData('3/movie/now_playing', 1);
    final nowPlayingResponse = NowPlayingResponse.fromJson(JsonData);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final JsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(JsonData);
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if(moviesCast.containsKey(movieId) )return moviesCast[movieId]!;
    print("Pidiendo info al servidor");

    final JsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(JsonData);
    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

 Future <List<Movie>> searchMovies(String query) async {
      final url = Uri.https(_baseUrl, '3/search/movie', 
      {
      'api_key': _apiKey,
      'language': _language,
      'query': query
  }
  );
  final response = await http.get(url);
  final searchResponse = SearchResponse.fromJson(response.body);
  return searchResponse.results;
}

void getSuggestionsByQuery (String searchTerm) {
debouncer.value = "";
debouncer.onValue = (value) async {
  final results = await this.searchMovies(value);
  this._suggestionStreamController.add(results);
};

final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
  debouncer.value = searchTerm; 
 });

 Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
}

}
