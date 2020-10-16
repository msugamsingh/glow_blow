import 'package:animator/animator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glowblow/widgets/constants.dart';
import 'package:glowblow/widgets/gradient_title.dart';
import 'package:glowblow/widgets/painter.dart';
import 'package:scoped_model/scoped_model.dart';

import '../paint_model.dart';

class ControlAnimations extends StatefulWidget {
  static const String id = 'control_animations';

  @override
  _ControlAnimationsState createState() => _ControlAnimationsState();
}

class _ControlAnimationsState extends State<ControlAnimations> {
  bool _animate = false;
  int _blinkDuration = 400;
  bool _doFade = false;
  bool _multiColor = false;
  bool _doRepeat = false;
  bool _doCycle = false;

//  int repeatCounts = 10;
  int _videoDuration = 10;

//  int cycleCounts = 10;
  Curve _curve = Curves.linear;

  @override
  void dispose() {
//    setState(() {
//
//    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GradientTitle(
          title: 'Animations',
        ),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<PaintModel>(
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
        builder: (BuildContext context, Widget child, PaintModel model) {
          Map buildMap = model.getAll;
          _blinkDuration = buildMap['blinkDuration'];
          _doFade = buildMap['doFade'];
          _multiColor = buildMap['multiColor'];
          _doRepeat = buildMap['doRepeat'];
          _doCycle = buildMap['doCycle'];
          _videoDuration = buildMap['videoDuration'];
          _curve = buildMap['curve'];
          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(38.0),
                child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        borderRadius: BorderRadius.circular(40)),
                    child: _animate
                        ? Animator(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: Duration(milliseconds: _blinkDuration),
                            curve: _curve,
                            repeats: _doRepeat ? 10 : null,
                            cycles: _doCycle ? 10 : null,
                            builder: (anim) {
                              double value = 1;
                              if (anim.value < 0.5)
                                value = 0;
                              else
                                value = 1;
                              return AnimatedOpacity(
                                opacity: _animate ? value : 1,
                                curve: _curve,
                                duration: Duration(
                                    milliseconds:
                                        _doFade ? _blinkDuration ~/ 2 : 0),
                                child: CustomPaint(
                                  painter: ExampleSketch(),
                                ),
                              );
                            })
                        : CustomPaint(
                            painter: ExampleSketch(),
                          )),
              ),
              SwitchListTile(
                title: Text('Animate', style: normalTextStyle),
                value: _animate,
                onChanged: (bool v) {
                  setState(() {
                    _animate = !_animate;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Fade', style: normalTextStyle),
                value: _doFade,
                onChanged: (bool v) {
                  model.setOnly('doFade', !_doFade);
                  setState(() {
                    _doFade = !_doFade;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Multi-Color', style: normalTextStyle),
                value: _multiColor,
                onChanged: (bool v) {
                  model.setOnly('multiColor', !_multiColor);
                  setState(() {
                    _multiColor = !_multiColor;
                  });
                },
              ),

              /// Not required for now but later
//              CheckboxListTile(
//                title: Text('Repeat', style: normalTextStyle),
//                value: _doRepeat,
//                onChanged: (bool v) {
//                  model.setOnly('doRepeat', !_doRepeat);
//                  model.setOnly('doCycle', false);
//                  setState(() {
//                    _doRepeat = !_doRepeat;
//                    _doCycle = false;
//                  });
//                },
//              ),
//              CheckboxListTile(
//                title: Text('Cycle', style: normalTextStyle),
//                value: _doCycle,
//                onChanged: (bool v) {
//                  model.setOnly('doCycle', !_doCycle);
//                  model.setOnly('doRepeat', false);
//                  setState(() {
//                    _doCycle = !_doCycle;
//                    _doRepeat = false;
//                  });
//                },
//              ),
              ListTile(
                title: Text(
                  'Video Duration',
                  style: TextStyle(
                    color: Colors.blueGrey[800],
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                isThreeLine: true,
                subtitle: Slider(
                  onChanged: (double value) {
                    model.setOnly('videoDuration', value.toInt());
                    setState(() {
                      _videoDuration = value.toInt();
                    });
                  },
                  value: _videoDuration.toDouble(),
                  max: 30,
                  min: 1,
                ),
                trailing: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$_videoDuration',
                    style: TextStyle(
                        color: Colors.blueGrey[800],
                        fontWeight: FontWeight.w300,
                        fontSize: 12),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Blink Duration',
                  style: TextStyle(
                    color: Colors.blueGrey[800],
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                isThreeLine: true,
                subtitle: Slider(
                  onChanged: (double value) {
                    model.setOnly('blinkDuration', value.toInt());
                    setState(() {
                      _blinkDuration = value.toInt();
                    });
                  },
                  value: _blinkDuration.toDouble(),
                  max: 3000,
                  min: 200,
                  divisions: 14,
                  label: '$_blinkDuration',
                ),
              ),
              ListTile(
                title: Text('Curve', style: normalTextStyle),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    elevation: 36,
                    style: TextStyle(
                        color: Colors.blueGrey[800],
                        fontWeight: FontWeight.w300),
                    isDense: true,
                    value: _curve,
                    items: <DropdownMenuItem<dynamic>>[
                      DropdownMenuItem(
                        value: Curves.linear,
                        child: Text('Linear'),
                      ),
                      DropdownMenuItem(
                        value: Curves.easeOut,
                        child: Text('Ease Out'),
                      ),
                      DropdownMenuItem(
                        child: Text('Ease In'),
                        value: Curves.easeIn,
                      ),
                      DropdownMenuItem(
                        value: Curves.decelerate,
                        child: Text('Decelerate'),
                      ),
                      DropdownMenuItem(
                        value: Curves.elasticOut,
                        child: Text('Elastic Out'),
                      ),
                      DropdownMenuItem(
                        value: Curves.elasticIn,
                        child: Text('Elastic In'),
                      ),
                      DropdownMenuItem(
                        value: Curves.bounceIn,
                        child: Text('Bounce In'),
                      ),
                      DropdownMenuItem(
                        value: Curves.bounceOut,
                        child: Text('Bounce Out'),
                      ),
                    ],
                    onChanged: (value) {
                      model.setOnly('curve', value);
                      setState(() {
                        _curve = value;
                      });
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
