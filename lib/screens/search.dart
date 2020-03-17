import 'package:flutter/material.dart';
import 'package:myapp/components/loader.dart';
import 'package:myapp/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:myapp/models/genre-model.dart';
import 'package:myapp/screens/search-results.dart';
import 'package:random_color/random_color.dart';

class Search extends StatefulWidget {
  Map<String, Object> state;
  Function updateState;

  Search({this.state, this.updateState});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  GenreListModel genres;
  bool isGenreLoading = true;

  @override
  void initState() {
    getGenres();
  }

  void setGenreLoadingState(bool state) {
    setState(() {
      isGenreLoading = state;
    });
  }

  void getGenres() async {
    http.Response response = await http.get(addHostAndApiKey(urls['genre']()));
    if (response.statusCode == 200) {
      var responseJson = convert.jsonDecode(response.body);
      genres = GenreListModel.fromJSON(responseJson['genres']);
    } else {
      print(response.statusCode);
    }
    this.setGenreLoadingState(false);
  }

  onTap(dynamic id, [Screens type = Screens.GENRE, String genreName]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResults(
          id: id,
          type: type,
          genres: genres,
          searchGenre: genreName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isGenreLoading) {
      return Container(
        height: MediaQuery.of(context).size.height,
        child: Loader(),
      );
    }
    List<Widget> genresList = [];
    genres.genres.forEach((genre) {
      genresList.add(GestureDetector(
        onTap: () {
          onTap(genre.id, Screens.GENRE, genre.name);
        },
        child: Container(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Text(genre.name),
          ),
        ),
      ));
    });

    return Container(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(16),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: Image.asset(assets['images']['search']),
                      width: 18,
                    ),
                    Expanded(
                      child: TextField(
                        cursorWidth: 1,
                        onSubmitted: (val) {
                          onTap(val, Screens.MOVIE);
                        },
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search movies, TV shows and artists',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Seach by genre',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Wrap(
                      runSpacing: 16,
                      children: genresList,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
