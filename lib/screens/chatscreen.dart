
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_stuff/backend/firebase.dart';
import 'package:learn_stuff/screens/chatmessages.dart';
import 'package:learn_stuff/screens/loginscreen.dart';
import 'package:learn_stuff/screens/logupscreen.dart';

import '../models/user.dart';

class chatscreen extends StatefulWidget {
   chatscreen({Key? key}) : super(key: key);


  @override
  State<chatscreen> createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {

  var list=[];

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getusers();
  }

  getusers() async
  {
    list=await FirebaseClass().getusers();
    print(list);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('MyChats'),
          centerTitle:true,
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(onPressed: () async {
             await FirebaseClass().signout();
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)
              {
                return LoginScreen();
              }));
            }, icon: Icon(Icons.logout_sharp)),

          ],
        ),
        body: FutureBuilder(
            future:FirebaseFirestore.instance
                .collection('users').where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
            builder: (BuildContext context,AsyncSnapshot snapshot)
          {
            if(snapshot.connectionState==ConnectionState.waiting)
              {
                return CircularProgressIndicator();
              }
            return ListView.builder(
          itemCount:list.length ,
            itemBuilder: (context,i)
        {
          return GestureDetector(
            onTap:(){
              Navigator.push(context,MaterialPageRoute(builder: (context)
              {
                return ChatMessages(recid:list[i].uid!,recname:list[i].name!);
              }));
            } ,
            child: ListTile(
                leading: Text(list[i].name!),
            ),
          );
        });
          })
      ));
  }
}


