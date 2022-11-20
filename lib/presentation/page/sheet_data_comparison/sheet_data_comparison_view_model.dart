import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:sheet_analysis_tool/domain/model/chord.dart';
import 'package:sheet_analysis_tool/domain/model/chord_block.dart';
import 'package:sheet_analysis_tool/domain/model/sheet_data.dart';

class SheetDataComparisonViewModel extends ChangeNotifier {
  double _similarity = 0;

  double get similarity => _similarity;

  void compare(SheetData sheetData1, SheetData sheetData2) {
    double overlap = measureOverlap(sheetData1, sheetData2);
    _similarity = overlap;
    notifyListeners();
  }

  double measureOverlap(SheetData sheetData1, SheetData sheetData2) {
    double overlapSum = 0;

    int sheet1Idx = 0;
    int sheet2Idx = 0;
    double lastBeatTime = 0;

    while (sheet1Idx < sheetData1.chords.length &&
        sheet2Idx < sheetData2.chords.length) {
      ChordBlock block1 = sheetData1.chords[sheet1Idx];
      ChordBlock block2 = sheetData2.chords[sheet2Idx];

      Chord? lastChord1;
      Chord? lastChord2;

      final double diff;

      if (block1.beatTime < block2.beatTime) {
        diff = block1.beatTime - lastBeatTime;
        lastBeatTime = block1.beatTime;
        sheet1Idx++;
      } else {
        diff = block2.beatTime - lastBeatTime;
        lastBeatTime = block2.beatTime;
        sheet2Idx++;
      }

      lastChord1 = block1.chord ?? lastChord1;
      lastChord2 = block2.chord ?? lastChord2;

      if (lastChord1 == null && lastChord2 == null ||
          (lastChord1 != null && lastChord2 != null &&
              lastChord1.root.isEqualSyllable(lastChord2.root))) {
        overlapSum += diff;
      }
    }

    return overlapSum /
        max(sheetData1.chords.last.beatTime, sheetData2.chords.last.beatTime);
  }

// double measureOverlap(SheetData sheetData1, SheetData sheetData2) {
//   double overlapSum = 0;
//   int overlapCount = 0;
//
//   for (int chordIdx = 0; chordIdx < sheetData1.chords.length; ++chordIdx) {
//     ChordBlock block1 = sheetData1.chords[chordIdx];
//
//     if (block1.chord == null) {
//       continue;
//     }
//
//     final int chord1Idx = chordIdx;
//     final Chord chord1 = block1.chord!;
//     final double chord1End = block1.beatTime;
//     final double chord1Start;
//
//     if (chordIdx == 0) {
//       chord1Start = 0;
//     } else {
//       chord1Start = sheetData1.chords[chordIdx - 1].beatTime;
//     }
//
//     final idx = sheetData2.chords.indexWhere((e) => chord1End <= e.beatTime);
//     final int chord2Idx;
//     final Chord? chord2;
//     final double chord2Start;
//     final double chord2End;
//
//     if (idx == -1) {
//       chord2 = null;
//       chord2Idx = idx;
//       chord2End = chord1End;
//     } else if (idx > 0 && sheetData2.chords[idx - 1].beatTime >= (chord1Start + chord1End) / 2) {
//       chord2 = sheetData2.chords[idx - 1].chord;
//       chord2Idx = idx - 1;
//       chord2End = sheetData2.chords[idx - 1].beatTime;
//     } else {
//       chord2 = sheetData2.chords[idx].chord;
//       chord2Idx = idx;
//       chord2End = sheetData2.chords[idx].beatTime;
//     }
//
//     if (chord2Idx == -1) {
//       chord2Start = chord1Start;
//     } else if (chord2Idx == 0) {
//       chord2Start = 0;
//     } else {
//       chord2Start = sheetData2.chords[idx - 1].beatTime;
//     }
//
//     if (chord1.root == chord2?.root) {
//       final common = min(chord1End, chord2End) - max(chord1Start, chord2Start);
//       final entire = max(chord1End, chord2End) - min(chord1Start, chord2Start);
//       overlapSum += (common / entire);
//     }
//
//     overlapCount++;
//   }
//
//   return overlapSum / overlapCount;
// }
}
