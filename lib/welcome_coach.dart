import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:prof_sport/ChatScreenCoach.dart';
import 'package:prof_sport/coach_exercices.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:prof_sport/models/Client.dart';
import 'package:prof_sport/models/Coach.dart';
import 'package:prof_sport/models/ReservationService.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CustomAppBar.dart';
import 'models/Conversation.dart';
import 'models/ConversationService.dart';
import 'models/NotificationService.dart';
import 'models/Reservation.dart';
class Welcome_Coach extends StatefulWidget {
  final String title;
  final Coach coach;
  ReservationService reservationService = ReservationService();
  Welcome_Coach({Key? key, required this.title, required this.coach})
      : super(key: key);
  @override
  _Welcome_Coach createState() {
    return _Welcome_Coach();
  }
}
class _Welcome_Coach extends State<Welcome_Coach> {
  List<Reservation> reservations = [];
  late Client client;
  String url="";
  String username = 'coachinowtest@gmail.com';
  String password = '1234@Abcd';
  late Timer timer;
  late bool isVerified;
  int index=0;
  getIsVerified()async{
      isVerified= await Auth().isVerified();

  }
   @override
   void initState(){
     super.initState();
     getIsVerified();
     timer= Timer.periodic(Duration(milliseconds: 500),(timer)async{
       Auth().reload();
       setState(() {
         getIsVerified();
         if(isVerified){
           timer.cancel();
         }
       });

     });
   }
   @override void dispose(){
     timer.cancel();
      super.dispose();
   }
  Future<Null>get_reservations() async{
    reservations.clear();
    reservations=await widget.reservationService.get_coach_reservations(widget.coach.uid);
  }

