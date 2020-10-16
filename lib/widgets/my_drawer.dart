import 'package:animator/animator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glowblow/pages/about.dart';
import 'package:glowblow/widgets/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Animator(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 3),
              cycles: 0,
              builder: (anim) => Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(28),
                        bottomLeft: Radius.circular(28)),
                    gradient: LinearGradient(
                        end: Alignment.bottomRight,
                        begin: Alignment.topLeft,
                        stops: [
                          anim.value - 0.4,
                          anim.value - 0.2,
                          anim.value,
                          anim.value + 0.2,
                          anim.value + 0.4,
                        ],
                        colors: [
                          Colors.redAccent.withOpacity(0.3),
                          Colors.pinkAccent.withOpacity(0.3),
                          Colors.purpleAccent.withOpacity(0.3),
                          Colors.deepPurpleAccent.withOpacity(0.3),
                          Colors.blueAccent.withOpacity(0.3),
                        ])),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Image.asset(
                        'assets/images/glowblow1.png',
                        height: 100,
                        width: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Forol GlowBlow Painter',
                            style: TextStyle(
                                fontFamily: 'pac',
                                fontSize: 20,
                                color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              leading: new Icon(FontAwesomeIcons.infoCircle,
                  color: Colors.pinkAccent),
              title: Text(
                "About",
                style: normalTextStyle,
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, About.id);
              },
            ),
//            ListTile(
//              leading: Icon(OMIcons.info,
//                  color: Colors.purpleAccent),
//              title: Text(
//                "How To Use",
//                style: normalTextStyle,
//              ),
//              onTap: () {
//                Navigator.popAndPushNamed(context, HowToUse.id);
//              },
//            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.googlePlay,
                color: Colors.blueAccent,
                size: 18,
              ),
              title: Text(
                "Other Apps",
                style: normalTextStyle,
              ),
              onTap: () {
                launchUrl(
                    'https://play.google.com/store/search?q=pub%3AForol&c=apps&hl=en');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'could not open';
    }
  }
}
