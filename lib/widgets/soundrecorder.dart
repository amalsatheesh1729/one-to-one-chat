import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:flutter_sound_lite/public/tau.dart';
import 'package:flutter_sound_lite/public/ui/recorder_playback_controller.dart';
import 'package:flutter_sound_lite/public/ui/sound_player_ui.dart';
import 'package:flutter_sound_lite/public/ui/sound_recorder_ui.dart';
import 'package:flutter_sound_lite/public/util/enum_helper.dart';
import 'package:flutter_sound_lite/public/util/flutter_sound_ffmpeg.dart';
import 'package:flutter_sound_lite/public/util/flutter_sound_helper.dart';
import 'package:flutter_sound_lite/public/util/temp_file_system.dart';
import 'package:flutter_sound_lite/public/util/wave_header.dart';
import 'package:learn_stuff/backend/firebase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../screens/chatmessages.dart';


class SoundRecorder extends StatefulWidget {
   SoundRecorder({Key? key,required this.recname,required this.recid}) : super(key: key);

  String recid;
  String recname;
  @override
  State<SoundRecorder> createState() => _SoundRecorderState();
}

class _SoundRecorderState extends State<SoundRecorder> {

  Codec _codec = Codec.aacMP4;
  String _mPath = 'test.mp4';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;


  @override
  void initState() {
    _mPlayer!.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    _mRecorder!.openAudioSession().then((value){
      setState(() {
        _mRecorderIsInited = true;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _mPlayer!.closeAudioSession();
    _mPlayer = null;

    _mRecorder!.closeAudioSession();
    _mRecorder = null;
    super.dispose();
  }



  // ----------------------  Here is the code for recording and playback -------

  void record() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted amal custom');
    }
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        //var url = value;
        _mplaybackReady = true;
      });
    });
  }

  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
        fromURI: _mPath,
        //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
        whenFinished: () {
          setState(() {});
        })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
    });
  }

// ----------------------------- UI --------------------------------------------

  getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  @override
  Widget build(BuildContext context) {
      return Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            height: 80,
            width: double.infinity,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              color: Color(0xFFFAF0E6),
              border: Border.all(
                color: Colors.indigo,
                width: 3,
              ),
            ),
            child: GestureDetector(
              onTap: record,
              onDoubleTap:() async{
            stopRecorder();
            String url= await FirebaseClass().uploadaudio(_mPath);
            await FirebaseClass().addmessagetobackend(FirebaseAuth.instance.currentUser!.uid,widget.recid,url);
            } ,
              child: ElevatedButton(
                onPressed:(){} ,
                child: Text(_mRecorder!.isRecording ? 'Stop' : 'Record'),
              ),
            ),
          );
  }
}
