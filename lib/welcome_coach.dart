import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:prof_sport/models/Client.dart';
import 'package:prof_sport/models/Coach.dart';
import 'package:prof_sport/models/ReservationService.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CustomAppBar.dart';
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
  Future<Null>get_reservations() async{
    reservations.clear();
    reservations=await widget.reservationService.get_coach_reservations(widget.coach.uid);
  }

  Future<Null> getClient(String id) async
  {
    var docs=(await FirebaseFirestore.instance.collection("users").
    where("id",isEqualTo: id).snapshots().first).docs[0];
    client=Client(docs["id"], "", docs["birthdate"].toDate(),"", docs["city"], docs["address"], docs["firstname"], docs["lastname"], docs["phone"],docs["picture"]);
    url=await Auth().downloadURL(client.picture);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: custom_appbar("Réserver ", context),
    body:
    StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("reservations").
    where("idCoach",isEqualTo: widget.coach.uid).snapshots(),
    builder: (context,snapshot) {
    return snapshot.data==null ? Text("null"):ListView.builder(
    shrinkWrap: true,
    itemCount: snapshot.data?.docs.length,
    itemBuilder: (context,index){
    return snapshot.data==null?Text(""):StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("users").
    where("id",isEqualTo: snapshot.data?.docs[index]["idClient"]).snapshots(),
    builder: (context,snap){
    client=Client(snap.data?.docs[0]["id"], "", snap.data?.docs[0]["birthdate"].toDate(),
    "", snap.data?.docs[0]["city"], snap.data?.docs[0]["address"],
    snap.data?.docs[0]["firstname"], snap.data?.docs[0]["lastname"],
    snap.data?.docs[0]["phone"],
    snap.data?.docs[0]["picture"],
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
      Text("${dateDebut.day}/${dateDebut.month}/${dateDebut.year} \n ${dateDebut.hour}:${dateDebut.minute}"),
      SizedBox(width: 5,),
      Text("${snapshot.data?.docs[index]["duration"]}h"),

      Spacer(),
    snapshot.data?.docs[index]["isConfirmed"] == false ?
    Wrap( children:
    [
    ElevatedButton(onPressed: ()
    {
        ReservationService().confirm_reservation(Reservation(id:snapshot.data?.docs[index]["id"],
            idcoach: snapshot.data?.docs[index]["idCoach"],idclient: snapshot.data?.docs[index]["idClient"],
            duration: snapshot.data?.docs[index]["duration"],
            isConfirmed: snapshot.data?.docs[index]["isConfirmed"],
            dateDebut:  snapshot.data?.docs[index]["dateDebut"].toDate()
        ));
    },
    child: Text("Valider")),
    SizedBox(width: 5,),
    ElevatedButton(onPressed: ()async
    {
    ReservationService().refus_reservation(Reservation(id:snapshot.data?.docs[index]["id"],
    idcoach: snapshot.data?.docs[index]["idCoach"],idclient: snapshot.data?.docs[index]["idClient"],
    duration: snapshot.data?.docs[index]["duration"],
    isConfirmed: snapshot.data?.docs[index]["isConfirmed"],
    dateDebut:  snapshot.data?.docs[index]["dateDebut"].toDate()
    ));
    },
    child: Text("Refuser")

      ,
      style: ElevatedButton.styleFrom(primary: Colors.red),

    )
    ],)  :
    Wrap(
      children:[
        ElevatedButton(
          onPressed: ()
          {
            print("validé");

          },
          child: Text("Validé"),
          style: ElevatedButton.styleFrom(primary: Colors.green),

        ),
        SizedBox(width: 5,),

        ElevatedButton(
          onPressed: () async
          {
            await launch("tel:"+snap.data?.docs[0]["phone"]) ;
          },
          child: Icon(Icons.phone, color: Colors.white,),
          style: ElevatedButton.styleFrom(primary: Colors.green),
        )
      ],

    ),


    ]);

    }
    );


    });
    }
    )
    );


  }


}
