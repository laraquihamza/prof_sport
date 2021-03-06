import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prof_sport/ChatScreenClient.dart';
import 'package:prof_sport/CustomAppBar.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:prof_sport/reservations_client.dart';
import 'package:prof_sport/search_result.dart';
import 'package:toast/toast.dart';
import 'package:prof_sport/models/Client.dart';
import 'Signup_Client.dart';
import 'Signup_Coach.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'main.dart';
import 'models/Conversation.dart';

class Wrapper {
  late String str;

  Wrapper(String str) {
    this.str = str;
  }
}

class Welcome_Client extends StatefulWidget {
  final String title;
  final Client client;

  Welcome_Client({Key? key, required this.title, required this.client})
      : super(key: key);

  @override
  _Welcome_Client createState() {
    return _Welcome_Client();
  }
}

class _Welcome_Client extends State<Welcome_Client> {
  Wrapper imageUrl = Wrapper("");
  Wrapper imagePath = Wrapper("");
  List<Widget> docs = [];
  int index = 0;
  int tabindex = 0;
  Wrapper city = Wrapper('Agadir');
  Wrapper sport = Wrapper('Boxe');
  WrapperInt tarif = WrapperInt(100);

  Widget home_page() {
    return Column(
      children: [
        Text("Bienvenue Client"),
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
        SizedBox(height: 20,),
        Align(
          alignment: Alignment.topLeft,
          child: Text("Tarif maximum"),
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
          items: List<int>.generate(10, (index) => (index * 50) + 100)
              .map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(
                value.toString() + " DH/h",
                style: TextStyle(color: Colors.blueAccent),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 20,),
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
          items: <String>["Boxe", "Fitness", "Course"]
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
        SizedBox(height: 40,),
        Center(
          child: ElevatedButton(child: Text("Recherche"), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                SearchResult(city.str, sport.str, tarif.str)));
          },),


        ),
        SizedBox(height: 40,),
        ElevatedButton(child: Text("Liste RDV"), onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              ListeDemande(client: widget.client, title: 'Liste RDV')));
        },),


      ],
    )
    ;
  }

  Future<Null> uploadPicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath.str = image!.path;
    });
    print("imageStr:${imagePath.str}");
  }

  Future<Null> getDownloadUrl() async {
    imageUrl.str = await Auth().downloadURL(widget.client.picture);
  }

  Widget conversations_page() {
    DateTime date = DateTime.now();
    return
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("conversations").where(
              "idClient", isEqualTo: widget.client.uid).snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasData ?
            ListView.builder(shrinkWrap: true,
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  int length = 0;
                  return InkWell(
                      onTap: () async {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) {
                          return ChatScreenClient(conversation: Conversation(
                              id: snapshot.data!.docs[index]["id"],
                              idCoach: snapshot.data!.docs[index]["idCoach"],
                              idClient: snapshot.data!
                                  .docs[index]["idClient"]));
                        }));
                      },
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection(
                              "coaches")
                              .where("id", isEqualTo: doc["idCoach"])
                              .snapshots(),
                          builder: (context, snap) {
                            return snap.hasData ? Row(children: [
                              StreamBuilder(
                                stream: Auth().downloadURL(
                                    snap.data!.docs[0]["picture"]).asStream(),
                                builder: (context, snappicture) {
                                  return CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        snappicture.data as String),
                                    maxRadius: 30,
                                  );
                                },
                              ),
                              SizedBox(width: 16,),
                              Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text("${snap.data!
                                          .docs[0]['firstname']} ${snap.data!
                                          .docs[0]['lastname']} ",
                                        style: TextStyle(fontSize: 16),),
                                      SizedBox(height: 6,),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("messages").where(
                                            "idConversation",
                                            isEqualTo: doc["id"]).orderBy(
                                            "date").snapshots(),
                                        builder: (context, snap2) {
                                          var doc;
                                          if (snap2.hasData) {
                                            length =
                                                snap2.data!.docs.length - 1;
                                            if (length != -1) {
                                              doc = snap2.data!.docs[length];
                                              date = doc==null?doc["date"].toDate():DateTime.now();

                                            }
                                          }
                                          return
                                            snap2.hasData ? Row(
                                              children: [
                                                Text(
                                                  length != -1 ? get_substring(
                                                      doc["message"]) : "",
                                                  style: TextStyle(fontSize: 13,
                                                      color: Colors.grey
                                                          .shade600,
                                                      fontWeight: FontWeight
                                                          .normal),),
                                                Spacer(),
                                                length != -1
                                                    ? Text(
                                                    "${get_date_string(date)}")
                                                    : Text(""),
                                                SizedBox(width: 5.0,)


                                              ],
                                            ) : Text("");
                                        },
                                      )

                                    ],
                                  ),
                                ),
                              ),

                            ]
                            ) : Text("");
                          })
                  );
                }
                ):Text("");
                }
            );
          }
          String get_substring(String s)
    {
      if (s.length > 15) {
        return s.substring(0, 15)+"...";
      }
      return s;
    }
    String get_date_string(DateTime date) {
      DateTime now = DateTime.now();
      if (date.year == now.year && date.month == now.month &&
          date.day == now.day) {
        return "${date.hour}h${date.minute}";
      }
      else if (date.year == now.year && date.month == now.month &&
          date.day == now.day - 1) {
        return "Hier";
      }
      else {
        return "${date.day}/${date.month}/${date.year}";
      }
    }
    Widget infos_page() {
      return Container(
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                uploadPicture();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                [
                  widget.client.picture == "" ? Icon(
                    Icons.account_circle, size: 120.0,) :
                  FutureBuilder(
                      future: getDownloadUrl(),
                      builder: (context, snapshot2) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: imagePath.str == "" ? new DecorationImage(
                                image: new NetworkImage(imageUrl.str),
                                fit: BoxFit.fill,
                              ) :
                              new DecorationImage(
                                image: new FileImage(File(imagePath.str)),
                                fit: BoxFit.fill,
                              )
                          ),
                        );
                      }
                  ),
                  Text(imageUrl.str == "" ? "Upload photo ?" : "Change photo"),
                ],
              ),
            ),
            Text("Num??ro de t??lephone"),
            TextField(
              onChanged: (String? s) {
                widget.client.phone = s.toString();
              },

              controller: TextEditingController(
                text: widget.client.phone,
              ),
            ),
            Text("Adresse"),
            TextField(
              onChanged: (String? s) {
                widget.client.address = s.toString();
              },
              controller: TextEditingController(
                text: widget.client.address,
              ),
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
                  value: widget.client.height,
                  underline: Container(
                    height: 2,
                    color: Colors.blueAccent,
                  ),
                  onChanged: (int? newValue) {
                    setState(() {
                      widget.client.height = newValue!;
                      widget.client.imc = widget.client.weight / ((widget.client
                          .height / 100) * (widget.client.height / 100));
                    });
                  },
                  items: List<int>.generate(150, (index) => index + 100)
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        value.toString() + "cm",
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
                  value: widget.client.weight,
                  underline: Container(
                    height: 2,
                    color: Colors.blueAccent,
                  ),
                  onChanged: (int? newValue) {
                    setState(() {
                      widget.client.weight = newValue!;
                      widget.client.imc = widget.client.weight / ((widget.client
                          .height / 100) * (widget.client.height / 100));
                      widget.client.img = (1.2 * widget.client.imc +
                          0.23 * getAge(widget.client.birthdate) -
                          10.8 * (widget.client.gender == "Homme" ? 1 : 0) -
                          5.4);
                    });
                  },

                  items: List<int>.generate(400, (index) => index)
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        value.toString() + "Kg",
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
                Text("${widget.client.imc.toStringAsPrecision(3)}",
                  style: TextStyle(color: Colors.blueAccent),)
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
                Text("${widget.client.img.toStringAsPrecision(3)}",
                  style: TextStyle(color: Colors.blueAccent),)
              ],
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Text("Ville"),
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: widget.client.city,
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
                  widget.client.city = newValue!;
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

            SizedBox(height: 30,),

            ElevatedButton(onPressed: () {
              if (widget.client.address != "" && widget.client.phone != "") {
                print("address" + widget.client.address);
                if (imagePath.str != "") {
                  Auth().UploadDocument(imagePath.str);
                  widget.client.picture = imagePath.str;
                }
                Auth().updateClient(widget.client);
              }
              else {
                Toast.show("Veuillez remplir tout les champs", context,
                    duration: Toast.LENGTH_LONG);
              }
            }, child: Text("Enregistrer")),
            ElevatedButton(child: Text("Supprimer le compte"),
              onPressed: () async {
              dialog_supprimer();
              },
            )


          ],
        ),
      );
    }

    dialog_supprimer(){
      AlertDialog alertDialog=AlertDialog(

        title: Text("Supprimer compte ?"),
        actions: [
          ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.green),
          onPressed: (){
            Auth().deleteClient(widget.client);
            Navigator.of(context,rootNavigator: true).pop(context);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
              return MyApp("error");
            }),(Route<dynamic> route)=>false);
          }
          ,
            child: Text("Oui"),
          ),
          ElevatedButton(onPressed: (){
            Navigator.of(context,rootNavigator: true).pop(context);
          }, child: Text("Non"),
          style: ElevatedButton.styleFrom(primary: Colors.red),
          )
        ],
      );
      showDialog(barrierDismissible:false,context: context, builder: (buildcontext){
        return alertDialog;
      });
    }

    late List <Widget> pages;
    late Timer timer;
    late bool isVerified;
    @override
    void initState() {
      super.initState();
      getIsVerified();
      timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
        Auth().reload();
        setState(() {
          getIsVerified();
          if (isVerified) {
            timer.cancel();
          }
        });
      });
    }
    getIsVerified() async {
      isVerified = await Auth().isVerified();
    }
    @override
    Widget build(BuildContext context) {
      pages = [home_page(), infos_page(), conversations_page()];
      return WillPopScope(
          onWillPop: () async => false,
          child: isVerified ? Scaffold(
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: tabindex,
                onTap: (a) {
                  setState(() {
                    tabindex = a;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.event), label: "R??server",),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.perm_identity), label: "Modifier Infos",),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.message), label: "Conversations",),

                ],
              ),
              appBar: custom_appbar(widget.title, context, true, true),
              body: pages[tabindex]

          ) : Scaffold(
            appBar: custom_appbar(("Verify Email"), context, true, true),
            body: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Align(
                  child: Text(
                    "Verify Your Email",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.topLeft,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  " Veuillez v??rifier votre adresse e-mail\n ?? laquelle nous venons d'envoyer un email",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                ),
                SizedBox(height: 15.0,),

                // Button to reset Password email //

                    materialbutton(Colors.blue[200], "Renvoyer Email de Verification", context,(){
                      Auth().sendVerificationEmail();
                    }),

              ],
            ),
          ));
    }
  Widget materialbutton(couleur, text, context,onPressed) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: couleur,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: onPressed,
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0)
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

    int getAge(DateTime birthdate) {
      DateTime now = DateTime.now();


      int age = now.year - birthdate.year;

      if (now.month < birthdate.month ||
          (now.month == birthdate.month && now.day < birthdate.day)) {
        age--;
      }
      return age;
    }
  }

  class WrapperInt{
  late int str;
  WrapperInt(int str){
  this.str=str;
  }
  }