import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prof_sport/CustomAppBar.dart';
import 'package:prof_sport/models/Exercice.dart';
import 'package:prof_sport/models/ExerciceService.dart';
import 'package:prof_sport/models/Reservation.dart';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: custom_appbar("Exercices Coach", context, true),
      body: Column(
        children: [
          field("Nom de l'exercice", name, false, controller_name),
          SizedBox(height:5),
          DropdownButton<int>(
            value: rep.str,
            underline: Container(
              height: 2,
              color: Colors.blueAccent,
            ),
            onChanged: (int? newValue) {
              setState(() {
                rep.str = newValue!;
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
            uploadPicture();
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
              });
            }

          }, child: Text("Ajouter exercice"))
        ],
      ),
    );
  }
  Future<Null> uploadPicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      picture = image!.path;
    });
  }

    Widget field(String name_field, Wrapper str, bool isPassword, TextEditingController controller) {
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