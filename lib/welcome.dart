import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:toast/toast.dart';
import 'package:prof_sport/models/Client.dart';
import 'SignupPage.dart';
import 'package:image_picker/image_picker.dart';

class Welcome extends StatefulWidget{
  final String title;
  final Client  client;
  Welcome({Key? key, required this.title, required this.client}) : super(key: key);
  @override
  _Welcome createState() {
    return _Welcome();
  }
}
class _Welcome extends State<Welcome>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

    body: Center(
        child: Column(
          children:[
            Text(widget.client.email),
            Text(widget.client.lastname),
            Text(widget.client.firstname),
            Text(widget.client.address),
            Text(widget.client.city),
            Text(widget.client.birthdate.toString()),
            Text(widget.client.phone),
            RaisedButton(
                child: Text("Upload Image"),
                onPressed: () async{
                  print("jojo");
                  String file= (await ImagePicker().getImage(source: ImageSource.gallery))!.path;
                  Auth().UploadDocument(file);
                  print("jojojojo"+file);

                }),

            MaterialButton(onPressed: (){
              Auth().signOut();
              Navigator.pop(context);
            },
            child: Text("Déconnexion"),
            )
          ]
        ),
      ),
    );
  }

}