import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:prof_sport/CoachOuClient.dart.dart';
import 'package:prof_sport/ResetPassword.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:prof_sport/models/Coach.dart';
import 'package:prof_sport/models/NotificationService.dart';
import 'package:prof_sport/welcome_coach.dart';
import 'package:toast/toast.dart';
import 'CoachOuClient.dart.dart';
import 'models/Client.dart';
import 'welcome_client.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late AndroidNotificationChannel channel;
void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,        DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp( await Auth().user_type()));
}

class MyApp extends StatelessWidget {
  late String type;
  MyApp(String type){
    this.type=type;
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
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
      home: type=="client"?
      FutureBuilder(
        future: Auth().getCurrentClient(),
        builder: (context,snap){
          return Welcome_Client(title:"",client:snap.data as Client);
        },
      ):(type=="coach"?
      FutureBuilder(
        future: Auth().getCurrentCoach(),
        builder: (context,snap){
          return Welcome_Coach(title:"",coach:snap.data as Coach);
        },
      ):MyHomePage(title: "Coachinow",)
      )

    );
  }
}
class MessageArguments {
  late RemoteMessage message;
  late bool isTrue;
  MessageArguments(RemoteMessage message,bool isTrue){
    this.message=message;
    this.isTrue=isTrue;
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
  Color col_main = Colors.blueAccent;
  String email = "";
  String password = "";



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            logo(),
            Column(
              children: [
                textfield_email(),
                textfield_password(),
                button_login(),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return resetPassword();
                    }));
                  },
                  child:                 Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            button_signup(),

          ],
        ),
      )),
    );
  }

  Widget logo() {
    return Image.asset("assets/coachinow.png");
  }

  Widget textfield_email() {
    return Padding(
        padding: EdgeInsets.all(
          5.0,
        ),
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              hintText: "E-mail"),
          onChanged: (String s) {
            setState(() {
              email = s;
            });
          },
        ));
  }

  Widget textfield_password() {
    return Padding(
      padding: EdgeInsets.all(
        5.0,
      ),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            hintText: "Password"),
        onChanged: (String s) {
          setState(() {
            password = s;
          });
        },
      ),
    );
  }

  Widget button_login() {
    return Padding(
        padding: EdgeInsets.all(
          5.0,
        ),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            Auth auth = new Auth();
            late Client client;
            late Coach coach;
            try {
    String uid = await auth.SignIn(email, password);
    if(uid=="mailnotverified"){
      Toast.show("Votre adresse mail n'est pas vérifiée", context);
    }
    else if(await auth.user_type()=="client"){
    client = await auth.getCurrentClient();
    Toast.show("Connexion réussie ", context,
    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Welcome_Client(title: "Bienvenue", client: client);
    }));

    }
    else if(await auth.user_type()=="coach"){
      NotificationService().saveDeviceToken(Auth().getCurrentUserUid());
      coach = await auth.getCurrentCoach();
      Toast.show("Connexion réussie ", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Welcome_Coach(title: "Bienvenue", coach:coach);
      }));

    }
    else{
      Toast.show("Erreur ni coach ni client ", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);


    }

    }on Exception catch (_) {
              Toast.show("Identifiants incorrects", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

            }
          },
          color: col_main,
          child: Text("Connexion"),
        ));
  }

  Widget button_signup() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.grey),
          ),
        ),
        child: RaisedButton(
          color: Colors.transparent,
          elevation: 0.0,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CoachouClient();
            }));
          },
          child: Text("Créer un compte",
              style: TextStyle(color: Colors.blueAccent)),
        ));
  }
}
