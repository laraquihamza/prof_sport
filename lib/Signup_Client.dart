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
  String dropdownValue="Agadir";

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
        automaticallyImplyLeading: false,
        foregroundColor: Colors.black,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              children:
[            Icon(Icons.arrow_back,color: Colors.black,),
            Text("Retour",style: TextStyle(color: Colors.black),)
          ]
            ),
            Wrap(
                children:
                [            Icon(Icons.save_alt,color: Colors.black,),
                  Text("Enregistrer",style: TextStyle(color: Colors.black),)
                ]
            )

          ],
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(

        child:
        Padding(padding: EdgeInsets.all(10.0),
          child:                  Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.account_circle, size: 100.0,),
                  Text("Changer de photo?")
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child:                 Text("Nom"),
              ),
            TextField(keyboardType: TextInputType.text,onChanged: (s){
                    setState(() {
                      lastname=s;
                    });

                  },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          isDense: true

                      )
                  ),
              Align(
                alignment: Alignment.topLeft,
                child:                 Text("Prénom"),
              ),
              TextField(keyboardType: TextInputType.text, onChanged: (s){
                setState(() {
                  firstname=s;
                });
              },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      isDense: true

                  )

              ),
              Align(
                alignment: Alignment.topLeft,
                child:                 Text("Adresse e-mail"),
              ),
              TextField(keyboardType: TextInputType.emailAddress, onChanged: (s){
                setState(() {
                  email=s;
                });
              },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      isDense: true

                  )

              ),
              Align(
                alignment: Alignment.topLeft,
                child:                 Text("Mot de passe"),
              ),
              TextField(keyboardType: TextInputType.text, obscureText: true,onChanged: (s){
                setState(() {
                  password=s;
                });
              },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      isDense: true

                  )
              ),
              Align(
                alignment: Alignment.topLeft,
                child:                 Text("Confirmer le mot de passe"),
              ),
              TextField(keyboardType: TextInputType.text,obscureText: true, onChanged: (s){
                setState(() {
                  confirmpassword=s;
                });

              },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      isDense: true

                  )

              ),
              Align(
                alignment: Alignment.topLeft,
                child:                 Text("Date de naissance"),
              ),
              RaisedButton(onPressed: montrerAge,child: Text(birthdate!=null?"${birthdate!.day}/${birthdate!.month}/${birthdate!.year}":"Saisissez votre date de naissance"),),
              Align(
                alignment: Alignment.topLeft,
                child:                 Text("Adresse postale"),
              ),
              TextField(keyboardType: TextInputType.text, onChanged: (s){
                setState(() {
                  address=s;
                });

              },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      isDense: true

                  )

              ),
              Align(
                alignment: Alignment.topLeft,
                child:                 Text("Ville"),
              ),
             DropdownButton<String>(
            value: city,
            icon: const Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? newValue) {
          setState(() {
            city=newValue!;
          });
        },
        items: <String>['Casablanca', 'Fes', "Rabat", "Agadir"]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
              TextField(keyboardType: TextInputType.text,onChanged: (s){
                setState(() {
                  city=s;
                });

              },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))
,                    isDense: true

                  )

              ),
              Align(
                alignment: Alignment.topLeft,
                child:                 Text("Numéro de téléphone"),
              ),
              TextField(keyboardType: TextInputType.phone,onChanged: (s){
                setState(() {
                  phonenumber=s;
                });

              },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    isDense: true
                  )

              ),
   /*           MaterialButton(onPressed: (){
                Auth().SignUpBig(email, password,firstname,lastname,city,address,phonenumber,birthdate!);
              },
                color: Colors.blue,
                child: Text("Inscription"),
              )*/
            ],
          )

        ),
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
