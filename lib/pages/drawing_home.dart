import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:animator/animator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glowblow/pages/control_animations.dart';
import 'package:glowblow/pages/view_image.dart';
import 'package:glowblow/paint_model.dart';
import 'package:glowblow/widgets/constants.dart';
import 'package:glowblow/widgets/custom_icon.dart';
import 'package:glowblow/widgets/my_drawer.dart';
import 'package:glowblow/widgets/painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:painter/painter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vector_math/vector_math.dart' show radians;

Color globalPenColor = Colors.pinkAccent;

class DrawingHome extends StatefulWidget {
  static const String id = 'drawing_home';

  @override
  _DrawingHomeState createState() => _DrawingHomeState();
}

class _DrawingHomeState extends State<DrawingHome>
    with TickerProviderStateMixin {
  PainterController painterController;
  AnimationController _animationController;
  AnimationController _animationController2;

  Animation _animation;
  Animation<double> scale;
  Animation<double> translation;
  Animation<double> rotation;
  Animation<double> translateTopBar;

  bool _multiColor = false;
  bool _gradient = false;
  bool _animate = false;

//  bool _finished = false;
//  bool _shouldGlow = false;
  bool _hide = false;
  bool recording = false;
  bool startRecording = false;
  File img;
  File importedImage;

  double _topBarPadding = 0;

//  double appBarHeight = AppBar().preferredSize.height;
  double opacityValue = 1;
  String _platformVersion = 'Unknown';

  final GlobalKey scKey = GlobalKey();

  GlobalKey<ScaffoldState> drawingKey = GlobalKey<ScaffoldState>();

//  final snapKey = GlobalKey<SnappableState>();
  ScreenshotController screenshotController = ScreenshotController();

  Future<bool> requestPermissions() async {
//    if (await Permission.storage.isUndetermined) Permission.storage.request();
//    if (await Permission.photos.isUndetermined) Permission.photos.request();
//    if (await Permission.storage.isGranted) return true;
    await Permission.storage.request();
//    print(await Permission.storage.isGranted);
    return await Permission.storage.isGranted;
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      platformVersion = await FlutterScreenRecording.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  showSnackBar(String text) {
    drawingKey.currentState.showSnackBar(SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
    ));
  }

  Future<bool> startScreenRecord() async {
    String name = DateTime.now().toIso8601String();
    bool start = await FlutterScreenRecording.startRecordScreen(name);
    if (start) {
      setState(() {
        recording = !recording;
        startRecording = true;
//        textBtn = (recording) ? "Stop" : "Play";
      });
    }
    return start;
  }

  stopScreenRecord() async {
    String path = await FlutterScreenRecording.stopRecordScreen;
    setState(() {
      recording = !recording;
      startRecording = false;
    });
    showSnackBar('Video Saved at $path');
//    print("Opening video");
//    print(path);
//    OpenFile.open(path);
  }

  @override
  void initState() {
    painterController = _newController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {
          if (_animate) {
            if (_animation.value < 0.5)
              opacityValue = 0;
            else
              opacityValue = 1;
          }

          if (_multiColor) {
            if (_animation.value < 0.2)
              globalPenColor = Colors.blueAccent;
            else if (_animation.value < 0.4)
              globalPenColor = Colors.pinkAccent;
            else if (_animation.value < 0.6)
              globalPenColor = Colors.purpleAccent;
            else if (_animation.value < 0.8)
              globalPenColor = Colors.deepPurpleAccent;
            else if (_animation.value <= 1)
              globalPenColor = Colors.redAccent;
            else
              globalPenColor = Colors.blueGrey;
          }
        });
      });
    _animationController2 =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);
    scale = Tween<double>(
      begin: 1.5,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController2,
        curve: Curves.easeOutCubic,
      ),
    );
    translation = Tween<double>(
      begin: 0,
      end: 80,
    ).animate(
      CurvedAnimation(
        parent: _animationController2,
        curve: Curves.easeOutCubic,
      ),
    );
    rotation = Tween<double>(
      begin: 0,
      end: 0, // Make it 360 for rotation animation
    ).animate(CurvedAnimation(
      parent: _animationController2,
      curve: Interval(
        0.0,
        1,
        curve: Curves.easeOut,
      ),
    ));

    requestPermissions();

    initPlatformState();

    screenshotController.capture(
      pixelRatio: 0.1,
    );
    super.initState();
  }

  PainterController _newController() {
    PainterController controller = new PainterController(context: context);
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    controller.drawColor = Colors.pink;
    return controller;
  }

  _close() => _animationController2.reverse();

  _open() => _animationController2.forward();

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

  _showColorPickerDialog() {
    showDialog(
        context: drawingKey.currentContext,
        builder: (BuildContext context) {
          return StatefulBuilder(builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
                elevation: 36,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Container(
                  height: 350,
                  child: Column(
                    children: <Widget>[
                      MaterialColorPicker(
                        shrinkWrap: true,
                        selectedColor: painterController.drawColor,
                        onColorChange: (Color color) {
                          painterController.drawColor = color;
                        },
                      ),
                      CheckboxListTile(
                        title: Text(
                          'Gradient',
                          style: TextStyle(
                              fontFamily: 'pac', color: Colors.blueGrey[800]),
                        ),
                        onChanged: (bool value) {
                          print(value);
                          setState(() {
                            _gradient = !_gradient;
//                            painterController.buildContext = context;
                            painterController.gradient = _gradient;
                          });
                        },
                        value: _gradient,
                      ),
//                      CheckboxListTile(
//                        title: Text(
//                          'MultiColor',
//                          style: TextStyle(
//                              fontFamily: 'pac', color: Colors.blueGrey[800]),
//                        ),
//                        onChanged: (bool value) {
//                          print(value);
//                          setState(() {
//                            _multiColor = !_multiColor;
//                          });
//                        },
//                        value: _multiColor,
//                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
//                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
//                          SizedBox(width: 10),
//                          FlatButton(
//                            child: Text(
//                              'Cancel',
//                              style: TextStyle(
//                                fontFamily: 'pac',
//                                fontSize: 18,
//                                color: Colors.blueGrey,
//                              ),
//                            ),
//                            onPressed: () {
//                              Navigator.pop(context);
//                            },
//                          ),
                          FlatButton(
                            child: Text(
                              'Done',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'pac',
                                color: Colors.blueAccent,
                              ),
                            ),
                            onPressed: () {
//                              setState(() {
//                                globalPenColor = _colorPicker;
//                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
          });
        });
  }

  Widget floatingButton() => AnimatedBuilder(
        animation: _animationController2,
        builder: (context, builder) {
          return Transform.rotate(
            angle: radians(rotation.value),
            child: Container(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  _buildButton(225, context,
                      color: Colors.orangeAccent,
                      icon: Icons.refresh,
                      heroTag: 'google', onClick: () {
                    if (!painterController.isEmpty) painterController.clear();
                  }),
                  _buildButton(270, context,
                      color: Colors.redAccent,
                      icon: Icons.palette,
                      heroTag: 'guest', onClick: () {
                    _showColorPickerDialog();
                  }),
                  _buildButton(180, context,
                      color: Colors.purpleAccent,
                      icon: Icons.undo,
                      heroTag: 'phone', onClick: () {
                    if (!painterController.isEmpty) painterController.undo();
                  }),
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
            ),
          );
        },
      );

  timer(duration, bool b) {
    Timer(Duration(seconds: duration), () {
      if (b) {
        stopScreenRecord();
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        setState(() {
          _hide = false;
          _multiColor = false;
        });
      }
      setState(() {
        _animate = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget appBarTitle = !_hide
        ? AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: Icon(CustomIcons.menu),
              onPressed: () {
                drawingKey.currentState.openDrawer();
              },
            ),
            actions: <Widget>[
              ScopedModelDescendant<PaintModel>(
                builder:
                    (BuildContext context, Widget child, PaintModel model) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      child: Icon(OMIcons.videocam),
                      onTap: () async {
                        setState(() {
                          _hide = true;
                        });
                        SystemChrome.setEnabledSystemUIOverlays(
                            []); // Remove stuff
//                        await requestPermissions();
                        if (await requestPermissions())
                          await startScreenRecord();
                        else {
                          !await Permission.storage.isPermanentlyDenied
                              ? Permission.storage.request()
                              : showSnackBar('Please Grant Permission 🙁');
                        }
//                        await startScreenRecord();
                        if (startRecording) {
                          setState(() {
                            _multiColor = model.multiColor;
                            _animate = true;
                          });
                          timer(model.videoDuration, true);
                        } else {
                          SystemChrome.setEnabledSystemUIOverlays(
                              SystemUiOverlay.values);
                          setState(() {
                            _hide = false;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
              PopupMenuButton(
                elevation: 36,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                onSelected: (int v) async {
                  if (v == 1) {
                    await screenshotController.capture().then((File image) {
                      setState(() {
                        img = image;
                      });
                    }).catchError((onError) {
                      print(onError);
                    });
                    if (img != null)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewImage(
                            picture: img,
                          ),
                        ),
                      );
                  } else if (v == 2) {
                    PickedFile file = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    if (file != null) {
                      setState(() {
                        importedImage = File(file.path);
                      });
                    }
                  } else if (v == 3) {
                    setState(() {
                      importedImage = null;
                    });
                  } else {
                    Navigator.pushNamed(context, ControlAnimations.id);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            OMIcons.photo,
                            color: Colors.pinkAccent,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Export As Image',
                            style: normalTextStyle,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            OMIcons.addPhotoAlternate,
                            color: Colors.deepPurpleAccent,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Import Image',
                            style: normalTextStyle,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            OMIcons.brokenImage,
                            color: Colors.purpleAccent,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Remove Image',
                            style: normalTextStyle,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            OMIcons.flare,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Animations',
                            style: normalTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
            title: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(stops: [
                  _animation.value - 0.4,
                  _animation.value - 0.2,
                  _animation.value,
                  _animation.value + 0.2,
                  _animation.value + 0.4,
                ], colors: [
                  Colors.redAccent,
                  Colors.pinkAccent,
                  Colors.purpleAccent,
                  Colors.deepPurpleAccent,
                  Colors.blueAccent,
                ]).createShader(bounds);
              },
              child: GestureDetector(
                onVerticalDragDown: (details) {
                  print('called');
                  setState(() {
                    _topBarPadding = _topBarPadding == 0 ? 75 : 0;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.favorite_border),
                    Text(
                      'GlowBlow!',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'pac',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          );

    return Container(
      decoration: importedImage != null && _hide
          ? BoxDecoration(
              image: DecorationImage(
                  image: FileImage(importedImage, scale: 2),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black38, BlendMode.darken)))
          : null,
      child: Scaffold(
        key: drawingKey,
        floatingActionButton: !_hide ? floatingButton() : null,
        appBar: appBarTitle,
        drawer: !_hide ? MyDrawer() : null,
        extendBodyBehindAppBar: true,
        backgroundColor: !_hide ? Colors.white : Colors.transparent,
        body: WillPopScope(
          onWillPop: () {
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    elevation: 36,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                    backgroundColor: Colors.white,
                    title: Text(
                      'Do you want to exit?',
                      style: TextStyle(
                          color: Colors.blueGrey[800],
                          fontSize: 22,
                          fontFamily: 'pac'),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          'No',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          SystemNavigator.pop(animated: true);
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                });
          },
          child: Stack(
            children: <Widget>[
              SafeArea(
                child: Screenshot(
                  controller: screenshotController,
                  child: Stack(
                    children: <Widget>[
                      importedImage == null
                          ? SizedBox(
                              height: 0,
                              width: 0,
                            )
                          : SafeArea(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Image.file(
                                  importedImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      _multiColor || _animate
                          ? ScopedModelDescendant<PaintModel>(
                              builder: (BuildContext context, Widget child,
                                  PaintModel model) {
//                    print(model.blinkDuration);
                                return SafeArea(
                                  child: Stack(
                                    children: <Widget>[
//                          importedImage != null
//                              ? Center(
//                                  child: Image.file(importedImage),
//                                )
//                              : SizedBox(
//                                  height: 0,
//                                  width: 0,
//                                ),
                                      Animator(
                                          tween:
                                              Tween<double>(begin: 0, end: 1),
                                          duration: Duration(
                                              milliseconds:
                                                  model.blinkDuration),
                                          repeats: model.doRepeat ? 0 : null,
                                          cycles: model.doCycle ? 0 : null,
                                          curve: model.curve,
                                          builder: (anim) {
                                            double value = 1;
                                            if (anim.value < 0.5)
                                              value = 0;
                                            else
                                              value = 1;
                                            return AnimatedOpacity(
                                              opacity: _animate ? value : 1,
                                              duration: Duration(
                                                  milliseconds: model.doFade
                                                      ? model.blinkDuration ~/ 2
                                                      : 0),
                                              curve: model.curve,
                                              child: CustomPaint(
                                                painter: Sketcher(
                                                    painterController.pathsList,
                                                    _multiColor),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Painter(painterController),
                    ],
                  ),
                ),
              ),
              AnimatedPadding(
                padding: EdgeInsets.only(top: _topBarPadding),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut,
                child: !_hide
                    ? Container(
                        color: Colors.black12,
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                thumbColor: Colors.white,
                                activeTrackColor: Colors.pinkAccent,
                                inactiveTrackColor: Colors.grey[400],
                                overlayColor:
                                    Colors.pinkAccent.withOpacity(0.3),
                                trackHeight: 6,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8),
                                overlayShape:
                                    RoundSliderOverlayShape(overlayRadius: 20),
//                        trackShape: RoundedRectSliderTrackShape(),
                              ),
                              child: Slider(
                                min: 1.0,
                                value: painterController.thickness,
                                onChanged: (double value) => setState(() {
                                  painterController.thickness = value;
                                }),
                                max: 50.0,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.rainbow,
                                color: !_multiColor
                                    ? Colors.grey
                                    : Colors.blueAccent,
                              ),
                              onPressed: () {
                                setState(() {
                                  _multiColor = !_multiColor;
                                });
                              },
                            ),
                            ScopedModelDescendant<PaintModel>(
                              builder: (context, child, model) {
                                return IconButton(
                                  icon: Icon(
                                    Icons.play_circle_outline,
                                    color: _animate
                                        ? Colors.blueAccent
                                        : Colors.grey,
                                  ),
                                  onPressed: () async {
//                                setState(() {
//                                  _hide = true;
//                                });
//                                SystemChrome.setEnabledSystemUIOverlays(
//                                    []); // Remove stuff
//                                await requestPermissions();
//                                await startScreenRecord();
                                    setState(() {
                                      _animate = !_animate;
                                    });
//                                var duration = 0;
//                                if (model.doRepeat) {
//                                  duration =
//                                      model.blinkDuration * model.repeatCounts;
//                                } else {
//                                  duration = model.blinkDuration *
//                                      model.cycleCounts *
//                                      2;
//                                }
                                    timer(model.videoDuration, false);
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _topBarPadding = 0;
                                });
                              },
                            )
                          ],
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
