///provider class to serve this bloc to the entire project
//bring the other files as packages
import 'package:bloc_movie_searcher/model.dart';
import 'package:bloc_movie_searcher/bloc.dart';

//flutter core widgets are required here for inherited widgets
import 'package:flutter/widgets.dart';

class MovieProvider extends InheritedWidget {
  //declaring a MovieBloc object to use here
  final MovieBloc movieBloc;

  //boilerplate, updateShouldNotify should always return true
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  //boilerplate, setup movieBloc with MovieProvider
  static MovieBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(MovieProvider)
              as MovieProvider)
          .movieBloc;

  //constructor for provider class, takes key, movie bloc, widget
  MovieProvider({Key key, MovieBloc movieBloc, Widget child}):
      //if movieBloc is null, calling to make a new one
      this.movieBloc = movieBloc ?? MovieBloc(API()),
      //passing to super class
      super(child: child, key: key);
}
