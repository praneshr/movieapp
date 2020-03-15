import 'package:flutter/material.dart';
import 'package:myapp/constants.dart';

class Ratings extends StatelessWidget {
  final num rating;
  final num maxRating;

  Ratings({this.rating, this.maxRating = 5});

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    for (var i = 0; i < maxRating; i++) {
      Widget star;
      if (i < rating) {
        star = Image.asset(
          assets['images']['star'],
          width: 12,
          color: Colors.yellow.shade700,
        );
      } else {
        star = Image.asset(
          assets['images']['starOutline'],
          width: 12,
          color: Colors.yellow.shade700,
        );
      }
      stars.add(star);
    }

    return Container(
      child: Row(
        children: stars,
      ),
    );
  }
}
