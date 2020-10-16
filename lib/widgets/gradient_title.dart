import 'package:flutter/material.dart';

class GradientTitle extends StatelessWidget {
  final String title;
  final double size;

  const GradientTitle(
      {Key key, this.title, this.size=20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
              colors: [
            Colors.redAccent,
            Colors.pinkAccent,
            Colors.purpleAccent,
            Colors.deepPurpleAccent,
            Colors.blueAccent,
          ]).createShader(bounds);
        },
        child: Text(
          title,
          style: TextStyle(
            fontSize: size,
            fontFamily: 'pac',
          ),
        ));
  }
}
