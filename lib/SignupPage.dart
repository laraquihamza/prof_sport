import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:toast/toast.dart';
import 'CustomAppBar.dart';
import"Signup_Client.dart";
class SignupPage extends StatefulWidget {
  SignupPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SignupPage createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: custom_appbar(widget.title, context,false   ),
      body: Center(
        child: Column(
          children: [
            Text("Vous êtes ?"),
          RaisedButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context){
              return SignupClient(title: "jojo");
            }));
          },
            icon:Icon(Icons.fitness_center),
            color: Colors.blueAccent,
            label: Text("Client"),),

            RaisedButton.icon(onPressed: (){

            },
              icon:Icon(Icons.fitness_center),
              color: Colors.blueAccent,
              label:
                Text("Coach Sportif"),),


          ],
        ),
      ),
    );
  }
}
