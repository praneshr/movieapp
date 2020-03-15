import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  String imageUrl;
  String label;
  Color iconColor;

  SectionTitle({
    this.imageUrl,
    this.label,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:16, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Image.asset(
            imageUrl,
            width: 22,
            color: iconColor,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
