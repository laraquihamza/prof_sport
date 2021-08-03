import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prof_sport/CustomAppBar.dart';
import 'package:prof_sport/models/Exercice.dart';
import 'package:prof_sport/models/ExerciceService.dart';
import 'package:prof_sport/models/Reservation.dart';

import 'models/AuthImplementation.dart';

class ClientExercices extends StatefulWidget {
  Reservation reservation;
  ClientExercices({required this.reservation});
  @override
  _ClientExercicesState createState() => _ClientExercicesState();
}

class _ClientExercicesState extends State<ClientExercices> {
  Wrapper name=Wrapper("");
  String picture="";
  WrapperInt rep=WrapperInt(5);
  var controller_name = TextEditingController();
  late String state;
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: custom_appbar("Exercices Coach", context, true),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.90,
              child:                 StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("exercices").
                where("idReservation",isEqualTo: widget.reservation.id).snapshots(),
                builder: (context,snapshot){
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context,index){
                        var doc=snapshot.data?.docs[index];
                        int rep=doc?["rep"];
                        String path=doc?["picture"];
                        print("picture:${path}");
                        state=doc?["state"];
                        return Column(
                          children: [
                            Row(
                              children:[
                                Text(doc!["name"]),
                                Text(rep.toString()),
                                DropdownButton<String>(
                                  value: state,
                                  underline: Container(
                                    height: 2,
                                    color: Colors.blueAccent,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      state = newValue!;
                                      ExerciceService().update_exercice(Exercice(id: doc["id"],
                                          idReservation: doc["idReservation"], picture: doc["picture"],
                                          name: doc["name"], state: state, rep: doc["rep"]));
                                    });
                                  },

                                  items:<String>["En Attente", "Réussi","Raté"]
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(color: Colors.blueAccent),
                                      ),
                                    );
                                  }).toList(),
                                )


                              ],
                            ),
                            StreamBuilder(
                                stream: FirebaseStorage.instance.ref(path).getDownloadURL().asStream(),
                                builder: (context,snap2){

                                  return Container(width: 200,height: 200,decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(

                                          image: NetworkImage(snap2.data.toString())
                                      )
                                  ),);

                                }),
                          ],
                        );
                      });
                },),

            )
          ],
        ),

      );
  }
  Future <Null> edit_dialog(Exercice exercice) async
  {
    int rep=exercice.rep;
    Wrapper name=Wrapper(exercice.name);
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: StatefulBuilder(
        builder: (context,setState){
          return Column(
            children: [

              field("Nom de l'exercice", name, false, null,exercice.name),

              DropdownButton<int>(
                value: rep,
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    rep = newValue!;
                    print("value:${newValue}");
                  });
                },
                items:[5,10,12,15,20,30,50]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      value.toString(),
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  );
                }).toList(),
              ),

              ElevatedButton(onPressed: (){
                uploadPicture_dialog(exercice);
              },
                  child: Text(exercice.picture==""?"Veuillez uploader une image":"Image uploadée")
              ),

            ],
          );
        },
      ),
      actions: [
        ElevatedButton(onPressed: (){
          exercice.name=name.str;
          exercice.rep=rep;
          ExerciceService().update_exercice(exercice);
          Navigator.pop(context);
        }, child: Text("confirmer")),
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Annuler"))
      ],
    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
  Future<Null> uploadPicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      picture = image!.path;
    });
  }
  Future<Null> uploadPicture_dialog(Exercice exercice) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      exercice.picture = image!.path;
    });
    await Auth().UploadDocument(exercice.picture);

  }


  Widget field(String name_field, Wrapper str, bool isPassword, TextEditingController ? controller, String? hint) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(name_field),
        ),
        TextField(

            controller: controller,
            obscureText: isPassword,
            keyboardType: TextInputType.text,
            onChanged: (s) {
              setState(() {
                str.str = s;
              });
            },
            decoration: InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                isDense: true)),
      ],
    );
  }

}
class Wrapper{
  late String str;
  Wrapper(String str){
    this.str=str;
  }
}
class WrapperInt{
  late int str;
  WrapperInt(int str){
    this.str=str;
  }
}