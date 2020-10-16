import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show radians;

class RadialMenu extends StatefulWidget {
  final Function onRefreshTap;
  final Function onUndoTap;
  final Function onPaintTap;

  const RadialMenu(
      {Key key, this.onRefreshTap, this.onUndoTap, this.onPaintTap})
      : super(key: key);

  @override
  _RadialMenuState createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return RadialAnimation(
      controller: controller,
      onPaintTap: widget.onPaintTap,
      onRefreshTap: widget.onRefreshTap,
      onUndoTap: widget.onUndoTap,
    );
  }
}

class RadialAnimation extends StatelessWidget {
  final Function onRefreshTap;
  final Function onUndoTap;
  final Function onPaintTap;
  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> translation;
  final Animation<double> rotation;

  RadialAnimation(
      {this.controller, this.onRefreshTap, this.onUndoTap, this.onPaintTap})
      : scale = Tween<double>(
          begin: 1.5,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeOutCubic,
          ),
        ),
        translation = Tween<double>(
          begin: 0,
          end: 80,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeOutCubic,
          ),
        ),
        rotation = Tween<double>(
          begin: 0,
          end: 0, // Make it 360 for rotation animation
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              1,
              curve: Curves.easeOut,
            ),
          ),
        );

  _close() => controller.reverse();

  _open() => controller.forward();

  _buildButton(double angle, BuildContext context,
      {Color color, IconData icon, String heroTag, Function onClick}) {
    final double rad = radians(angle);
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          (translation.value) * cos(rad),
          (translation.value) * sin(rad),
        ),
      child: FloatingActionButton(
        mini: true,
        heroTag: heroTag,
        child: Icon(icon),
        backgroundColor: color,
        onPressed: onClick,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, builder) {
        return Transform.rotate(
          angle: radians(rotation.value),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildButton(225, context,
                  color: Colors.orangeAccent,
                  icon: Icons.refresh,
                  heroTag: 'google',
                  onClick: () {
                print('called here');
                onRefreshTap();
                  }),
              _buildButton(270, context,
                  color: Colors.redAccent,
                  icon: Icons.palette,
                  heroTag: 'guest', onClick: onPaintTap),
              _buildButton(180, context,
                  color: Colors.purpleAccent,
                  icon: Icons.undo,
                  heroTag: 'phone', onClick: onUndoTap),
              Transform.scale(
                scale: scale.value - 1, // -1 = 1 in scale
                child: FloatingActionButton(
                  mini: true,
                  heroTag: 'close',
                  child: Icon(Icons.clear),
                  onPressed: _close,
                ),
              ),
              Transform.scale(
                scale: scale.value,
                child: FloatingActionButton(
                  mini: true,
                  heroTag: 'open',
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.touch_app,
                    color: Colors.pinkAccent,
                  ),
                  onPressed: _open,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
