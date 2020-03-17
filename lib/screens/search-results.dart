import 'package:flutter/material.dart';
import 'package:myapp/components/loader.dart';
import 'package:myapp/components/titlecard.dart';
import 'package:myapp/constants.dart';
import 'package:myapp/models/genre-model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:myapp/models/movie-model.dart';
import 'package:myapp/screens/movie-details.dart';

class SearchResults extends StatefulWidget {
  dynamic id;
  Screens type;
  String searchGenre = '';
  GenreListModel genres;

  SearchResults({
    this.id,
    this.type,
    this.genres,
    this.searchGenre,
  });

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  bool isSearchLoading = true;
  MovieListModel results;

  @override
  void initState() {
    super.initState();
    this.getResults();
  }

  void getResults([bool forceUpdate = false]) async {
    String url;
    switch (widget.type) {
      case Screens.GENRE:
        url = addHostAndApiKey(
            urls['discoverMovie'](), '&with_genres=${widget.id}&sort_by=vote_count.desc');
        break;
      case Screens.MOVIE:
        url = addHostAndApiKey(urls['movieSearch'](), '&query=${widget.id}');
        break;
      default:
    }
    print(url);
    if (url != null) {
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        var responseJson = convert.jsonDecode(response.body);
        results =
            MovieListModel.fromJSON(responseJson['results'], widget.genres);
      } else {
        print(response.statusCode);
      }
      this.setState(() {
        isSearchLoading = false;
      });
    }
  }

  void onTap(MovieModel movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetails(
          data: movie,
          genres: widget.genres,
          onTap: this.onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> resultCards = [];
    if (results != null) {
      results.movies.forEach((movie) {
        resultCards.add(
          Column(
            children: <Widget>[
              TitleCard(
                onTap: onTap,
                data: movie,
                index: 9,
              ),
            ],
          ),
        );
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchGenre != null
            ? 'Genre: ${widget.searchGenre}'
            : widget.id),
      ),
      body: isSearchLoading
          ? Loader()
          : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                child: Wrap(
                  runSpacing: 16,
                  spacing: 16,
                  alignment: WrapAlignment.spaceBetween,
                  children: resultCards,
                ),
              ),
            ),
    );
  }
}
