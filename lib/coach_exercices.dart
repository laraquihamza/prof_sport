import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prof_sport/CustomAppBar.dart';
import 'package:prof_sport/models/Exercice.dart';
import 'package:prof_sport/models/ExerciceService.dart';
import 'package:prof_sport/models/Reservation.dart';

import 'models/AuthImplementation.dart';

class CoachExercices extends StatefulWidget {
  Reservation reservation;
  CoachExercices({required this.reservation});
  @override
  _CoachExercicesState createState() => _CoachExercicesState();
}

class _CoachExercicesState extends State<CoachExercices> {
  Wrapper name=Wrapper("");
  String picture="";
  WrapperInt rep=WrapperInt(5);
  var controller_name = TextEditingController();
  var controller_rep=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: custom_appbar("Exercices Coach", context, true,false),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.35,
              child: Column(
                children: [
                  field("Nom de l'exercice", name, false, controller_name),
                  SizedBox(height:5),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Nombre de répetitions"),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: controller_rep,
                    onChanged: (s){
                      rep.str=int.parse(s);
                    },
                  ),
                  ElevatedButton(onPressed: ()async{
                    await uploadPicture();
                  },
                      child: Text(picture==""?"Veuillez uploader une image":"Image uploadée"
                      )),
                  SizedBox(height: 5.0,),
                  ElevatedButton(onPressed: (){
                    if(name.str != "" && picture !=""){
                      Exercice exercice=ExerciceService().add_exercice(widget.reservation.id, picture, rep.str, name.str, "En Attente");
                      setState(() {
                        controller_name.clear();
                        rep.str=5;
                        picture="";
                        controller_rep.clear();
                      });
                    }

                  }, child: Text("Ajouter exercice")),


                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.50,
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
                        return Column(
                          children: [
                            Row(
                              children:[
                                Text(doc!["name"]),
                                Text(rep.toString()),
                                IconButton(icon:Icon(Icons.close),onPressed: (){
                                  ExerciceService().delete_exercice(Exercice(id: doc["id"],name: doc["name"],
                                      idReservation: doc["idReservation"], state: doc["state"],picture: doc["picture"],rep: doc["rep"]));
                                },),
                                IconButton(icon:Icon(Icons.edit),onPressed: (){
                                  edit_dialog(Exercice(id: doc["id"],name: doc["name"],
                                      idReservation: doc["idReservation"], state: doc["state"],picture: doc["picture"],rep: doc["rep"]));
                                },)

                              ],
                            ),
                            StreamBuilder(
                                stream: FirebaseStorage.instance.ref(path).getDownloadURL().asStream(),
                                builder: (context,snap2){
                                  print("picture:"+picture);
                                  return Container(width: 200,height: 200,decoration:
                                  snap2.hasData?
                                  BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(

                                          image: NetworkImage(snap2.data.toString())
                                  )
                                  ):
                                  BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(

                                          image: AssetImage(picture)
                                      )
                                  )
                                  )



                                  ;

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
              field("Nom de l'exercice", name, false, TextEditingController(text:exercice.name)),

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

              ElevatedButton(onPressed: ()async{
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
        builder: (BuildContext dialogcontext) {
          return alert;
        });
  }
  Future<Null> uploadPicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      picture = image!.path;
    });
    await Auth().UploadDocument(picture);
  }
  Future<Null> uploadPicture_dialog(Exercice exercice) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      exercice.picture = image!.path;
    });
    await Auth().UploadDocument(exercice.picture);

  }


  Widget field(String name_field, Wrapper str, bool isPassword, TextEditingController ? controller) {
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