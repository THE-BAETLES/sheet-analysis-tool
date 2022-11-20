import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class BeatTimeMakerViewModel extends ChangeNotifier {
  String infos = "";

  void makeBeatTime(int startTime, int bpm, int duration) {
    List<dynamic> info = [];
    print("gogo");
    int msPerBeat = (60000 / bpm).round();

    for (int beatTime = startTime; beatTime <= duration; beatTime += msPerBeat) {
      Map<String, String> chord = HashMap();
      chord['root'] = 'none';
      chord['triad'] = 'none';
      chord['bass'] = 'none';

      Map<String, dynamic> block = HashMap();
      block['chord'] = chord;
      block['beat_time'] = (beatTime + msPerBeat) / 1000;

      info.add(block);
    }

    Map json = HashMap();
    json['id'] = "";
    json['bpm'] = bpm;
    json['infos'] = info;

    final sheetDataJson = jsonEncode(json);

    Clipboard.setData(ClipboardData(text: sheetDataJson));

    notifyListeners();
  }
}