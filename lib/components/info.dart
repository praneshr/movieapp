import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  String label;
  String value;
  bool mini;

  Info({
    this.label,
    this.value,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Text(
              label.toUpperCase(),
              maxLines: 1,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontSize: mini ? 18 : 38,
              height: mini ? 1.3 : 1,
              fontWeight: mini ? FontWeight.w400 : FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
