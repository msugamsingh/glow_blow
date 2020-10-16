import 'dart:async';

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:glowblow/pages/drawing_home.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'spalsh_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  goHome() {
    Timer(Duration(seconds: 3), () {
      Navigator.popAndPushNamed(context, DrawingHome.id);
    });
  }

  @override
  void initState() {
    super.initState();
    goHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 200),
            Animator(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              builder: (anim) {
                return Image.asset(
                  'assets/images/glowblow1.png',
                  height: anim.value * 200,
                  width: anim.value * 200,
                );
              },
            ),
            Spacer(),
            Text(
              'Forol GlowBlow Painter',
              style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontSize: 28,
                  fontFamily: 'pac',
                  shadows: [
                    Shadow(
                      color: Colors.purpleAccent[100],
                      blurRadius: 40,
                      offset: Offset(0, 4),
                    )
                  ]),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
