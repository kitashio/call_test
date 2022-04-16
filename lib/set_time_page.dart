import 'package:call_test/call_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class SetTimePage extends StatefulWidget {
  const SetTimePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SetTimePage> createState() => _SetTimePageState();
}

class _SetTimePageState extends State<SetTimePage> {
  String? selectHour = '1';
  String? selectMinits = '1';

  DropdownMenuItem hourSet (String i) {
      return DropdownMenuItem(
        child: Text('$i'),
        value: '$i',
      );
  }

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
            const SizedBox(height: 20,),
            // Text('$selectHour : $selectMinits'),
            // DropdownButton(
            //   items: [
            //     hourSet('1'),
            //   ],
            //   onChanged: () {
            //     setState(() {
            //       selectHour = value;
            //     });
            //   },
            //   value: selectHour,
            // ),
            const SizedBox(height: 20,),
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