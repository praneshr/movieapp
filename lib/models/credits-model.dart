import 'package:myapp/constants.dart';

class CreditsModel {
  String name;
  String character;
  String posterUrl;
  String placeholderPosterUrl;
  num id;

  CreditsModel({
    this.character,
    this.id,
    this.name,
    this.placeholderPosterUrl,
    this.posterUrl,
  });
}

class CreditsListModel {
  List<CreditsModel> casts = [];

  CreditsListModel.fromJSON(dynamic data) {
    if (data is List) {
      data.forEach((creditInfo) {
        casts.add(
          CreditsModel(
            character: creditInfo['character'],
            id: creditInfo['id'],
            name: creditInfo['name'],
            placeholderPosterUrl: placeholderImageUrl(
              creditInfo['profile_path'],
              ImageTypes.STILL,
            ),
            posterUrl: imageUrl(
              creditInfo['profile_path'],
              ImageTypes.STILL,
            ),
          ),
        );
      });
    }
  }
}
