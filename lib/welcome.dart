import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:toast/toast.dart';
import 'package:prof_sport/models/Client.dart';
import 'Signup_Client.dart';
import 'Signup_Coach.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class Welcome extends StatefulWidget {
  final String title;
  final Client client;
  Welcome({Key? key, required this.title, required this.client})
      : super(key: key);
  @override
  _Welcome createState() {
    return _Welcome();
  }
}

class _Welcome extends State<Welcome> {
  List<Widget> docs = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(children: [
          Text(widget.client.email),
          Text(widget.client.lastname),
          Text(widget.client.firstname),
          Text(widget.client.address),
          Text(widget.client.city),
          Text(widget.client.birthdate.toString()),
          Text(widget.client.phone),
          RaisedButton(
              child: Text("Upload Image"),
              onPressed: () async {
                print("jojo");
                String file =
                    (await FilePicker.platform.pickFiles())!.files.single.path!;
                Auth().UploadDocument(file);
                print("jojo" + file);
                /*String url=await Auth().downloadURL(file);
                  print(url);
                  print("jojojojo"+file);*/
              }),
          MaterialButton(
            onPressed: () {
              Auth().signOut();
              Navigator.pop(context);
            },
            child: Text("Déconnexion"),
          ),
          Text("documents"),
          FutureBuilder(
              future: list_documents(),
              builder: (context, snapshot) {
                list_documents();
                return Column(children: docs);
              })
        ]),
      ),
    );
  }

  Future<Null> list_documents() async {
    List list = await Auth().get_documents();
    print("kkikii$list");
    for (int i = 0; i < list.length; i++) {
      docs.add(Text(list[i]));
    }
  }
}
