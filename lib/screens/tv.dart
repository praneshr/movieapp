import 'package:flutter/material.dart';

class Tv extends StatefulWidget {
  Map<String, Object> state;
  Function updateState;

  Tv({this.state, this.updateState});

  @override
  _TvState createState() => _TvState();
}

class _TvState extends State<Tv> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Tv screen'),
    );
  }
}
