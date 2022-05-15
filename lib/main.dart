import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_stuff/screens/chatmessages.dart';
import 'package:learn_stuff/screens/chatscreen.dart';
import 'package:learn_stuff/models/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:learn_stuff/screens/loginscreen.dart';
import 'models/user.dart';
import 'package:learn_stuff/screens/chatscreen.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:learn_stuff/backend/firebase.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';

CameraDescription? front;
CameraDescription? back;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final cameras = await availableCameras();
  back=cameras.first;
  front=cameras.last;
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: LoginScreen(),
    );
  }
}


