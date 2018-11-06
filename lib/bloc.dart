import 'dart:async';

//bring the other files as packages
import 'package:bloc_movie_searcher/model.dart';

import 'package:rxdart/rxdart.dart';

class MovieBloc{
  final API api;

  //creating two stream variables and setting them to empty
  Stream<List<Movie>> _result = Stream.empty();
  Stream<String> _log = Stream.empty();

  //rxDart type stream controller command click for more info
  ReplaySubject<String> _query = ReplaySubject<String>();

  //setting getter functions for streams
  Stream<String> get log=> _log;
  Stream<List<Movie>> get results => _result;
  Sink<String> get query => _query;

  //movie bloc constructor
  //the result stream will take the query stream
  //.distinct() means that it will throw out anything that isn't unique value
  //.asyncMap(api.get) will map the objects retrieved from the api using the .get function we specified from the class api
  //and it's a broadcast stream. A broadcast stream enables multiple listeners
  MovieBloc(this.api){
    _result = _query.distinct().asyncMap(api.get).asBroadcastStream();

    //_log will lookout for any latest data coming from _query stream
    //and display them as results for that query
    //also a broadcast stream
    _log = Observable(results)
      .withLatestFrom(_query.stream, (_, query) => 'Results for $query')
      .asBroadcastStream();

  }

  //gotta close the sink stream properly
  void dispose(){
    _query.close();
  }
}