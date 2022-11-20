import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sheet_analysis_tool/presentation/page/beat_time_maker/beat_time_maker_page.dart';
import 'package:sheet_analysis_tool/presentation/page/beat_time_maker/beat_time_maker_view_model.dart';
import 'package:sheet_analysis_tool/presentation/page/sheet_data_comparison/sheet_data_comparison_page.dart';
import 'package:sheet_analysis_tool/presentation/page/sheet_data_comparison/sheet_data_comparison_view_model.dart';
import 'package:sheet_analysis_tool/presentation/page/sheet_data_editor/sheet_data_editor_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return SheetDataComparisonViewModel();
        }),
        ChangeNotifierProvider(create: (_) {
          return BeatTimeMakerViewModel();
        }),
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'The Baetles tools',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: const Color(0xFF4E54FF),
          ),
          home: const MyHomePage(title: 'The Baetles sheet data analysis tools'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _button(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SheetDataComparisonPage(),
                  ),
                );
              },
              child: const Text("sheet data comparsion"),
            ),
            _button(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BeatTimeMakerPage(),
                  ),
                );
              },
              child: const Text("beat time maker"),
            ),

            _button(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SheetDataEditorPage(),
                  ),
                );
              },
              child: const Text("sheet data editor"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _button({
    required Function() onPressed,
    required Widget child,
  }) {
    return Container(
      width: 500,
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ElevatedButton(onPressed: onPressed, child: child),
    );
  }
}
