import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:prof_sport/models/Client.dart';
import 'package:prof_sport/validators.dart';
import 'package:prof_sport/welcome_client.dart';
import 'package:toast/toast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


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
  Wrapper firstname = Wrapper("");
  Wrapper lastname = Wrapper("");
  Wrapper email = Wrapper("");
  Wrapper password = Wrapper("");
  Wrapper address = Wrapper("");
  Wrapper city = Wrapper("Agadir");
  DateTime? birthdate=DateTime(1970,10,10);
  Wrapper phonenumber = Wrapper("");
  Wrapper gender=Wrapper("Homme");
  Wrapper imageUrl=Wrapper("");
  int height=170;
  int weight=70;
  double imc=24.2;
  double img=35.2;

  Future<Null> uploadPicture() async{
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageUrl.str=image!.path;
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
            InkWell(child:             Wrap(children: [
                Icon(Icons.save_alt,
                color: Colors.black,

              ),
              Text(
                "Enregistrer",
                style: TextStyle(color: Colors.black),
              )
            ]),
              onTap: () async{
                bool valid=true;
                String errors="";
                Validators validators=Validators();
                if(!validators.isEmailValid(email.str)){
                  valid=false;
                  errors+="- L'adresse e-mail n'est pas valide \n";
                }
                if(!validators.validatePassword(password.str)){
                  valid=false;
                  errors+="- Le mot de passe doit contenir contenir au moins 8 caractères dont une majuscule, une minuscule et un caractère spécial\n";
                }
                if(!validators.isFirstLastNameValid(firstname.str)){
                  valid=false;
                  errors+="- Le prénom saisi n'est pas valide\n";
                }
                if(!validators.isFirstLastNameValid(lastname.str)){
                  valid=false;
                  errors+="- Le nom saisi n'est pas valide\n";
                }
                if(await validators.isEmailAlreadyUsed(email.str)){
                  valid=false;
                  errors+="- L'adresse mail est déja utilisée \n";
                  dialog_error(errors);
                }

                if(valid){
                  try{
                    await Auth().SignUpBig(email.str, password.str, firstname.str, lastname.str, city.str,
                        address.str, phonenumber.str,imageUrl.str, imc,img,height,weight,gender.str, birthdate!);
                    if(imageUrl.str!=""){
                      await Auth().UploadDocument(imageUrl.str);

                    }
                    await Auth().SignIn(email.str, password.str);
                    Toast.show("Inscription réussie ", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    Client client =await Auth().getCurrentClient();
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context){
                          return Welcome_Client(title: "Client", client:client);} ));

                  }
                  catch(e){
                  }

                }
                else{
                  dialog_error(errors);
                }
                }
              ,
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
                            image: kIsWeb
                                ? DecorationImage(

                              image: new NetworkImage(imageUrl.str),
                              fit: BoxFit.fill,
                            )
                                : DecorationImage(

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
                    Wrap(
                      children: [
                        Icon(Icons.height),
                        Text("Taille"),
                      ],
                    ),
                    DropdownButton<int>(
                      value: height,
                      underline: Container(
                        height: 2,
                        color: Colors.blueAccent,
                      ),
                      onChanged: (int? newValue) {
                        setState(() {
                          height = newValue!;
                          imc=weight/((height/100)*(height/100));
                        });
                      },

                      items:List<int>.generate(150, (index) => index+100)
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            value.toString()+"cm",
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
                    Wrap(
                      children: [
                        Icon(Icons.monitor_weight),
                        Text("Poids"),
                      ],
                    ),
                    DropdownButton<int>(
                      value: weight,
                      underline: Container(
                        height: 2,
                        color: Colors.blueAccent,
                      ),
                      onChanged: (int? newValue) {
                        setState(() {
                          weight = newValue!;
                          imc=weight/((height/100)*(height/100));
                          img=(1.2*imc+0.23*getAge(birthdate!)-10.8*(gender=="Homme"?1:0)-5.4);
                        });
                      },

                      items:List<int>.generate(400, (index) => index)
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            value.toString()+"Kg",
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
                    Wrap(
                      children: [
                        Icon(Icons.fitness_center),
                        Text("IMC"),
                      ],
                    ),
                    Text("${imc.toStringAsPrecision(3)}",
                      style: TextStyle(color:Colors.blueAccent),)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: [
                        Icon(Icons.accessibility),
                        Text("IMG"),
                      ],
                    ),
                    Text("${img.toStringAsPrecision(3)}",
                      style: TextStyle(color:Colors.blueAccent),)
                  ],
                ),


              ],
            )),
      ),
    );
  }
  dialog_error(String errors){
    AlertDialog alertDialog=AlertDialog(
      title: Text("Saisie incorrecte"),
      content: Text(errors),
      actions: [
        ElevatedButton(child:Text("OK"),onPressed: (){
          Navigator.of(context,rootNavigator: true).pop(context);
    },)
      ],
    );
    showDialog(context: context, barrierDismissible: false, builder: (buildcontext){
      return alertDialog;
    });
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


  Widget field(String namefield, Wrapper str, bool isPassword)
  {
    return Column(
      children: [
        SizedBox(height: 5,),

        TextField(
          obscureText: isPassword,
          keyboardType: TextInputType.text,
          onChanged: (s) {
            setState(() {
              str.str = s;
            });
          },
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
          decoration: InputDecoration(
            hintText: namefield,
              hintStyle: TextStyle(fontSize: 15),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ),
        SizedBox(height: 10,),
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