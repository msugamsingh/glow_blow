import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PaintModel extends Model {

//  bool _animate = false;
  int blinkDuration = 400;
  bool doFade = true;
  bool doRepeat = false;
  bool doCycle = true;
//  int repeatCounts = 10;
//  int cycleCounts = 11;
  int videoDuration = 10;
  Curve curve = Curves.linear;
  bool multiColor = false;

  Map get getAll => {
    'blinkDuration': blinkDuration,
    'doFade': doFade,
    'doRepeat': doRepeat,
    'doCycle': doCycle,
    'videoDuration': videoDuration,
//    'repeatCounts': repeatCounts,
//    'cycleCounts': cycleCounts,
    'multiColor': multiColor,
    'curve': curve,
  };

  void setOnly(String s, dynamic val) {
    if (s == 'blinkDuration') blinkDuration = val;
    else if (s == 'doFade') doFade = val;
    else if (s == 'doRepeat') doRepeat = val;
    else if (s == 'doCycle') doCycle = val;
//    else if (s == 'repeatCounts') repeatCounts = val;
//    else if (s == 'cycleCounts') cycleCounts = val;
    else if (s == 'curve') curve = val;
    else if (s == 'multiColor') multiColor = val;
    else if (s == 'videoDuration') videoDuration = val;
    else print('No match');
    notifyListeners();
  }
}