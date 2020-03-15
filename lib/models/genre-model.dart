class GenreModel {
  String name;
  int id;

  GenreModel.fromJSON({this.id, this.name});
}

class GenreListModel {
  List<GenreModel> genres = [];

  GenreListModel.fromJSON(dynamic genreList) {
    if (genreList is List) {
      genreList.forEach((genreInfo) {
        GenreModel genre = GenreModel.fromJSON(
          id: genreInfo['id'],
          name: genreInfo['name'],
        );
        genres.add(genre);
      });
    }
  }

  String getGenreName(int id) {
    if (genres.length == 0) {
      return null;
    }
    List<GenreModel> matchingGenre =
        genres.where((genre) => genre.id == id).toList();
    if (matchingGenre.length == 1) {
      return matchingGenre[0].name;
    }
    return null;
  }

  List<String> getGenreNames(List ids) {
    if (genres.length == 0) {
      return null;
    }
    List<String> genresList = [];
    ids.forEach((id) {
      String name = getGenreName(id);
      genresList.add(name);
    });
    return genresList;
  }
}
