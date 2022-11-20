import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sheet_analysis_tool/domain/model/sheet_data.dart';
import 'package:sheet_analysis_tool/presentation/page/sheet_data_comparison/sheet_data_comparison_view_model.dart';
import 'package:sheet_analysis_tool/presentation/widget/molecule/simple_field.dart';

class SheetDataComparisonPage extends StatefulWidget {
  const SheetDataComparisonPage({Key? key}) : super(key: key);

  @override
  State<SheetDataComparisonPage> createState() =>
      _SheetDataComparisonPageState();
}

class _SheetDataComparisonPageState extends State<SheetDataComparisonPage> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SheetDataComparisonViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("sheet data comparison"),
      ),
      body: ChangeNotifierProvider(
        create: (BuildContext context) => SheetDataComparisonViewModel(),
        child: Column(
          children: [
            SimpleField(hint: "Youtube video id를 입력해주세요"),
            Row(
              children: [
                Expanded(
                  child: _sheetDataField(controller: controller1),
                ),
                Expanded(
                  child: _sheetDataField(controller: controller2),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.read<SheetDataComparisonViewModel>().compare(
                        SheetData.fromJson(jsonDecode(controller1.text)),
                        SheetData.fromJson(jsonDecode(controller2.text)),
                      );
                },
                child: const Text("analyze"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Text("유사도: ${viewModel.similarity}"),
            )
          ],
        ),
      ),
    );
  }

  Widget _sheetDataField({required final TextEditingController? controller}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      height: 500,
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "SheetData를 입력하세요",
        ),
        maxLines: 100,
      ),
    );
  }
}
