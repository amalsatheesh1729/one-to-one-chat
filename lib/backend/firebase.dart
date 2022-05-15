import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learn_stuff/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/messages.dart';

class FirebaseClass
{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signInwithGoogle() async {
  try {
  final GoogleSignInAccount? googleSignInAccount =
  await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount!.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
  accessToken: googleSignInAuthentication.accessToken,
  idToken: googleSignInAuthentication.idToken,
  );
  await _auth.signInWithCredential(credential);
  print('success aayi');
  } on FirebaseAuthException catch (e) {
  print(e.message);
  throw e;
  }
  }

  Future<void> signOutFromGoogle() async{
  await _googleSignIn.signOut();
  await _auth.signOut();
  }


  Future<String> signupemailandpwd({required String email,required String password,required String name,required int age,required Uint8List profpic}) async
  {
    try
    {
      UserCredential uc=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Reference r= FirebaseStorage.instance.ref('ProfilePics').child(_auth.currentUser!.uid);
      UploadTask uploadTask=r.putData(profpic);
      TaskSnapshot taskSnapshot= await uploadTask;
      String url=await taskSnapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).
      set(user(name:name,age: age,uid: _auth.currentUser!.uid,email: email,
          photourl:url).
      usertostringdynamicforfirestore());
      return "success";
    }
    catch(e)
    {
      print(e.toString());
      return "fail";
    }
  }

  signinwithemailandpassword(String email,String password) async
  {
    try
        {
         await _auth.signInWithEmailAndPassword(email: email, password: password);
        }
        catch(e)
    {
      print(e);
    }
  }


  signout() async
  {
  await _auth.signOut();
  }

getusers() async
{
  final userlist=<user>[];

  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
      .collection('users').where('uid', isNotEqualTo: _auth.currentUser!.uid).get();
  List<DocumentSnapshot<Map<String, dynamic>>> docsnaplist = snapshot.docs;
  docsnaplist.forEach((element)
  {
    final d=element.data()!;
    userlist.add(user(uid: d['uid'], name: d['name'], age: d['age'], email: d['email'], photourl: d['photourl']));
  });
 print(userlist);
 return userlist;
}

  addmessagetobackend(String sendid,String recid,String text) async
  {
    await FirebaseFirestore.instance.collection('messages').doc().set(
      {
        'msgid':'$sendid$recid',
        'text':text,
        'datetime':DateTime.now(),
        'isplay':false
      }
    );
  }

Future<String> uploadimage(Uint8List image) async
{
  Reference r= FirebaseStorage.instance.ref('chatphotos').child(_auth.currentUser!.uid);
  UploadTask uploadTask=r.putData(image);
  TaskSnapshot taskSnapshot= await uploadTask;
  String url=await taskSnapshot.ref.getDownloadURL();
  return url;
}


Future<String> uploadaudio(String _mPath) async
{
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  print('$tempPath/$_mPath');
  File file = File('$tempPath/$_mPath');
  print(file);
  Reference r=await  FirebaseStorage.instance.ref('chataudios').
  child(_auth.currentUser!.uid).child(Uuid().v1());
  SettableMetadata metadata=SettableMetadata(
    contentType: "audio/mpeg",
  );
  UploadTask uploadTask= r.putFile(file,metadata);
  TaskSnapshot taskSnapshot= await uploadTask;
  String url=await taskSnapshot.ref.getDownloadURL();
  return url;
}



}







