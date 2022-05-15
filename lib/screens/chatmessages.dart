import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:learn_stuff/widgets/camera.dart';
import 'package:learn_stuff/backend/firebase.dart';
import 'package:learn_stuff/main.dart' as mainpg;
import 'package:learn_stuff/widgets/soundrecorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';



import '../widgets/videoplayer.dart';

class ChatMessages extends StatefulWidget {
  ChatMessages({Key? key, required this.recid,required this.recname}) : super(key: key);
  String recid;
  String recname;
  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  TextEditingController t1 = TextEditingController();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  bool isrecording=false;
  var isplaying={};
  String _mPath = 'foo.aac';
 Codec code=Codec.aacADTS;
 String? url;





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mRecorder!.openAudioSession();
    _mPlayer!.openAudioSession();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _mRecorder!.closeAudioSession();
    _mRecorder = null;
    // Be careful : you must `close` the audio session when you have finished with it.
    _mPlayer!.closeAudioSession();
    _mPlayer=null;
  }

  void record() async {
    setState(() {
      isrecording=true;
    });
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted amal custom');
    }
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: code,
    );
  }

  void stopRecorder() async {
    setState(() {
      isrecording=false;
    });
    await _mRecorder!.stopRecorder();
    url=await FirebaseClass().uploadaudio(_mPath);
    isplaying[url]=false;
    await FirebaseClass().addmessagetobackend(FirebaseAuth.instance.currentUser!.uid, widget.recid,url!);
  }

  void play(String url) {
    print(url);
    setState(() {
      isplaying[url]=true;
    });
    _mPlayer!
        .startPlayer(
        fromURI:url,
        //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,)
        );
  }

  void stopPlayer(String url) {
    setState(() {
      isplaying[url]=false;
    });
    _mPlayer!.stopPlayer();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.recname),
        centerTitle: true,
        actions: [

        ],
      ),
      body:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:
      [
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('msgid', whereIn: [
                    '${FirebaseAuth.instance.currentUser!.uid}${widget.recid}',
                    '${widget.recid}${FirebaseAuth.instance.currentUser!.uid}'
                  ])
                  .orderBy('datetime',descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> docsnaps =
                      snapshot.data!.docs;
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, i) {
                        return Align(
                          alignment: docsnaps[i].data()['msgid'].toString().
                          startsWith(FirebaseAuth.instance.currentUser!.uid)?Alignment.topRight:
                          Alignment.topLeft,
                          child: Container(
                              width : MediaQuery.of(context).size.width/2.5,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(20),
                                shape: BoxShape.rectangle,
                                color:docsnaps[i].data()['msgid'].toString().
                                startsWith(FirebaseAuth.instance.currentUser!.uid)?Colors.purple:
                                Colors.lightBlue,
                              ),
                              child:docsnaps[i].data()['text'].toString().contains("chataudios")?
                              IconButton(onPressed:isplaying[docsnaps[i].data()['text']]?(){
                                 print(isplaying);
                                 print(isplaying[docsnaps[i].data()['text'].toString()]);
                                stopPlayer(docsnaps[i].data()['text'].toString());
                              }:(){
                                play(docsnaps[i].data()['text'].toString());
                              }, icon:isplaying[docsnaps[i].data()['text'].toString()]?Icon(Icons.stop):Icon(Icons.play_arrow)):
                              docsnaps[i].data()['text'].toString().contains("chatphotos")?
                              Image.network(docsnaps[i].data()['text']):
                              Text(docsnaps[i].data()['text'],style: TextStyle(color: Colors.black))
                               )
                            );
                      });
                }
                return CircularProgressIndicator();
              }),
        ),
        SizedBox(height: 50,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 7,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: t1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  label:
                  Text('Enter something', style: TextStyle(color: Colors.white)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
    Flexible(
      flex: 1,
    child: IconButton(onPressed: () async {
              await FirebaseClass().addmessagetobackend(
                  FirebaseAuth.instance.currentUser!.uid,
                  widget.recid,
                  t1.text);
              t1.clear();
            }, icon: Icon(Icons.send))),
    Flexible(
    flex: 1,
    child: IconButton(onPressed: ()  {
      Navigator.push(context, MaterialPageRoute(builder: (context)
      {
        return TakePictureScreen(camera: mainpg.back!,recid: widget.recid,recname: widget.recname,);
      }));
    }, icon: Icon(Icons.camera)),
    ),
            GestureDetector(
              onTap: isrecording?stopRecorder:record,
              child: isrecording?Text('Recording.....'):Text('Record'),
            ),]
        ),
      ]),
    );
  }
}
