import 'dart:collection';
import 'dart:convert';

import 'chord.dart';
import 'chord_block.dart';

class SheetData {
  final String id;
  final double bpm;
  final List<ChordBlock> chords;

  double get bps => bpm / 60.0;

  SheetData({
    required this.id,
    required this.bpm,
    required this.chords,
  }) {
    _sortByBeatTimeInAsc(chords);
  }

  factory SheetData.fromJson(Map<String, dynamic> json) {
    List<ChordBlock> chords = [];

    for (Map<String, dynamic> info in json['infos']) {
      // Chord? chord = info['root'] == 'none' ? null : Chord.fromJson(info);
      Chord? chord = info['chord']['root'] == 'none' ? null : Chord.fromJson(info['chord']);
      double beatTime = info['beat_time'];

      chords.add(ChordBlock(chord: chord, beatTime: beatTime));
    }

    return SheetData(id: json['id'], bpm: json['bpm'], chords: chords);
  }

  SheetData copy({
    String? id,
    double? bpm,
    List<ChordBlock>? chords,
  }) {
    return SheetData(
      id: id ?? this.id,
      bpm: bpm ?? this.bpm,
      chords: chords ?? this.chords,
    );
  }

  void _sortByBeatTimeInAsc(List<ChordBlock> chords) {
    chords.sort((ChordBlock chord1, ChordBlock chord2) {
      return ((chord1.beatTime - chord2.beatTime) * 1000).toInt();
    });
  }

  String toJson() {
    Map json = HashMap();

    json['id'] = id;
    json['bpm'] = bpm;
    final infos = [];

    for (final chord in chords) {

      Map chordJson = HashMap();
      chordJson['root'] = chord.chord?.root.noteNameWithoutOctave ?? 'none';
      chordJson['triad'] = chord.chord?.triadType.notation ?? "none";
      chordJson['bass'] = chord.chord?.bass?.noteNameWithoutOctave ?? 'none';

      Map infoJson = HashMap();
      infoJson['chord'] = chordJson;
      infoJson['beat_time'] = chord.beatTime;

      infos.add(infoJson);
    }

    json['infos'] = infos;

    return jsonEncode(json);
  }
}
