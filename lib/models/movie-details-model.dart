import 'package:myapp/models/credits-model.dart';
import 'package:myapp/models/genre-model.dart';
import 'package:myapp/models/movie-model.dart';

class MovieDetailsModel {
  int runtime;
  String status;
  List<CreditsModel> cast;
  List<MovieModel> similar;
  List<ReviewModel> reviews;

  MovieDetailsModel.fromJSON(dynamic data, GenreListModel genres) {
    runtime = data['runtime'];
    status = data['status'];
    CreditsListModel credits =
        CreditsListModel.fromJSON(data['credits']['cast']);
    var similarMovies =
        MovieListModel.fromJSON(data['similar']['results'], genres);
    cast = credits.casts;
    similar = similarMovies.movies;
    var reviewsList = ReviewListModelList.fromJSON(data['reviews']['results']);
    reviews = reviewsList.reviews;
  }
}

class ReviewModel {
  String content;
  String author;

  ReviewModel({this.author, this.content});
}

class ReviewListModelList {
  List<ReviewModel> reviews = [];
  ReviewListModelList.fromJSON(dynamic data) {
    if (data is List) {
      data.forEach((review) {
        reviews.add(
          ReviewModel(
            author: review['author'],
            content: review['content'],
          ),
        );
      });
    }
  }
}
