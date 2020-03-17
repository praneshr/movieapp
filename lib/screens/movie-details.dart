import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components/cast-info.dart';
import 'package:myapp/components/info.dart';
import 'package:myapp/components/loader.dart';
import 'package:myapp/components/reviews.dart';
import 'package:myapp/components/section-title.dart';
import 'package:myapp/components/titlecard.dart';
import 'package:myapp/constants.dart';
import 'package:myapp/models/genre-model.dart';
import 'package:myapp/models/movie-details-model.dart';
import 'package:myapp/models/movie-model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:myapp/components/banner.dart' as MovieBanner;

class MovieDetails extends StatefulWidget {
  MovieModel data;
  GenreListModel genres;
  Function onTap;

  MovieDetails({this.data, this.genres, this.onTap});
  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  bool isMovieDetailsLoading = false;
  MovieDetailsModel details;

  @override
  void initState() {
    getMovieDetails();
  }

  void goBack() {
    Navigator.pop(context);
  }

  void setMovieLoadingState(bool state) {
    setState(() {
      isMovieDetailsLoading = state;
    });
  }

  void getMovieDetails() async {
    setMovieLoadingState(true);
    http.Response response = await http.get(addHostAndApiKey(
      urls['movieDetails'](widget.data.id),
      '&append_to_response=releases,images,videos,credits,similar,reviews',
    ));
    if (response.statusCode == 200) {
      var responseJson = convert.jsonDecode(response.body);
      details = MovieDetailsModel.fromJSON(responseJson, widget.genres);
    } else {
      print(response.statusCode);
    }
    setMovieLoadingState(false);
  }

  onTap(MovieModel data) {
    widget.onTap(data);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> similarMoviesCard = [];
    if (!isMovieDetailsLoading) {
      details.similar.forEach((movie) {
        similarMoviesCard.add(
          Column(
            children: <Widget>[
              TitleCard(
                onTap: onTap,
                data: movie,
                index: details.similar.indexOf(movie),
              ),
            ],
          ),
        );
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MovieBanner.Banner(
              data: widget.data,
              isDetailsPage: true,
            ),
            Container(
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Column(
                children: <Widget>[
                  Info(
                    label: 'Overview',
                    mini: true,
                    value: widget.data.overview,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                    ),
                    child: isMovieDetailsLoading
                        ? Loader()
                        : Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 32),
                                      child: Info(
                                        mini: true,
                                        label: 'Year',
                                        value: widget.data.year,
                                      ),
                                    ),
                                    Info(
                                      mini: true,
                                      label: 'Runtime',
                                      value: printDuration(
                                        Duration(minutes: details.runtime),
                                        abbreviated: true,
                                        delimiter: ' ',
                                        spacer: '',
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 32),
                                      child: Info(
                                        mini: true,
                                        label: 'Status',
                                        value: details.status.toString(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 16),
                                child: Column(
                                  children: <Widget>[
                                    SectionTitle(
                                      imageUrl: assets['images']['artist'],
                                      label: 'Cast',
                                      iconColor: Colors.cyanAccent.shade700,
                                    ),
                                    CastInfo(
                                      data: details.cast,
                                    ),
                                    details.reviews.length != 0
                                        ? Column(
                                            children: <Widget>[
                                              SectionTitle(
                                                imageUrl: assets['images']
                                                    ['review'],
                                                label: 'Reviews',
                                                iconColor: Colors
                                                    .deepPurpleAccent.shade700,
                                              ),
                                              Reviews(
                                                data: details.reviews,
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    similarMoviesCard.length != 0
                                        ? SectionTitle(
                                            imageUrl: assets['images']
                                                ['similar'],
                                            label: 'Similar Movies',
                                            iconColor:
                                                Colors.orangeAccent.shade700,
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            isMovieDetailsLoading
                ? Container()
                : similarMoviesCard.length != 0
                    ? Container(
                        height: 310,
                        child: ListView(
                          physics: AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: similarMoviesCard,
                        ),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
