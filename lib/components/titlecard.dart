import 'package:flutter/material.dart';
import 'package:myapp/components/poster.dart';
import 'package:myapp/components/ratings.dart';
import 'package:myapp/models/movie-model.dart';
import 'package:myapp/screens/movie-details.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:transparent_image/transparent_image.dart';

class TitleCard extends StatefulWidget {
  MovieModel data;
  int index;
  Function onTap;

  TitleCard({this.data, this.index, this.onTap});

  @override
  _TitleCardState createState() => _TitleCardState();
}

class _TitleCardState extends State<TitleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(
        right: 16,
        top: 5,
        left: widget.index == 0 ? 16 : 0,
      ),
      child: GestureDetector(
        onTap: () {
          widget.onTap(widget.data);
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Poster(
              posterUrl: widget.data.posterUrl,
              placeholderPosterUrl: widget.data.placeholderPosterUrl,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.data.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: 18,
                      height: 1.3,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      widget.data.genres[0],
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: Colors.black26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Ratings(
                    rating: widget.data.rating,
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
