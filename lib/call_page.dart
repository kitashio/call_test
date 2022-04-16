import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:sliding_switch/sliding_switch.dart';

class CallPage extends StatefulWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late AudioPlayer _player;
  double _currentSliderValue = 1.0;
  bool _changeAudioSource = false;
  String _stateSource = 'アセットを再生';

  @override
  void initState() {
    super.initState();
    _setupSession();

    // AudioPlayerの状態を取得
    _player.playbackEventStream.listen((event) {
      switch(event.processingState) {
        case ProcessingState.idle:
          print('オーディオファイルをロードしていないよ');
          break;
        case ProcessingState.loading:
          print('オーディオファイルをロード中だよ');
          break;
        case ProcessingState.buffering:
          print('バッファリング(読み込み)中だよ');
          break;
        case ProcessingState.ready:
          print('再生できるよ');
          break;
        case ProcessingState.completed:
          print('再生終了したよ');
          break;
        default:
          print(event.processingState);
          break;
      }
    });
  }

  Future<void> _setupSession() async {
    _player = AudioPlayer();
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    await _loadAudioFile();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _takeTurns() {
    late String _changeStateText;
    _changeAudioSource = _changeAudioSource ? false : true; // 真偽値を反転

    _player.stop();
    _loadAudioFile().then((_) {
      if(_changeAudioSource) {
        _changeStateText = 'ストリーミング再生';
      } else {
        _changeStateText = 'アセットを再生';
      }
      setState((){
        _stateSource = _changeStateText;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(30,150,30,0),
        child: Column(
          children: [
            const Text('岡本朋樹',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/line.png',
                  fit: BoxFit.fill,
                  height: 20,
                ),
                const Text(' LINEオーディオ...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 300),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/目覚まし時計のフリーアイコン.png',
                      height: 20,
                    ),
                    const SizedBox(height: 8),
                    const Text('あとで通知',
                      style: TextStyle(
                          color: Colors.white
                      ),)
                  ],),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/吹き出しのアイコン11.png',
                      height: 20,
                    ),
                    const SizedBox(height: 8),
                    const Text('メッセージを\n送信',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white
                      ),)
                  ],)
              ],
            ),
            const SizedBox(height: 10),
            IconButton(
              icon: const Icon(Icons.play_arrow,color: Colors.white,),
              onPressed: () async => await _playSoundFile(),
            ),
            IconButton(
              icon: const Icon(Icons.pause,color: Colors.white,),
              onPressed: () async => await _player.pause(),
            ),
            SlidingSwitch(
              value: false,
              width: 300,
              height: 90,
              textOff: '＞',
              textOn: 'スライドで応答',
              onChanged: (bool value) {

              },
              onSwipe: (){

              },
              onTap: (){

              },
              onDoubleTap: (){

              },
            )
          ],
        ),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       IconButton(
      //         icon: const Icon(Icons.play_arrow),
      //         onPressed: () async => await _playSoundFile(),
      //       ),
      //       IconButton(
      //         icon: const Icon(Icons.pause),
      //         onPressed: () async => await _player.pause(),
      //       )
      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takeTurns,
        tooltip: 'Increment',
        child: const Icon(Icons.autorenew),
      ),
    );
  }

  Future<void> _playSoundFile() async {
    // 再生終了状態の場合、新たなオーディオファイルを定義し再生できる状態にする
    if(_player.processingState == ProcessingState.completed) {
      await _loadAudioFile();
    }

    await _player.setSpeed(_currentSliderValue); // 再生速度を指定
    await _player.play();
  }

  Future<void> _loadAudioFile() async {
    try {
      if(_changeAudioSource) {
        await _player.setUrl('https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3'); // ストリーミング
      } else {
        await _player.setAsset('assets/audio/Cell_Phone-Ringtone01-1.mp3'); // ストリーミング
      } } catch(e) {
      print(e);
    }
  }
}