import 'package:flutter/material.dart';
import 'package:bloc_movie_searcher/bloc.dart';
import 'package:bloc_movie_searcher/model.dart';
import 'package:bloc_movie_searcher/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //wrapping material with the provider and giving it a bloc
    return MovieProvider(
      movieBloc: MovieBloc(API()),
      child: MaterialApp(
        title: 'BLoC demo',
        theme: ThemeData(),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //movie bloc can be accessed from anywhere within the app because of the provider
    //getting the bloc for this class
    final movieBloc = MovieProvider.of(context);
    //using streamBuilders to build the data that is being emitted from streams
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Bloc mivie"),
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: TextField(
                //on input add to movieBloc's query
                onChanged: movieBloc.query.add,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search for a new movie'),
              ),
            ),
            StreamBuilder(
              stream: movieBloc.log,
              builder: (context, snapshot) => Container(
                    child: Text(snapshot?.data ?? ''),
                  ),
            ),
            Expanded(
                child: StreamBuilder(
                    stream: movieBloc.results,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) => ListTile(
                            leading: CircleAvatar(
                              child: Image.network(
                                  "https://image.tmdb.org/t/p/w92" +
                                      snapshot.data[index].posterPath),
                            ),
                            title: Text(snapshot.data[index].title),
                            subtitle: Text(snapshot.data[index].overview),
                          ));

                    }))
          ],
        ),
      ),
    );
  }
}
