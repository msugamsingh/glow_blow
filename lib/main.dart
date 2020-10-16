import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glowblow/pages/about.dart';
import 'package:glowblow/pages/control_animations.dart';
import 'package:glowblow/pages/drawing_home.dart';
import 'package:glowblow/pages/splash_screen.dart';
import 'package:glowblow/paint_model.dart';
import 'package:scoped_model/scoped_model.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.light,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

PaintModel paintModel = PaintModel();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<PaintModel>(
      model: paintModel,
      child: MaterialApp(
        title: 'Glow Blow',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.white,
          accentColor: Colors.blueAccent,
          appBarTheme: AppBarTheme(
              brightness: Brightness.light,
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.pinkAccent),
              actionsIconTheme: IconThemeData(color: Colors.blueAccent)),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.grey[100],
            contentTextStyle: TextStyle(
                color: Colors.blueGrey[800],
                fontFamily: 'pac',
                fontWeight: FontWeight.w300,
                fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          DrawingHome.id: (context) => DrawingHome(),
          ControlAnimations.id: (context) => ControlAnimations(),
          About.id: (context) => About(),
//          HowToUse.id: (context) => HowToUse(),
          SplashScreen.id: (context) => SplashScreen(),
//          CanvasTwo.id: (context) => CanvasTwo(),
        },
        initialRoute: SplashScreen.id,
      ),
    );
  }
}

