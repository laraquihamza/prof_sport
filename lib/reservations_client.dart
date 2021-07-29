import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:prof_sport/CustomAppBar.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:prof_sport/models/Client.dart';
import 'package:prof_sport/models/Coach.dart';
import 'package:prof_sport/models/ReservationService.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'models/Reservation.dart';
class ListeDemande extends StatefulWidget {
  final String title;
  final Client client;
  ReservationService reservationService = ReservationService();
  ListeDemande({Key? key, required this.title, required this.client})
      : super(key: key);
  @override
  _ListeDemande createState() {
    return _ListeDemande();
  }
}
class _ListeDemande extends State<ListeDemande> {
  late Coach coach;
  String url="";
Future<Null> get_url(String path) async{
  url=await Auth().downloadURL(path);

}

  @override
  Widget build(BuildContext context) {
    ReservationService().get_client_reservations(widget.client.uid);
    return Scaffold(
        appBar: custom_appbar(widget.title, context),
        body:
        Column(
            children: [
              Text("Bonjour Client"),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("reservations").
                  where("idClient",isEqualTo: widget.client.uid).snapshots(),
                  builder: (context,snapshot) {
                    return snapshot.data==null ? Text("null"):ListView.builder(
                      shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context,index){
                        DateTime dateDebut=snapshot.data!.docs[index]["dateDebut"].toDate();
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection("coaches").
                          where("id",isEqualTo: snapshot.data!.docs[index]["idCoach"]).snapshots(),
                          builder: (context,snap){
                            coach=Coach(snap.data!.docs[0]["id"], "", snap.data!.docs[0]["birthdate"].toDate(),
                                "", snap.data!.docs[0]["city"], snap.data!.docs[0]["address"],
                                snap.data!.docs[0]["firstname"], snap.data!.docs[0]["lastname"],
                                snap.data!.docs[0]["phone"],
                                snap.data!.docs[0]["picture"],
                                snap.data!.docs[0]["price"],snap.data!.docs[0]["sport"]);
                                return
                              Row(children:[
                                StreamBuilder(
                                    stream: FirebaseStorage.instance.ref(snap.data!.docs[0]["picture"]).getDownloadURL().asStream(),
                                    builder: (context,snap2){
                                  return                                 Container(width: 40,height: 40,decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(

                                          image: NetworkImage(snap2.data!.toString())
                                      )
                                  ),);

                                }),
                                SizedBox(width: 5,),
                                Text("${coach.firstname}\n${coach.lastname}"),
                                SizedBox(width: 5,),
                                Text("${dateDebut.day}/${dateDebut.month}/${dateDebut.year} \n ${dateDebut.hour}:${dateDebut.minute}"),
                                SizedBox(width: 5,),
                                Text("${snapshot.data!.docs[index]["duration"]}h"),

                                Spacer(),
                                snapshot.data!.docs[index]["isConfirmed"] == false ?
                                Wrap( children:
                                [
                                  ElevatedButton(onPressed: ()
                                  {

                                  },
                                      child: Text("Waitting")),
                                  SizedBox(width: 5,),
                                  ElevatedButton(onPressed: ()async
                                  {
                                    ReservationService().refus_reservation(Reservation(id:snapshot.data!.docs[index]["id"],
                                        idcoach: snapshot.data!.docs[index]["idCoach"],idclient: snapshot.data!.docs[index]["idClient"],
                                        duration: snapshot.data!.docs[index]["duration"],
                                        isConfirmed: snapshot.data!.docs[index]["isConfirmed"],
                                        dateDebut:  snapshot.data!.docs[index]["dateDebut"].toDate()
                                    ));
                                  },
                                      child: Text("Annuler"),
                                    style: ElevatedButton.styleFrom(primary: Colors.red),

                                  ),

                                ],)  :
                                ElevatedButton(
                                    onPressed: ()
                                    {
                                      print("validé");

                                    },
                                    child: Text("Validé"),
                                  style: ElevatedButton.styleFrom(primary: Colors.green),

                                ),


                              ]);

                          },

                        );
                          print("urlclient:$url");

                        });
                  }
              )
            ]
        )


    );
  }
}