  Widget conversations_page() {
    return
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("conversations").where(
              "idCoach", isEqualTo: widget.coach.uid).snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasData ? InkWell(
              onTap: ()async{
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ChatScreenCoach(conversation: Conversation(id:snapshot.data!.docs[index]["id"],
                      idCoach:snapshot.data!.docs[index]["idCoach"],idClient: snapshot.data!.docs[index]["idClient"]));
                }));
              },
              child: ListView.builder(shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("users")
                          .where("id", isEqualTo: doc["idClient"])
                          .snapshots(),
                      builder: (context, snap) {
                        return snap.hasData ? Wrap(children: [
                          StreamBuilder(
                            stream: Auth().downloadURL(snap.data!.docs[0]["picture"]).asStream(),
                            builder: (context,snappicture){
                              return Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(snappicture.data as String)
                                    )
                                ),
                              );
                            },
                          ),
                          Text(snap.data!.docs[0]["firstname"]),
                          Text(snap.data!.docs[0]["lastname"]),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection("messages").where("idConversation",isEqualTo: doc["id"]).orderBy("date").snapshots(),
                            builder: (context,snap2){
                              int length=0;
                              var doc;
                              if(snap2.hasData){
                                length=snap2.data!.docs.length-1;
                                if(length!=-1){
                                  doc=snap2.data!.docs[length];
                                }
                              }
                              return snap2.hasData?Wrap(
                                children: [
                                  length!=-1?Text(get_substring(doc["message"])):Text(""),
                                  length!=-1?Text("${doc["date"].toDate()}"):Text("")

                                ],
                              ):Text("");
                            },
                          )
                        ]
                        )
                            : Text("");
                      },
                    );
                  }
              ),
            ) : Text("");
          }
      );
  }
  String get_substring(String s){
    if(s.length>10){
      return s.substring(0,10);
    }
    return s;
  }

  Future<Null> getClient(String id) async
  {
    var docs=(await FirebaseFirestore.instance.collection("users").
    where("id",isEqualTo: id).snapshots().first).docs[0];
    client=Client(docs["id"], docs["email"], docs["birthdate"].toDate(),"", docs["city"], docs["address"], docs["firstname"],
        docs["lastname"], docs["phone"],docs["picture"],docs["imc"],docs["img"],docs["height"],docs["weight"],docs["gender"]);
    url=await Auth().downloadURL(client.picture);
    print("email:${docs["email"]}");
  }
  int tabindex=0;
  List<Widget> tabs=[];
  @override
  Widget build(BuildContext context) {
    getIsVerified();
    tabs=[reservations_coach(context),infos_page(),conversations_page()];
            return WillPopScope(
              onWillPop: ()async=>false,
              child: isVerified?Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: custom_appbar("Réserver ", context,true,true),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: tabindex,
                    onTap: (a){
                      setState(() {
                        tabindex = a;

                      });
                    },
                    items: [
                      BottomNavigationBarItem(icon: Icon(Icons.event),label: "Mes demandes",),
                      BottomNavigationBarItem(icon: Icon(Icons.perm_identity), label: "Modifier Infos",),
                      BottomNavigationBarItem(icon: Icon(Icons.message), label: "Conversations",),

                    ],
                  ),

                  body: tabs[tabindex]
    ):Scaffold(
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
                      " Veuillez vérifier votre adresse e-mail\n à laquelle nous venons d'envoyer un email",
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

  Widget reservations_coach(BuildContext context){
    final smtpServer = gmail(username, password);

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("reservations").
        where("idCoach",isEqualTo: widget.coach.uid).snapshots(),
        builder: (context,snapshot) {

          return snapshot.data==null ? Text("null"):ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context,index){
                Reservation reservation=Reservation(id:snapshot.data?.docs[index]["id"],
                    idcoach: snapshot.data?.docs[index]["idCoach"],idclient: snapshot.data?.docs[index]["idClient"],
                    duration: snapshot.data?.docs[index]["duration"],
                    isConfirmed: snapshot.data?.docs[index]["isConfirmed"],
                    dateDebut:  snapshot.data?.docs[index]["dateDebut"].toDate(),
                    isPaid: snapshot.data?.docs[index]["isPaid"],
                    isOver: snapshot.data?.docs[index]["isOver"]
                );
                return snapshot.data==null?Text(""):StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("users").
                    where("id",isEqualTo: snapshot.data?.docs[index]["idClient"]).snapshots(),
                    builder: (context,snap){
                      client=Client(snap.data?.docs[0]["id"], snap.data?.docs[0]["email"], snap.data?.docs[0]["birthdate"].toDate(),
                        "", snap.data?.docs[0]["city"], snap.data?.docs[0]["address"],
                        snap.data?.docs[0]["firstname"], snap.data?.docs[0]["lastname"],
                        snap.data?.docs[0]["phone"],
                        snap.data?.docs[0]["picture"],
                        snap.data?.docs[0]["imc"],
                        snap.data?.docs[0]["img"], snap.data?.docs[0]["height"],
                        snap.data?.docs[0]["weight"],
                        snap.data?.docs[0]["gender"],
                      );
                      DateTime dateDebut=snapshot.data?.docs[index]["dateDebut"].toDate();
                      return
                        Row(children:[
                          StreamBuilder(
                              stream: FirebaseStorage.instance.ref(snap.data?.docs[0]["picture"]).getDownloadURL().asStream(),
                              builder: (context,snap2){

                                return                                 Container(width: 40,height: 40,decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(

                                        image: NetworkImage(snap2.data.toString())
                                    )
                                ),);

                              }),
                          SizedBox(width: 5,),
                          Text("${client.firstname}\n${client.lastname}"),
                          SizedBox(width: 5,),
                          Text("${dateDebut.day}/${dateDebut.month}/${dateDebut.year} \n ${dateDebut.hour}:${dateDebut.minute}-${dateDebut.hour+snapshot.data?.docs[index]["duration"]}:${dateDebut.minute}"),

                          Spacer(),
                          snapshot.data?.docs[index]["isConfirmed"] == false ?
                          Wrap( children:
                          [
                            IconButton(onPressed: () async
                            {

                              /*final message = Message()
                                ..from = Address(username, 'Coachinow')
                                ..recipients.add(client.email)
                                ..subject =  "Votre demande de rendez-vous a été validée !"
                                ..text = "Votre demande de rendez-vous le ${reservation.dateDebut} a été validée par ${widget.coach.firstname} ${widget.coach.lastname} ";
                              try {
                                final sendReport = await send(message, smtpServer);
                                print('Message sent: ' + sendReport.toString());
                              } on MailerException catch (e) {
                                print('Message not sent.');
                                for (var p in e.problems) {
                                  print('Problem: ${p.code}: ${p.msg}');
                                }
                              }*/

                              ReservationService().confirm_reservation(reservation);
                            },
                                icon: Icon(Icons.check,color: Colors.green,)),
                            SizedBox(width: 5,),
                            IconButton(onPressed: ()async
                            {

                              NotificationService().sendNotification(client.uid, "Votre demande a été refusée !");

                              ReservationService().refus_reservation(reservation);
                            },
                              icon: Icon(Icons.close,color: Colors.red)


                            )
                          ],)  :
                          snapshot.data?.docs[index]["isPaid"]?
                          Wrap(
                            children:[
                              IconButton(
                                onPressed: () async
                                {
                                  if(!await ConversationService().conversation_exists(widget.coach, client)){
                                    await ConversationService().create_conversation(widget.coach, client);
                                  }
                                  Conversation conversation=await ConversationService().get_conversation(client, widget.coach);
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreenCoach(conversation:conversation )));
                                },
                                icon: Icon(Icons.message, color: Colors.black,),
                              ),
                              SizedBox(width: 5,),
                              ElevatedButton(
                                onPressed: () async
                                {

                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return CoachExercices(reservation: Reservation(id:snapshot.data?.docs[index]["id"],
                                        idcoach: snapshot.data?.docs[index]["idCoach"],idclient: snapshot.data?.docs[index]["idClient"],
                                        duration: snapshot.data?.docs[index]["duration"],
                                        isConfirmed: snapshot.data?.docs[index]["isConfirmed"],
                                        dateDebut:  snapshot.data?.docs[index]["dateDebut"].toDate(),
                                        isPaid: snapshot.data?.docs[index]["isPaid"],
                                        isOver: snapshot.data?.docs[index]["isOver"]
                                    ));
                                  }));
                                  print("validé");

                                },
                                child: Text("Programme"),
                                style: ElevatedButton.styleFrom(primary: Colors.green),

                              ),

                            ],

                          ):
                          Text("En Attente de paiement"),


                        ]);

                    }
                );


              });
        }
    );
  }

  Future<Null> uploadPicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath.str = image!.path;
    });
    print("imageStr:${imagePath.str}");

  }
  Future<Null> getDownloadUrl() async{
    imageUrl.str=await Auth().downloadURL(widget.coach.picture);
  }
  Wrapper imageUrl=Wrapper("");
  Wrapper imagePath=Wrapper("");

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
                widget.coach.picture == "" ? Icon(
                  Icons.account_circle, size: 120.0,) :
                FutureBuilder(
                    future: getDownloadUrl(),
                    builder: (context, snapshot2) {
                      return Container(
                        width: 120,
                        height: 120,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: imagePath.str==""? new DecorationImage(
                              image: new NetworkImage(imageUrl.str),
                              fit: BoxFit.fill,
                            ):
                            new DecorationImage(
                              image:  new FileImage(File(imagePath.str)),
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
          Text("Numéro de télephone"),
          TextField(
            onChanged: (String? s){
              widget.coach.phone=s.toString();
            },

            controller: TextEditingController(
              text: widget.coach.phone,
            ),
          ),
          Text("Adresse"),
          TextField(
            onChanged: (String? s){
              widget.coach.address=s.toString();
            },
            controller: TextEditingController(
              text: widget.coach.address,
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Text("Ville"),
          ),
          DropdownButton<String>(
            isExpanded: true,
            value: widget.coach.city,
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
                widget.coach.city = newValue!;
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
          Align(
            alignment: Alignment.topLeft,
            child: Text("Specialite"),
          ),
          DropdownButton<String>(
            isExpanded: true,
            value: widget.coach.sport,
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
                widget.coach.sport = newValue!;
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


          ElevatedButton(onPressed: (){
            if(widget.coach.address!="" && widget.coach.phone!=""){
              print("address"+widget.coach.address);
              if(imagePath.str!=""){
                Auth().UploadDocument(imagePath.str);
                widget.coach.picture=imagePath.str;
              }
              Auth().updateCoach(widget.coach);
            }
            else{
              Toast.show("Veuillez remplir tout les champs", context,duration: Toast.LENGTH_LONG);
            }

          }, child: Text("Enregistrer"))


        ],
      ),
    );
  }



}
