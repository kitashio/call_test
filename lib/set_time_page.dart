import 'package:call_test/call_page.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class SetTimePage extends StatefulWidget {
  const SetTimePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SetTimePage> createState() => _SetTimePageState();
}

class _SetTimePageState extends State<SetTimePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Text('時間を設定してください。'),
            Text('12:00'),
            ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context) =>
                          const CallPage()),
                  );
                },
                child: Text('コール画面'))
          ],
        ),
      )
    );
  }
}