import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:toast/toast.dart';
import 'SignupPage.dart';
import 'models/Client.dart';
import 'welcome.dart';

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Coachinow'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Color col_main= Colors.blueAccent;
  String email="";
  String password="";
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child:        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              logo(),
              textfield_email(),
              textfield_password(),
              button_login(),
              button_signup(),
              Text("Mot de passe oublié ?",
              style: TextStyle(color: Colors.black,decoration: TextDecoration.underline),
              )
            ],
          ),

        )
      ),
    );
  }
  Widget logo(){
    return               Image.asset("assets/coachinow.png");
  }
  Widget textfield_email(){
    return TextField(keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(prefixIcon: Icon(Icons.email),
          hintText: "E-mail"),
      onChanged: (String s){
        setState(() {
          email=s;
        });
      },
    );
  }
  Widget textfield_password(){
    return TextField(
      obscureText: true,
      decoration: InputDecoration(prefixIcon: Icon(Icons.lock),
          hintText: "Password"),
      onChanged: (String s){
        setState(() {
          password=s;
        });
      },

    );

  }
  Widget button_login(){
    return MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      onPressed: () async {
        Auth auth= new Auth();
        Client client;

        try {
          String uid = await auth.SignIn(email, password);
          client=await auth.getCurrentUser();
          Toast.show("Connexion réussie ", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          Navigator.push(context,
              MaterialPageRoute(builder: (context){
                return Welcome(title:"Bienvenue",client:client);
              })

          );


        }
        on Exception catch(_){
          Toast.show("Identifiants incorrects", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

        }
      },
      color: col_main,
      child: Text("Connexion"),
    );

  }
  Widget button_signup(){
    return               MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context){
              return SignupPage(title:"jojo");
            })

        );
      },
      color: col_main,
      child: Text("Inscription"),
    );

  }
}
