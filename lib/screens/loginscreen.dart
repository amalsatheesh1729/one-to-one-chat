import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:learn_stuff/backend/firebase.dart';
import 'package:learn_stuff/screens/chatscreen.dart';
import 'package:learn_stuff/screens/logupscreen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);

  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();


  @override
  Widget build(BuildContext context) {
   return Scaffold(
   body: Container(
           width: double.infinity,
           height: double.infinity,
           alignment: Alignment.center,
          color: Colors.purple,
           child:Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Flexible(
                 child: Text('Sign In',style: TextStyle(
                   fontSize:20
                 ),),
               ),
               SizedBox(height: 50,),
               Container(
                 width: MediaQuery.of(context).size.width,
                 padding: EdgeInsets.all(10),
                 height: MediaQuery.of(context).size.height/2.2,
                 decoration: BoxDecoration(
                   border: Border.all(
                     color: Colors.white,
                     width: 2
                   )
                 ),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     TextField(
                       controller: t1,
                       decoration: InputDecoration(
                         label: Text('Email',style: TextStyle(color: Colors.white),),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(30),
                         ),
                           contentPadding: EdgeInsets.all(5)
                       ),
                     ),
                     SizedBox(height: 15),
                     TextField(
                       controller: t2,
                       decoration: InputDecoration(
                           label: Text('Password',style: TextStyle(color: Colors.white)),
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(30),
                           ),
                         contentPadding: EdgeInsets.all(5)
                       ),
                     ),
                     SizedBox(height: 15),
                     ElevatedButton(onPressed: () async{
                       await FirebaseClass().signinwithemailandpassword(t1.text,t2.text);
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                       {
                         return chatscreen();
                       }));
                     },
                       child: Text('Log In'),
                      style: ButtonStyle(
                      padding:MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left:75,right:75)) ,
                       backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                       shape: MaterialStateProperty.all<RoundedRectangleBorder>
                         (
                         RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(18.0),
                           side: BorderSide(
                             color: Colors.red,
                             width: 1
                           )
                         )
                       )
                     ),
                     ),
                     Align(
                       alignment: Alignment.bottomRight,
                       child: TextButton(onPressed: (){}, child: Text('Forgot Password ?'),
                       style: ButtonStyle(
                       ),
                       ),
                     )
                   ],
                 ),
               ),
               SizedBox(height: 17),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   SignInButton(
                     Buttons.Facebook,
                     mini: true,
                     onPressed: () {},
                   ),
                   SignInButton(
                     Buttons.Google,
                     onPressed: () {},
                   ),
                   SignInButton(
                     Buttons.LinkedIn,
                     mini: true,
                     onPressed: () {},
                   ),
                 ],
               ),
               SizedBox(height: 17),
               RichText(
                   text: TextSpan(
                     style: TextStyle(color: Colors.yellow),
                 text: 'Don\'t have an account yet ?',
                 children: [
                   TextSpan(text: 'Sign Up',
                   style: TextStyle(color: Colors.blue,
                   fontSize: 15,fontWeight: FontWeight.bold),
                   recognizer: TapGestureRecognizer()
                     ..onTap=(){
                      Navigator.push(context,MaterialPageRoute(builder: (context)
                      {
                        return LogupScreen();
                      }));
                   }),]
               ))
             ],
           )
   ));
  }

}
