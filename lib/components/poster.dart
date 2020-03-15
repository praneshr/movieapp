import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:transparent_image/transparent_image.dart';

class Poster extends StatelessWidget {
  String placeholderPosterUrl;
  String posterUrl;
  bool isLarge;
  bool isThumbnail;

  Poster({
    this.placeholderPosterUrl,
    this.posterUrl,
    this.isLarge = false,
    this.isThumbnail = false,
  });

  @override
  Widget build(BuildContext context) {
    double width = 140;
    double height = 213;
    double borderRadius = 16;
    if (isThumbnail) {
      width = 50;
      height = 60;
      borderRadius = 8;
    } else if (isLarge) {
      width = 170;
      height = 250;
    }
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: ProgressiveImage.memoryNetwork(
          placeholder: kTransparentImage,
          thumbnail: placeholderPosterUrl,
          image: posterUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
