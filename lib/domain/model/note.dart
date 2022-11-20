import 'dart:developer';

import 'package:flutter/material.dart';

class Note {
  static final _pitchNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
  static final _flatPitchNames = ['C', 'D♭', 'D', 'E♭', 'E', 'F', 'G♭', 'G', 'A♭', 'A', 'B♭', 'B'];
  static const String keySignatureChar = '#';

  final int keyNumber;

  // region constructors
  Note(this.keyNumber) {
    assert (1 <= keyNumber || keyNumber <= 88);
  }

  Note.fromNoteNumber(int noteNumber) : this(noteNumber - 20);

  Note.fromNoteName(String noteName) : this(tryConvertNoteNameToKeyNumber(noteName)!);
  // endregion

  static List<String> get pitchNames => _pitchNames;

  static List<String> get flatPitchNames => _flatPitchNames;

  // region getters
  String get noteName {
    return tryConvertKeyNumberToNoteName(keyNumber)!;
  }

  String get flatNoteName {
    String noteName = this.noteName;

    if (noteName.length >= 3) {
      int upperPitch = (keyNumber + 9) % 12;
      String upperPitchName = _pitchNames[upperPitch];

      noteName = "${upperPitchName}♭${noteName[2]}";
    }

    return noteName;
  }

  String get noteNameWithoutOctave {
    String nameWithOctave = noteName;
    return nameWithOctave.substring(0, nameWithOctave.length - 1);
  }

  String get flatNoteNameWithoutOctave {
    String nameWithOctave = flatNoteName;
    return nameWithOctave.substring(0, nameWithOctave.length - 1);
  }

  String get noteNameWithoutOctaveAndKeySignature {
    return noteName[0];
  }

  String get flatNoteNameWithoutOctaveAndKeySignature {
    return flatNoteName[0];
  }

  int get noteNumber {
    return keyNumber + 20;
  }

  String get rootName {
    String noteNameTmp = noteName;
    return noteNameTmp.substring(0, noteNameTmp.length - 1);
  }

  int get rootNumber {
    return _pitchNames.indexOf(rootName);
  }

  bool get hasKeySignature {
    return noteNameWithoutOctave.length == 2;
  }

  String get keySignature {
    String noteNameWithoutOctave = this.noteNameWithoutOctave;

    if (noteNameWithoutOctave.length == 1) {
      return "";
    } else {
      return keySignatureChar;
    }
  }
  // endregion


  static String? tryConvertKeyNumberToNoteName(int keyNumber) {
    if (keyNumber < 1 || 88 < keyNumber) {
      assert(false, "Chord Model: keyNumber should be in range [1,88]\ninput key number is ${keyNumber}");
      return null;
    }

    int pitch = (keyNumber + 8) % 12;
    String pitchName = _pitchNames[pitch];
    int octave = ((keyNumber + 8) / 12).floor();

    return '$pitchName$octave';
  }


  static int? tryConvertNoteNameToKeyNumber(String noteName) {
    if (noteName.length < 1 || 3 < noteName.length) {
      // noteName은 알파벳 1개 혹은 2개 뒤에 옥타브를 나타내는 숫자가 나타날 수 있는 문자열임
      log("Chord Model: unexpected note name");
      return null;
    }

    int pitchIndex;
    int? octave;

    if (_isNumber(noteName[noteName.length - 1])) {
      String pitchName = noteName.substring(0, noteName.length - 1);
      pitchIndex = _pitchNames.indexOf(pitchName);

      octave = int.tryParse(noteName[noteName.length - 1]);

      if (octave == null) {
        return null;
      }
    } else {
      String pitchName = noteName.substring(0, noteName.length);
      pitchIndex = _pitchNames.indexOf(pitchName);

      octave = 3;
    }

    if (pitchIndex == -1) {
      log('Chord Model: unexpected note name');
      return null;
    }

    return 12 * (octave! - 1) + pitchIndex + 4;
  }


  static bool _isNumber(String char) {
    if (char.length != 1) {
      return false;
    }

    const int startCode = 48;
    const int endCode = 57;

    int currentCode = char.codeUnitAt(0);

    return startCode <= currentCode && currentCode <= endCode;
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          keyNumber == other.keyNumber;

  @override
  bool isEqualSyllable(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          keyNumber % 12 == other.keyNumber % 12;

  @override
  int get hashCode => keyNumber.hashCode;
}