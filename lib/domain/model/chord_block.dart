import 'chord.dart';

class ChordBlock {
  final Chord? chord;
  final double beatTime;

  int get beatTimeInMillis => (beatTime * 1000).toInt();

  ChordBlock({required this.chord, required this.beatTime});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChordBlock &&
          runtimeType == other.runtimeType &&
          chord == other.chord &&
          beatTime == other.beatTime;

  @override
  int get hashCode => chord.hashCode ^ beatTime.hashCode;

  ChordBlock copy({
    required Chord? chord,
    double? beatTime,
  }) {
    return ChordBlock(
      chord: chord,
      beatTime: beatTime ?? this.beatTime,
    );
  }
}
