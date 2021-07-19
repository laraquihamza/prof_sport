import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prof_sport/models/AuthImplementation.dart';

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
  String firstname = "";
  String lastname = "";
  String email = "";
  String password = "";
  String confirmpassword = "";
  String address = "";
  String city = "Agadir";
  DateTime? birthdate=DateTime(1970,10,10);
  String phonenumber = "";
  String gender="Homme";
  int height=170;
  int weight=70;
  double imc=24.2;
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
            Wrap(children: [
              Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              Text(
                "Retour",
                style: TextStyle(color: Colors.black),
              )
            ]),
            Wrap(children: [
              Icon(
                Icons.save_alt,
                color: Colors.black,
              ),
              Text(
                "Enregistrer",
                style: TextStyle(color: Colors.black),
              )
            ])
          ],
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 100.0,
                    ),
                    Text("Changer de photo?")
                  ],
                ),
                field("Nom", lastname, false),
                field("Prénom", firstname, false),
                field("Adresse e-mail", email, false),
                field("Mot de passe", password, true),
                field("Confirmer le mot de passe", password, true),
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
                  value: city,
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
                      city = newValue!;
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
                      value: gender,
                      underline: Container(
                        height: 2,
                        color: Colors.blueAccent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          gender = newValue!;
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
                    Text("${(1.2*imc+0.23*getAge(birthdate!)-10.8*(gender=="Homme"?1:0)-5.4).toStringAsPrecision(3)}",
                      style: TextStyle(color:Colors.blueAccent),)
                  ],
                ),


/*                MaterialButton(
                  onPressed: () {
                    Auth().SignUpBig(email, password, firstname, lastname, city,
                        address, phonenumber, birthdate!);
                  },
                  color: Colors.blue,
                  child: Text("Inscription"),
                )*/
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
  Widget field(String name_field, String str, bool isPassword) {
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
                str = s;
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
