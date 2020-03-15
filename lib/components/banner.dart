import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myapp/components/poster.dart';
import 'package:myapp/components/ratings.dart';
import 'dart:convert' as convert;
import 'package:myapp/constants.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/models/movie-model.dart';
import 'package:myapp/models/video-model.dart';
import 'package:myapp/screens/search.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Banner extends StatefulWidget {
  final MovieModel data;
  final bool isDetailsPage;

  Banner({
    this.data,
    this.isDetailsPage = false,
  });

  @override
  _BannerState createState() => _BannerState();
}

class _BannerState extends State<Banner> {
  bool loading = false;
  bool playTrailer = false;
  YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
  }

  void setLoadingState(bool state) {
    setState(() {
      loading = state;
    });
  }

  void clearYoutubePlayer([YoutubeMetaData data]) {
    if (controller != null) {
      controller.dispose();
      setState(() {
        controller = null;
      });
    }
  }

  void goBack() {
    Navigator.pop(context);
  }

  void movieInfo() async {
    setLoadingState(true);
    print(addHostAndApiKey(urls['movieVideos'](widget.data.id)));
    http.Response response = await http.get(
      addHostAndApiKey(urls['movieVideos'](widget.data.id)),
    );
    if (response.statusCode == 200) {
      var responseJson = convert.jsonDecode(response.body);
      VideoModelList result = VideoModelList.fromJSON(responseJson['results']);
      var video = result.videos
          .where((video) => video.site == 'YouTube' && video.type == 'Trailer')
          .toList();
      if (video.length > 0) {
        controller = YoutubePlayerController(
          initialVideoId: video[0].id,
          flags: YoutubePlayerFlags(
            mute: false,
            autoPlay: true,
            forceHideAnnotation: true,
            controlsVisibleAtStart: true,
          ),
        );
      }
    } else {
      print(response.statusCode);
    }
    setLoadingState(false);
  }

  @override
  Widget build(BuildContext context) {
    double bannerHeight =
        widget.isDetailsPage ? MediaQuery.of(context).size.height + 20 : 400;
    Widget roundedCorner = Container(
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    );

    if (controller != null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: bannerHeight - 20.0,
              child: YoutubePlayer(
                controller: controller,
                onEnded: clearYoutubePlayer,
                thumbnailUrl: widget.data.bannerUrl,
                actionsPadding: EdgeInsets.all(10),
                topActions: <Widget>[
                  Expanded(
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 90, left: 0),
                      child: FloatingActionButton(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        onPressed: clearYoutubePlayer,
                        child: Image.asset(
                          assets['images']['close'],
                          width: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
                showVideoProgressIndicator: false,
                aspectRatio: 16 / 9,
              ),
            ),
            roundedCorner,
          ],
        ),
      );
    }

    return Stack(
      children: <Widget>[
        ProgressiveImage.memoryNetwork(
          placeholder: kTransparentImage,
          thumbnail: widget.data.placeholderBannerUrl,
          image: widget.data.bannerUrl,
          width: double.infinity,
          height: bannerHeight,
          fit: BoxFit.cover,
        ),
        Container(
          height: bannerHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black12, Colors.black],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SafeArea(
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: widget.isDetailsPage
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FloatingActionButton(
                              backgroundColor: Colors.white,
                              heroTag: 'BackButton',
                              mini: true,
                              child: Image.asset(
                                assets['images']['back'],
                                width: 32,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: goBack,
                            ),
                            FloatingActionButton(
                              backgroundColor: Colors.white,
                              heroTag: 'searchButton',
                              mini: true,
                              child: Image.asset(
                                assets['images']['search'],
                                width: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/search');
                              },
                            ),
                          ],
                        )
                      : null,
                ),
              ),
              Container(
                child: FloatingActionButton(
                  child: loading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Image.asset(
                            assets['images']['play'],
                            width: 40,
                            color: Colors.white,
                          ),
                        ),
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: loading ? null : movieInfo,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        widget.isDetailsPage
                            ? Container(
                                margin: EdgeInsets.only(bottom: 16),
                                child: Poster(
                                  placeholderPosterUrl:
                                      widget.data.placeholderPosterUrl,
                                  posterUrl: widget.data.posterUrl,
                                  isLarge: widget.isDetailsPage,
                                ),
                              )
                            : Container(),
                        Text(
                          widget.data.title,
                          maxLines: widget.isDetailsPage ? 3 : 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 5),
                          child: Ratings(
                            rating: widget.data.rating,
                          ),
                        ),
                        widget.isDetailsPage
                            ? Container(
                                margin: EdgeInsets.only(
                                  bottom: 8,
                                ),
                                child: Text(
                                  widget.data.genres.join(', '),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : Container(),
                        widget.isDetailsPage
                            ? Container()
                            : Text(
                                widget.data.overview,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                      ],
                    ),
                  ),
                  controller != null ? Container() : roundedCorner,
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
