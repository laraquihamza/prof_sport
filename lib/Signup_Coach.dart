
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:email_validator/email_validator.dart';

class SignupCoach extends StatefulWidget {
  SignupCoach({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SignupCoach createState() => _SignupCoach();
}

class _SignupCoach extends State<SignupCoach> {
  Wrapper firstname = Wrapper("");
  Wrapper lastname = Wrapper("");
  Wrapper email = Wrapper("");
  Wrapper password = Wrapper("");
  Wrapper confirmpassword = Wrapper("");
  Wrapper address = Wrapper("");
  Wrapper city = Wrapper("Agadir");
  DateTime? birthdate=DateTime(1970,10,10);
  Wrapper phonenumber = Wrapper("");
  Wrapper gender=Wrapper("Homme");
  WrapperInt tarif = WrapperInt(100);
  Wrapper sport = Wrapper("Fitness");
  Wrapper cv = Wrapper("");
  Wrapper cin = Wrapper("");
  Wrapper dip = Wrapper("");
  Wrapper imageUrl=Wrapper("");


Future<Null> uploadPicture() async{
  final ImagePicker _picker = ImagePicker();
   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
   setState(() {
     imageUrl.str=image!.path;
   });

}
  Future<Null> uploadCin() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);
    setState(() {
      cin.str=result!.files[0].path!;
    });

  }
  Future<Null> uploadDiplome() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);
    setState(() {
      dip.str=result!.files[0].path!;
    });

  }
  Future<Null> uploadCV() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);
    setState(() {
      cv.str=result!.files[0].path!;
    });

  }

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
            InkWell(
              onTap: (){Navigator.pop(context);},
              child: Wrap(children: [
                Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                Text(
                  "Retour",
                  style: TextStyle(color: Colors.black),
                )
              ]),
            ),
            InkWell(
              child:            Wrap(children: [
                Icon(Icons.save_alt,
                  color: Colors.black,

                ),
                Text(
                  "Enregistrer",
                  style: TextStyle(color: Colors.black),
                )

              ]
              ),
                onTap: () async{
                  await Auth().SignUpBigCoach(      email.str,
                      password.str,
                      firstname.str,
                      lastname.str,
                      city.str,
                      address.str,
                      phonenumber.str,
                      sport.str,
                      tarif.str,
                      dip.str,
                      cin.str,
                      cv.str,
                      imageUrl.str,
                      birthdate!);
                  Auth().UploadDocument(imageUrl.str);
                  Auth().UploadDocument(cin.str);
                  Auth().UploadDocument(cv.str);
                  Auth().UploadDocument(dip.str);
                  Toast.show("Inscription réussie ", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  Navigator.pop(context);

                },
            ),
          ],
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                InkWell(
                  onTap: uploadPicture,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                    [
                       imageUrl.str==""? Icon(Icons.account_circle,size: 120.0,):
                       Container(
                         width: 120,
                         height: 120,
                         decoration: new BoxDecoration(
                           shape: BoxShape.circle,
                             image: new DecorationImage(
                               image: new FileImage(File(imageUrl.str)),
                               fit: BoxFit.fill,
                             )
                         ),
                       )
                      ,
                      Text(imageUrl.str==""? "Upload photo ?" : "Change photo"),
                    ],
                  ),
                ),
                field("Nom", lastname, false),
                field("Prénom", firstname, false),
                field("Adresse e-mail",email,false),
                field("Mot de passe",password, true),
                field("Confirmer le mot de passe", confirmpassword, true),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Date de naissance"),
                ),
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  color: Colors.grey.shade200,
                  onPressed: montrerAge,
                  child: Text(birthdate != null
                      ? "${birthdate!.day}/${birthdate!.month}/${birthdate!.year}"
                      : "Saisissez votre date de naissance"),
                ),
                field("Adresse Postale", address, false),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Ville"),
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  value: city.str,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.blueAccent),
                  underline: Container(
                    height: 2,
                    color: Colors.blueAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      city.str = newValue!;
                    });
                  },
                  items: <String>["Casablanca", "Fes", "Rabat", "Agadir"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    );
                  }).toList(),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Tarif"),
                ),
                DropdownButton<int>(
                  isExpanded: true,
                  value: tarif.str,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.blueAccent),
                  underline: Container(
                    height: 2,
                    color: Colors.blueAccent,
                  ),
                  onChanged: (int? newValue) {
                    setState(() {
                      tarif.str = newValue!;
                    });
                  },
                  items:List<int>.generate(10, (index) => (index*50)+100)
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        value.toString()+" DH/h",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    );
                  }).toList(),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Specialite"),
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  value: sport.str,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.blueAccent),
                  underline: Container(
                    height: 2,
                    color: Colors.blueAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      sport.str = newValue!;
                    });
                  },
                  items: <String>["Boxe", "Fitness", "Course",]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    );
                  }).toList(),
                ),
                field("Numéro de téléphone", phonenumber, false),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: [
                        Icon(Icons.wc),
                        Text("Sexe"),
                      ],
                    ),
                    DropdownButton<String>(
                      value: gender.str,
                      underline: Container(
                        height: 2,
                        color: Colors.blueAccent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          gender.str = newValue!;
                        });
                      },

                      items:<String>["Homme", "Femme"]
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text("Cin"),
                  ElevatedButton(
                      onPressed: uploadCin,
                      child: Text(cin.str == "" ? "vide" : "uploaded"))
                ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text("Diplôme"),
                  ElevatedButton(
                      onPressed: uploadDiplome,
                      child: Text(dip.str == "" ? "vide" : "uploaded"))
                ],),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text("CV"),
                  ElevatedButton(
                      onPressed: uploadCV,
                      child: Text(cv.str == "" ? "vide" : "uploaded"))
                ],)



              ],
            )),
      ),
    );
  }

  Future<Null> montrerAge() async {
    DateTime? res = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (res != null) {
      setState(() {
        birthdate = res;
      });
    }
  }
  int getAge(DateTime birthdate){
    DateTime now=DateTime.now();


    int age = now.year-birthdate.year;

    if (now.month < birthdate.month || (now.month==birthdate.month && now.day<birthdate.day)){
      age--;
    }
    return age;
  }
  Widget field(String name_field, Wrapper str, bool isPassword) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(name_field),
        ),
        TextField(
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

  Widget field_email(String name_field, bool isPassword) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(name_field),
        ),
        TextField(
            obscureText: isPassword,
            keyboardType: TextInputType.text,
            onChanged: (s) {
              setState(() {
                email.str = s;
              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                isDense: true)),
      ],
    );
  }

  Widget field_password(String name_field, bool isPassword) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(name_field),
        ),
        TextField(
            obscureText: isPassword,
            keyboardType: TextInputType.text,
            onChanged: (s) {
              setState(() {
                password.str = s;
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