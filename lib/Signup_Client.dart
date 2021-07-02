import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:toast/toast.dart';
class SignupClient extends StatefulWidget {
  SignupClient({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SignupClient createState() => _SignupClient();
}

class _SignupClient extends State<SignupClient> {
  String firstname="";
  String lastname="";
  String email="";
  String password="";
  String confirmpassword="";
  String address="";
  String city="";
  DateTime? birthdate;
  String phonenumber="";

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
                Text("Nom"),
                TextField(keyboardType: TextInputType.text,onChanged: (s){
                  setState(() {
                    lastname=s;
                  });

                },),
            Text("Prénom"),
            TextField(keyboardType: TextInputType.text, onChanged: (s){
              setState(() {
                firstname=s;
              });
            },),
            Text("Adresse e-mail"),
            TextField(keyboardType: TextInputType.emailAddress, onChanged: (s){
              setState(() {
                email=s;
              });
            },),
            Text("Mot de passe"),
            TextField(keyboardType: TextInputType.text, obscureText: true,onChanged: (s){
              setState(() {
                password=s;
              });
            },),
            Text("Confirmer le mot de passe"),
            TextField(keyboardType: TextInputType.text,obscureText: true, onChanged: (s){
              setState(() {
                confirmpassword=s;
              });

            },),
            Text("Date de naissance"),
            RaisedButton(onPressed: montrerAge,child: Text(birthdate!=null?"${birthdate!.day}/${birthdate!.month}/${birthdate!.year}":"Saisissez votre date de naissance"),),
            Text("Adresse Postale"),
            TextField(keyboardType: TextInputType.text, onChanged: (s){
              setState(() {
                address=s;
              });

            },),
            Text("Ville"),
            TextField(keyboardType: TextInputType.text,onChanged: (s){
              setState(() {
                city=s;
              });

            },),
            Text("Numéro de téléphone"),
            TextField(keyboardType: TextInputType.phone,onChanged: (s){
              setState(() {
                phonenumber=s;
              });

            },),
            MaterialButton(onPressed: (){
              Auth().SignUpBig(email, password,firstname,lastname,city,address,phonenumber,birthdate!);
            },
              color: Colors.blue,
              child: Text("Inscription"),
            )
          ],
            )
        ),
    );

  }
  Future<Null> montrerAge() async{

    DateTime? res = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now()
    );
    if(res!=null){
      setState(() {
        birthdate=res;
      });
    }
  }

}
