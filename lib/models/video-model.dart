class VideoModel {
  String id;
  String type;
  String site;

  VideoModel.fromJSON({this.id, this.site, this.type});
}

class VideoModelList {
  List<VideoModel> videos = [];

  VideoModelList.fromJSON(dynamic videoList) {
    if (videoList is List) {
      videoList.forEach((videoInfo) {
        VideoModel video = VideoModel.fromJSON(
          id: videoInfo['key'],
          site: videoInfo['site'],
          type: videoInfo['type'],
        );
        videos.add(video);
      });
    }
  }
}
