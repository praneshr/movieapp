import 'package:myapp/constants.dart';
import 'package:myapp/models/genre-model.dart';

class MovieModel {
  String title;
  String posterUrl;
  String placeholderPosterUrl;
  num rating;
  int id;
  String bannerUrl;
  String placeholderBannerUrl;
  String overview;
  List<String> genres;
  String year;

  MovieModel.fromJSON({
    this.title,
    this.posterUrl,
    this.rating,
    this.placeholderPosterUrl,
    this.id,
    this.bannerUrl,
    this.placeholderBannerUrl,
    this.overview,
    this.genres,
    this.year,
  });
}

class MovieListModel {
  List<MovieModel> movies = [];

  MovieListModel.fromJSON(dynamic movieList, GenreListModel genres) {
    if (movieList is List) {
      movieList.forEach((movieInfo) {
        if (movieInfo['poster_path'] != null) {
          MovieModel movie = MovieModel.fromJSON(
            title: movieInfo['title'],
            posterUrl: imageUrl(
              movieInfo['poster_path'],
              ImageTypes.POSTER,
            ),
            rating: ((movieInfo['vote_average'] / 2) as num).round(),
            id: movieInfo['id'],
            bannerUrl: imageUrl(
              movieInfo['backdrop_path'],
              ImageTypes.BACKDROP,
            ),
            placeholderBannerUrl: placeholderImageUrl(
              movieInfo['backdrop_path'],
              ImageTypes.BACKDROP,
            ),
            placeholderPosterUrl: placeholderImageUrl(
              movieInfo['poster_path'],
              ImageTypes.POSTER,
            ),
            overview: movieInfo['overview'],
            genres: genres.getGenreNames(movieInfo['genre_ids']),
            year: movieInfo['release_date'].toString().split('-')[0],
          );
          movies.add(movie);
        }
      });
    }
  }
}
