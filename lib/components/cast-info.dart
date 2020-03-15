import 'package:flutter/material.dart';
import 'package:myapp/components/poster.dart';
import 'package:myapp/models/credits-model.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:transparent_image/transparent_image.dart';

class CastInfo extends StatefulWidget {
  final List<CreditsModel> data;

  CastInfo({this.data});

  @override
  _CastInfoState createState() => _CastInfoState();
}

class _CastInfoState extends State<CastInfo> {
  int maxListCount = 7;

  void onClick() {
    setState(() {
      maxListCount = widget.data.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columns = [];

    for (var i = 0; i < maxListCount; i++) {
      CreditsModel data = widget.data[i];
      columns.add(
        Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Row(
            children: <Widget>[
              Poster(
                placeholderPosterUrl: data.placeholderPosterUrl,
                posterUrl: data.posterUrl,
                isThumbnail: true,
              ),
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        data.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      data.character,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                        fontWeight: FontWeight.w500,
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
    return Container(
      child: Column(
        children: columns,
      ),
    );
  }
}
