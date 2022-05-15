import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:learn_stuff/backend/firebase.dart';
import 'package:learn_stuff/backend/imageandvideo.dart';
import 'package:learn_stuff/screens/chatscreen.dart';
import 'package:learn_stuff/widgets/utils.dart';
import 'package:firebase_auth/firebase_auth.dart' ;

class LogupScreen extends StatefulWidget {
   LogupScreen({Key? key}) : super(key: key);

  @override
  State<LogupScreen> createState() => _LogupScreenState();
}

class _LogupScreenState extends State<LogupScreen> {
  TextEditingController namecnt=TextEditingController();

  TextEditingController emailcnt=TextEditingController();

  TextEditingController pwdcnt=TextEditingController();

  TextEditingController ageecnt=TextEditingController();

   Uint8List? profpic;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
              width: double.infinity,
              height:double.infinity,
              alignment: Alignment.center,
              color: Colors.purple,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height/1.9,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            (profpic==null)?
                            CircleAvatar(
                              backgroundImage:NetworkImage("https://images.unsplash.com/photo-1648027286072-fb339b0d0c06?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"),
                              radius: 50,
                            ): CircleAvatar(
                              backgroundImage:MemoryImage(profpic!),
                              radius: 50,
                            ),
                            Positioned(
                                left: 40,
                                top:60,
                                child: IconButton(onPressed: () async {
                                  Uint8List dwnld= await picaimage();
                                  if(dwnld=="noimage"){
                                    showsnackBar('Image kiteella ');
                                  }
                                  setState(() {
                                    profpic=dwnld;
                                  });
                                }, icon: Icon(Icons.add_a_photo)))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        getTextField('Name',namecnt,TextInputType.name),
                        SizedBox(
                          height: 10,
                        ),
                        getTextField('E-Mail',emailcnt,TextInputType.emailAddress),
                        SizedBox(
                          height: 10,
                        ),
                        getTextField('Password',pwdcnt,TextInputType.visiblePassword,b:true),
                        SizedBox(
                          height: 10,
                        ),
                        getTextField('Age',ageecnt,TextInputType.number),
                        SizedBox(
                          height: 7,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String s= await FirebaseClass().signupemailandpwd(
                                email:emailcnt.text,
                                password:pwdcnt.text,
                                age: int.parse(ageecnt.text),
                                name: namecnt.text,
                                profpic: profpic!
                            );
                             if(s=="success") {
                               Navigator.pushReplacement(
                                   context, MaterialPageRoute(
                                   builder: (context) {
                                     return chatscreen();
                                   }));
                             }
                             else
                               {
                                 showsnackBar('Log Up Failed');
                               }
                          },
                          child: Text('Log Up'),
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      EdgeInsets.only(left: 75, right: 75)),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.transparent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Colors.red, width: 1)))),
                        ),
                      ],
                    ),
                  )
                ],
              ))),
    );
  }

  TextField getTextField(String s,TextEditingController t,TextInputType type,{bool? b})
  {
    return TextField(
      controller: t,
      keyboardType: type,
      obscureText:b??false,
      decoration: InputDecoration(
          label: Text(s,
              style: TextStyle(color: Colors.white)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          contentPadding: EdgeInsets.all(5)),
    );
  }
}
