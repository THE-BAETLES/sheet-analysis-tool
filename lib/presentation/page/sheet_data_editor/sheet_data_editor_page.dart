import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sheet_analysis_tool/domain/model/chord.dart';
import 'package:sheet_analysis_tool/domain/model/sheet_data.dart';
import 'package:sheet_analysis_tool/presentation/page/sheet_data_editor/sheet_data_editor_view_model.dart';
import 'package:sheet_analysis_tool/presentation/widget/organism/sheet_view.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../widget/molecule/simple_field.dart';

class SheetDataEditorPage extends StatefulWidget {
  const SheetDataEditorPage({Key? key}) : super(key: key);

  @override
  State<SheetDataEditorPage> createState() => _SheetDataEditorPageState();
}

class _SheetDataEditorPageState extends State<SheetDataEditorPage> {
  TextEditingController youtubeIdEditingController = TextEditingController();
  TextEditingController sheetDataEditingController = TextEditingController();
  YoutubePlayerController youtubePlayerController = YoutubePlayerController();
  SheetData? sheetData;
  ValueNotifier<int> currentTileIdx = ValueNotifier(0);
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sheet data editor"),
      ),
      body: ChangeNotifierProvider(
        create: (BuildContext context) => SheetDataEditorViewModel(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SimpleField(
                hint: "youtube url을 입력하세요.",
                controller: youtubeIdEditingController,
              ),
              Container(
                height: 500,
                child: SimpleField(
                  controller: sheetDataEditingController,
                  hint: "sheet data를 입력하세요.",
                  maxLines: 100,
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final sheetDataStr = sheetDataEditingController.text;
                      final youtubeUrl = youtubeIdEditingController.text;

                      youtubePlayerController.loadVideo(youtubeUrl);
                      timer?.cancel();
                      timer = Timer.periodic(
                        const Duration(milliseconds: 8),
                            (timer) async {
                          final currentTime =
                          await youtubePlayerController.currentTime;

                          int idx = sheetData?.chords.indexWhere(
                                  (e) => currentTime < e.beatTime) ??
                              0;

                          if (currentTileIdx.value != idx) {
                            currentTileIdx.value = idx;
                          }
                        },
                      );

                      final sheetDataJson = jsonDecode(sheetDataStr);

                      setState(() {
                        sheetData = SheetData.fromJson(sheetDataJson);
                      });
                    },
                    child: Text("Load"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: sheetData?.toJson() ?? ""));
                    },
                    child: Text("Copy"),
                  ),
                ],
              ),
              Container(
                width: 500,
                child: YoutubePlayer(
                  controller: youtubePlayerController,
                ),
              ),
              Builder(builder: (context) {
                if (sheetData == null) {
                  return Container();
                }

                return SingleChildScrollView(
                  child: SheetView(
                    sheetData: sheetData!,
                    currentTileIdx: currentTileIdx,
                    onClickTile: (int tileIdx) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController controller = TextEditingController();

                          return AlertDialog(
                            title: Text("코드를 입력해주세요"),
                            content: SimpleField(
                              controller: controller, hint: '코드를 입력해주세요',
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("취소"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    final chordStr = controller.text;
                                    Chord? chord;

                                    if (chordStr == "") {
                                      chord = null;
                                    } else {
                                      chord = Chord.fromString(chordStr);
                                    }

                                    final block = sheetData!.chords[tileIdx];
                                    sheetData!.chords[tileIdx] = block.copy(chord: chord);
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text("적용"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
