import 'package:flutter/material.dart';
import 'package:voice_wave_widget/voice_wave_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Voice Widget'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TestVoiceWaveWidget(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TestVoiceWaveWidget extends StatefulWidget {
  @override
  _VoiceWavePageState createState() => _VoiceWavePageState();
}

class _VoiceWavePageState extends State<TestVoiceWaveWidget> {
  late VoiceWaveType type;

  @override
  void initState() {
    type = VoiceWaveType.finished;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Wave'),
      ),
      body: Center(
        // alignment: Alignment.center,
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                setState(() {
                  type = VoiceWaveType.recording;
                });
              },
              child: Text('Start'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  type = VoiceWaveType.loading;
                });
              },
              child: Text('Loading'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  type = VoiceWaveType.finished;
                });
              },
              child: Text('Finish'),
            ),
            Container(
              height: 300,
              width: 900,
              child: VoiceWaveWidget(type: type),
            ),
          ],
        ),
      ),
    );
  }
}
