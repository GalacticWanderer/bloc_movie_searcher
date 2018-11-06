import 'api_key.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

///This is the data model class for the movies
class Movie{
  //declaring and initializing final variables for this movie model using
  //constructors
  final String title, posterPath, overview;
  Movie(this.title, this.posterPath, this.overview);

  //chaining a method to the movie constructor which maps the variables with
  //json data
  Movie.fromJson(Map json):
        title = json["title"],
        posterPath = json["poster_path"],
        overview = json["overview"];
}

///api class talks to the server and converts the json using the model class
class API{
  //setting up http client and the api url with key and query
  final http.Client _client = http.Client();
  static const String _url =
      'https://api.themoviedb.org/3/search/movie?api_key=$api_key&query={1}';//api_key added and query will be the query that users types

  //this function makes a call to api, receives data, converts it to movie model for each item
  //and then returns a list of movie items
  Future<List<Movie>> get(String query) async{

    //the list of movie type items that will be used to store the data
    List<Movie> list = [];

    await _client.get(Uri.parse(_url.replaceFirst("{1}", query)))
        .then((res) => res.body)
        .then(jsonDecode)
        .then((json)=> json["results"])
        .then((movies) =>
          movies.forEach((movie) => list.add(Movie.fromJson(movie))));
    return list;
  }

}