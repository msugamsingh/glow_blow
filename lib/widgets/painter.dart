import 'dart:ui';

import 'package:flutter/material.dart';

import '../pages/drawing_home.dart';

class Sketcher extends CustomPainter {
  final List<MapEntry<Path, Paint>> points;
  final bool multicolor;

  Sketcher(this.points, this.multicolor);

  @override
  void paint(Canvas canvas, Size size) {
    if (multicolor) {
      for (MapEntry<Path, Paint> path in points) {
        Paint p = path.value;
        canvas.drawPath(
            path.key,
            Paint()
              ..color = globalPenColor
              ..strokeWidth = p.strokeWidth
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.round);
      }
    } else {
      for (MapEntry<Path, Paint> path in points) {
        Paint p = path.value;
        canvas.drawPath(path.key, p);
      }
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return true;
  }
}

class ExampleSketch extends CustomPainter {

  ExampleSketch();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
        Offset(70, 50),
        Offset(210, 50),
        Paint()
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 8
          ..color = Colors.purple
          ..shader = LinearGradient(colors: [Colors.purple, Colors.redAccent])
              .createShader(Rect.fromPoints(Offset(70, 50), Offset(210, 50)))
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(ExampleSketch oldDelegate) {
    return true;
  }
}

/*class SketcherTwo extends CustomPainter {
  final List<Offset> points;

  SketcherTwo(this.points);

  @override
  void paint(Canvas canvas, Size size) {

    Paint paint = Paint()
      ..color = Colors.pinkAccent
      ..strokeWidth = 6;
    Paint paint2 = Paint()
      ..color = Colors.white;

//    canvas.saveLayer(Offset.zero & size, Paint());
//    for (Path path in points) {
//      canvas.drawPath(path, paint);
//    }
//    canvas.drawRect(
//        new Rect.fromLTWH(0.0, 0.0, size.width, size.height), paint2);
//    canvas.restore();

      for (var i = 0; i < points.length - 1; i++) {
        if (points[i] != null && points[i + 1] != null) {
//          canvas.drawLine(points[i]-Offset(0,9), points[i + 1] - Offset(0, 9), paint2);
          canvas.drawLine(points[i], points[i + 1], paint);
//          canvas.drawLine(points[i], points[i + 1], paint2);
//          canvas.drawLine(points[i]+Offset(0,9), points[i + 1] + Offset(0, 9), paint2);
        }
      }
//
//    canvas.drawLine(Offset(150, 150), Offset(100, 100), paint2);

//    canvas.drawLine(Offset(150, 150), Offset(100, 100), paint);
  }

  @override
  bool shouldRepaint(SketcherTwo  oldDelegate) {
    return true;
//    return oldDelegate.points != points;
  }
}*/

