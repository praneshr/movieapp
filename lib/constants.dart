import 'dart:core';

final String apiKey = '498782bfe8f76a62297d11aca7c8693c';
final String host = 'https://api.themoviedb.org/3';
final String networkImageHost = 'http://image.tmdb.org/t/p';

enum ImageTypes {
  POSTER,
  BACKDROP,
  LOGO,
  PROFILE,
  STILL,
}

/// Screen enums
enum Screens {
  MOVIE,
  TV,
  ARTIST,
  SEARCH,
  GENRE,
}

final Map<ImageTypes, String> lowResImageSize = {
  ImageTypes.BACKDROP: 'w300',
  ImageTypes.LOGO: 'w45',
  ImageTypes.POSTER: 'w92',
  ImageTypes.PROFILE: 'w45',
  ImageTypes.STILL: 'w92',
};

final Map<ImageTypes, String> highResImageSize = {
  ImageTypes.BACKDROP: 'w1280',
  ImageTypes.LOGO: 'w500',
  ImageTypes.POSTER: 'w500',
  ImageTypes.PROFILE: 'w632',
  ImageTypes.STILL: 'w300',
};

/// Mapping for all assets.
final Map<String, Map<String, String>> assets = {
  'images': {
    'movie': 'lib/assets/4x/movie-reel@4x.png',
    'tv': 'lib/assets/4x/vintage-tv@4x.png',
    'artist': 'lib/assets/4x/theater@4x.png',
    'search': 'lib/assets/4x/search@4x.png',
    'play': 'lib/assets/4x/small-triangle-right@4x.png',
    'close': 'lib/assets/4x/i-remove@4x.png',
    'trending': 'lib/assets/4x/trend-up@4x.png',
    'heart': 'lib/assets/4x/heart@4x.png',
    'star': 'lib/assets/4x/star@4x.png',
    'starOutline': 'lib/assets/4x/star-outline@4x.png',
    'show': 'lib/assets/4x/show@4x.png',
    'back': 'lib/assets/4x/small-left@4x.png',
    'similar': 'lib/assets/4x/bahai@4x.png',
    'review': 'lib/assets/4x/b-meeting@4x.png',
    'notFound': 'https://i.ibb.co/HKmCqPw/image-2-4x.png',
  },
};

final Map<String, Function> urls = {
  'discoverMovie': () => '/discover/movie',
  'movieVideos': (int id) => '/movie/$id/videos',
  'trendingMovieWeek': () => '/trending/movie/day',
  'genre': () => '/genre/movie/list',
  'nowPlaying': () => '/movie/now_playing',
  'movieDetails': (int id) => '/movie/$id',
  'movieSearch': () => '/search/movie',
};

String addHostAndApiKey(String url, [String query = '']) {
  return '$host$url?api_key=$apiKey${query ?? '&$query'}';
}

String placeholderImageUrl(String path, ImageTypes type) {
  if (path == null) {
    return assets['images']['notFound'];
  }
  return '$networkImageHost/${lowResImageSize[type]}/$path';
}

String imageUrl(String path, ImageTypes type) {
  if (path == null) {
    return assets['images']['notFound'];
  }
  return '$networkImageHost/${highResImageSize[type]}/$path';
}
