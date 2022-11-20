import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sheet_analysis_tool/domain/model/chord.dart';
import 'package:sheet_analysis_tool/presentation/page/beat_time_maker/beat_time_maker_view_model.dart';
import 'package:sheet_analysis_tool/presentation/widget/molecule/simple_field.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class BeatTimeMakerPage extends StatefulWidget {
  const BeatTimeMakerPage({Key? key}) : super(key: key);

  @override
  State<BeatTimeMakerPage> createState() => _BeatTimeMakerPageState();
}

class _BeatTimeMakerPageState extends State<BeatTimeMakerPage> {
  TextEditingController videoIdEditorController = TextEditingController();
  TextEditingController startTimeEditorController = TextEditingController();
  TextEditingController lengthEditorController = TextEditingController();
  TextEditingController bpmEditorController = TextEditingController();
  TextEditingController chordEditorController = TextEditingController();
  YoutubePlayerController youtubePlayerController = YoutubePlayerController();

  int position = 0;
  int currentTime = 0;
  Timer? playerSyncTimer;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("beat time maker"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SimpleField(
                controller: videoIdEditorController,
                hint: "Youtube video id를 입력해주세요"),
            Row(
              children: [
                Expanded(
                  child: SimpleField(
                      controller: lengthEditorController,
                      hint: "노래 길이 (ms) 를 입력해주세요"),
                ),
                Expanded(
                  child: SimpleField(
                      controller: startTimeEditorController,
                      hint: "노래 시작 위치 (ms) 를 입력해주세요"),
                ),
              ],
            ),
            SimpleField(controller: bpmEditorController, hint: 'bpm을 입력해주세요'),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    youtubePlayerController
                        .loadVideo(videoIdEditorController.text);

                    int startTime = int.parse(startTimeEditorController.text);
                    int length = int.parse(lengthEditorController.text);
                    int bpm = int.parse(bpmEditorController.text);

                    BeatTimeMakerViewModel viewModel =
                        context.read<BeatTimeMakerViewModel>();

                    viewModel.makeBeatTime(
                      startTime,
                      bpm,
                      length,
                    );

                    playerSyncTimer?.cancel();
                    playerSyncTimer = Timer.periodic(
                      const Duration(milliseconds: 8),
                      (timer) async {
                        currentTime =
                            ((await youtubePlayerController.currentTime) * 1000)
                                .round();
                      },
                    );

                    timer?.cancel();
                    timer = Timer.periodic(
                      const Duration(milliseconds: 8),
                      (timer) {
                        int diff = currentTime - startTime;

                        setState(() {
                          if (diff < 0) {
                            position = 0;
                          } else {
                            position = diff ~/ (60000 / bpm) + 1;
                          }
                        });
                      },
                    );
                  });
                },
                child: const Text("Apply"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 500,
                  child: YoutubePlayer(
                    controller: youtubePlayerController,
                  ),
                ),
                Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("youtube milliseconds : $currentTime"),
                      Text("position : $position"),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     _field(chordEditorController, '삽입할 코드를 입력해주세요'),
                      //     ElevatedButton(
                      //       onPressed: () {
                      //         Chord chord =
                      //         Chord.fromString(chordEditorController.text);
                      //       },
                      //       child: Text("add chord"),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              child: Builder(
                builder: (BuildContext context) {
                  if (timer == null) {
                    return Container();
                  }

                  BeatTimeMakerViewModel viewModel =
                      context.read<BeatTimeMakerViewModel>();

                  return Container(
                      height: 500, child: Text(viewModel.infos));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    playerSyncTimer?.cancel();
  }
}
