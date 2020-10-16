import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glowblow/widgets/constants.dart';
import 'package:glowblow/widgets/gradient_title.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  static const String id = 'about';

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GradientTitle(
          title: 'About',
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.2),
                        offset: Offset(0, 4),
                        blurRadius: 50),
                    BoxShadow(
                        color: Colors.deepPurpleAccent.withOpacity(0.2),
                        offset: Offset(0, -8),
                        blurRadius: 50),
                  ],
                  color: Colors.white,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/glowblow1.png',
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Forol GlowBlow Painter',
                style: TextStyle(
                    color: Colors.blueGrey[800],
                    fontFamily: 'pac',
                    fontSize: 18),
              ),
              Text(
                'Version: 1.0.0',
                style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 38),
                child: Card(
                  elevation: 28,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  shadowColor: Colors.blueGrey.withOpacity(0.4),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/myavatar.png'),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text('Sugam Singh', style: normalTextStyle),
                    subtitle: Text('Android & iOS Developer'),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.twitter,
                      ),
                      onPressed: () {
                        launchUrl('https://www.twitter.com/MSugamSingh');
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.instagram,
                      ),
                      onPressed: () {
                        launchUrl('https://www.instagram.com/msugamsingh');
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.mail,
                        size: 28,
                      ),
                      onPressed: () {
                        launchUrl('mailto:singhsugam065@gmail.com');
                      },
                    ),
                  ],
                ),
              ),
              Text(
                'Made with ❤️ by Sugam Singh',
                style: TextStyle(
                    color: Colors.blueGrey[800],
                    fontFamily: 'pac',
                    fontSize: 18),
              ),
              SizedBox(height: 10),
            ],
          ),
        ],
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
