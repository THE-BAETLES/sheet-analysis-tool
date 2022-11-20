import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheet_analysis_tool/domain/model/chord_block.dart';
import 'package:sheet_analysis_tool/domain/model/sheet_data.dart';

class SheetView extends StatefulWidget {
  final Function(int)? onClickTile;
  final SheetData sheetData;
  final ValueNotifier<int> currentTileIdx;

  const SheetView({Key? key, required this.sheetData, required this.currentTileIdx, this.onClickTile}) : super(key: key);

  @override
  State<SheetView> createState() => _SheetViewState();
}

class _SheetViewState extends State<SheetView> {
  @override
  Widget build(BuildContext context) {
    const int beatPerRow = 16;
    List<Widget> rows = [];
    List<ChordBlock> chords = widget.sheetData.chords;

    for (int rowIdx = 0;
        rowIdx < (chords.length / beatPerRow).ceil();
        ++rowIdx) {
      List<Widget> tiles = [];

      int startChordIdx = rowIdx * beatPerRow;

      for (int tileIdx = 0; tileIdx < beatPerRow; ++tileIdx) {
        int tileIdxOfSheet = startChordIdx + tileIdx;

        if (tileIdx % 4 == 0) {
          tiles.add(Container(height: 60, width: 3, color: Colors.black));
        }

        if (chords.length <= tileIdxOfSheet) {
          tiles.add(Container(
            color: Colors.grey,
            height: 60,
            width: 60,
            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          ));

          continue;
        }

        tiles.add(
          ValueListenableBuilder(
            valueListenable: widget.currentTileIdx,
            builder: (context, value, _) {
              return GestureDetector(
                onTap: () {
                  widget.onClickTile?.call(tileIdxOfSheet);
                },
                child: Container(
                  color: value == tileIdxOfSheet ? Colors.blue : Colors.grey,
                  height: 60,
                  width: 60,
                  margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  child: Text(chords[tileIdxOfSheet].chord?.fullName ?? ""),
                ),
              );
            }
          ),
        );
      }

      rows.add(Row(
        children: tiles,
      ));
    }

    return Column(
      children: rows,
    );
  }
}
