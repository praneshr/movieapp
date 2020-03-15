import 'package:flutter/material.dart';
import 'package:myapp/models/movie-details-model.dart';

class Reviews extends StatefulWidget {
  List<ReviewModel> data;

  Reviews({this.data});

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    List<Widget> columns = [];
    widget.data.forEach((review) {
      int index = widget.data.indexOf(review);
      columns.add(
        Container(
          // margin: EdgeInsets.only(bottom: 0, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: Text(
                  review.author,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Text(
                review.content,
                maxLines: 9,
                style: TextStyle(
                  height: 1.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              index < widget.data.length - 1
                  ? Divider(
                      height: 32,
                    )
                  : Container(),
            ],
          ),
        ),
      );
    });
    return Container(
      child: Column(
        children: columns,
      ),
    );
  }
}
