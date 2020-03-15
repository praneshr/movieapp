import 'dart:convert' as convert;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/components/banner.dart' as MovieBanner;
import 'package:myapp/components/loader.dart';
import 'package:myapp/components/titlecard.dart';
import 'package:myapp/constants.dart';
import 'package:myapp/models/genre-model.dart';
import 'package:myapp/models/movie-model.dart';
import 'package:myapp/screens/movie-details.dart';

class Movie extends StatefulWidget {
  Map<String, dynamic> state;
  Function updateState;
  _MovieState _stateView = _MovieState();

  Movie({this.state, this.updateState});

  void refresh() {
    _stateView.getLatestMovies(true);
  }

  @override
  _MovieState createState() => this._stateView;
}

class _MovieState extends State<Movie> {
  bool isTrendingLoading = false;
  bool isPopularLoading = false;
  bool isGenreLoading = false;
  bool isNowPlayingLoading = false;
  GenreListModel genres;

  @override
  void initState() {
    super.initState();
    this.getGenres();
    this.getLatestMovies();
    this.getMostLovedMovies();
    this.getNowPlaying();
  }

  void setTrendingLoadingState(bool state) {
    setState(() {
      isTrendingLoading = state;
    });
  }

  void setPopularLoadingState(bool state) {
    setState(() {
      isPopularLoading = state;
    });
  }

  void setGenreLoadingState(bool state) {
    setState(() {
      isGenreLoading = state;
    });
  }

  void setNowPlayingLoadingState(bool state) {
    setState(() {
      isNowPlayingLoading = state;
    });
  }

  void getGenres([bool forceUpdate = false]) async {
    if (widget.state['genres'] == null || forceUpdate) {
      this.setGenreLoadingState(true);
      http.Response response =
          await http.get(addHostAndApiKey(urls['genre']()));
      if (response.statusCode == 200) {
        var responseJson = convert.jsonDecode(response.body);
        genres = GenreListModel.fromJSON(responseJson['genres']);
      } else {
        print(response.statusCode);
      }
      this.setGenreLoadingState(false);
    }
  }

  void getMostLovedMovies([bool forceUpdate = false]) async {
    if (widget.state['mostLovedMovie'] == null || forceUpdate) {
      this.setPopularLoadingState(true);
      http.Response response = await http.get(addHostAndApiKey(
          urls['discoverMovie'](), '&sort_by=vote_count.desc'));
      if (response.statusCode == 200) {
        var responseJson = convert.jsonDecode(response.body);
        widget.updateState('mostLovedMovie', responseJson);
      } else {
        print(response.statusCode);
      }
      this.setPopularLoadingState(false);
    }
  }

  void getNowPlaying([bool forceUpdate = false]) async {
    if (widget.state['nowPlaying'] == null || forceUpdate) {
      this.setNowPlayingLoadingState(true);
      http.Response response =
          await http.get(addHostAndApiKey(urls['nowPlaying']()));
      if (response.statusCode == 200) {
        var responseJson = convert.jsonDecode(response.body);
        widget.updateState('nowPlaying', responseJson);
      } else {
        print(response.statusCode);
      }
      this.setNowPlayingLoadingState(false);
    }
  }

  void getLatestMovies([bool forcedUpdate = false]) async {
    if (widget.state['discoverMovie'] == null || forcedUpdate) {
      this.setTrendingLoadingState(true);
      http.Response response =
          await http.get(addHostAndApiKey(urls['trendingMovieWeek']()));
      if (response.statusCode == 200) {
        var responseJson = convert.jsonDecode(response.body);
        widget.updateState('discoverMovie', responseJson);
      } else {
        print(response.statusCode);
      }
      this.setTrendingLoadingState(false);
    }
  }

  onTap(MovieModel data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetails(
          data: data,
          genres: genres,
          onTap: this.onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isTrendingLoading ||
        isPopularLoading ||
        isGenreLoading ||
        isNowPlayingLoading) {
      return Container(
        height: MediaQuery.of(context).size.height,
        child: Loader(),
      );
    }

    MovieListModel latestMovies = MovieListModel.fromJSON(
        widget.state['discoverMovie']['results'], genres);
    MovieListModel nowPlaying =
        MovieListModel.fromJSON(widget.state['nowPlaying']['results'], genres);
    MovieListModel mostLovedMovies = MovieListModel.fromJSON(
        widget.state['mostLovedMovie']['results'], genres);
    List<Widget> latestMovieCards = [];
    List<Widget> mostLovedMovieCards = [];
    List<Widget> nowPlayingCards = [];
    latestMovies.movies.forEach((movie) {
      latestMovieCards.add(
        Column(
          children: <Widget>[
            TitleCard(
              onTap: onTap,
              data: movie,
              index: latestMovies.movies.indexOf(movie),
            ),
          ],
        ),
      );
    });
    mostLovedMovies.movies.forEach((movie) {
      mostLovedMovieCards.add(
        Column(
          children: <Widget>[
            TitleCard(
              onTap: onTap,
              data: movie,
              index: mostLovedMovies.movies.indexOf(movie),
            ),
          ],
        ),
      );
    });
    nowPlaying.movies.forEach((movie) {
      nowPlayingCards.add(
        Column(
          children: <Widget>[
            TitleCard(
              onTap: onTap,
              data: movie,
              index: nowPlaying.movies.indexOf(movie),
            ),
          ],
        ),
      );
    });

    Random random = Random();
    int index = random.nextInt(latestMovies.movies.length);
    var currentLatestMovie = latestMovies.movies[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MovieBanner.Banner(
          data: currentLatestMovie,
        ),
        Container(
          margin: EdgeInsets.only(
            left: 16,
            bottom: 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Image.asset(
                assets['images']['trending'],
                width: 22,
                color: Colors.cyan.shade400,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'Trending today',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 310,
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: latestMovieCards,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 16,
            left: 16,
            bottom: 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Image.asset(
                assets['images']['show'],
                width: 22,
                color: Colors.orange.shade500,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'In Cinemas',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 310,
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: nowPlayingCards,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 16,
            left: 16,
            bottom: 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Image.asset(
                assets['images']['heart'],
                width: 22,
                color: Colors.red.shade500,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'Most Loved',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 310,
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: mostLovedMovieCards,
          ),
        ),
      ],
    );
  }
}
