import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:prof_sport/CustomAppBar.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:prof_sport/models/Client.dart';
import 'package:prof_sport/models/Coach.dart';
import 'package:prof_sport/models/ReservationService.dart';
import 'package:prof_sport/paymentScreen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:prof_sport/client_exercices.dart';
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
        appBar: custom_appbar(widget.title, context,false,false),
        body:
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("reservations").
                        where("idClient",isEqualTo: widget.client.uid).snapshots(),
                        builder: (context,snapshot) {

                          return snapshot.data==null ? Text(""):ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context,index){
                                DateTime dateDebut=snapshot.data?.docs[index]["dateDebut"].toDate();
                                Reservation reservation=Reservation(id:snapshot.data?.docs[index]["id"],
                                  idcoach: snapshot.data?.docs[index]["idCoach"],idclient: snapshot.data?.docs[index]["idClient"],
                                  duration: snapshot.data?.docs[index]["duration"],
                                  isConfirmed: snapshot.data?.docs[index]["isConfirmed"],
                                  dateDebut:  snapshot.data?.docs[index]["dateDebut"].toDate(),
                                  isPaid: snapshot.data?.docs[index]["isPaid"],
                                  isOver: snapshot.data?.docs[index]["isOver"]
                                );
                                return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection("coaches").
                                  where("id",isEqualTo: snapshot.data?.docs[index]["idCoach"]).snapshots(),
                                  builder: (context,snap){
                                    coach=Coach(snap.data?.docs[0]["id"], "", snap.data?.docs[0]["birthdate"].toDate(),
                                        "", snap.data?.docs[0]["city"], snap.data?.docs[0]["address"],
                                        snap.data?.docs[0]["firstname"], snap.data?.docs[0]["lastname"],
                                        snap.data?.docs[0]["phone"],
                                        snap.data?.docs[0]["picture"],
                                        snap.data?.docs[0]["price"],snap.data?.docs[0]["sport"],snap.data?.docs[0]["cin"],
                                        snap.data?.docs[0]["cv"],snap.data?.docs[0]["diplome"]);
                                    return
                                      snapshot.data==null ? Text(""):Row(children:[
                                        StreamBuilder(
                                            stream: FirebaseStorage.instance.ref(snap.data?.docs[0]["picture"]).getDownloadURL().asStream(),
                                            builder: (context,snap2){
                                              return                     snap2.data==null ? Text(""):            Container(width: 40,height: 40,decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(

                                                      image: NetworkImage(snap2.data.toString())
                                                  )
                                              ),);

                                            }),
                                        SizedBox(width: 5,),
                                        Text("${coach.firstname}\n${coach.lastname}"),
                                        SizedBox(width: 5,),
                                        Text("${dateDebut.day}/${dateDebut.month}/${dateDebut.year} \n ${dateDebut.hour}:${dateDebut.minute}"),
                                        SizedBox(width: 5,),
                                        Text("${snapshot.data?.docs[index]["duration"]}h"),

                                        Spacer(),
                                        snapshot.data?.docs[index]["isConfirmed"] == false ?
                                        Wrap( children:
                                        [
                                          IconButton(onPressed: (){}, icon: Icon(Icons.schedule, color: Colors.grey)),
                                          IconButton(icon:Icon(Icons.close,color: Colors.red,
                                            ),
                                            onPressed: ()async
                                            {
                                            ReservationService().refus_reservation(reservation);
                                            },
                                            ),

                                        ],)  :
                                        Wrap(
                                          children:[
                                            !(snapshot.data?.docs[index]["isPaid"])?ElevatedButton(
                                              onPressed: ()
                                              {
                                                print("Payer");
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>paymentScreen(reservation : reservation)));

                                              },
                                              child: Text("Payer"),
                                              style: ElevatedButton.styleFrom(primary: Colors.green),

                                            ):ElevatedButton(
                                              onPressed: ()
                                              {
                                                launch("tel:"+snap.data?.docs[0]["phone"]);

                                              },
                                              child: Text("Tel")
                                    ),

                                            SizedBox(width: 5,),

                                            !(snapshot.data?.docs[index]["isOver"])?ElevatedButton(
                                              onPressed: () async
                                              {
                                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                                  return ClientExercices(reservation: reservation);
                                                })) ;
                                              },
                                              child: Text("Programme "),
                                              style: ElevatedButton.styleFrom(primary: Colors.green),
                                            ):Text("")
                                          ],

                                        ),


                                      ]);

                                  },

                                );
                                print("urlclient:$url");

                              });
                        }
                    )
              );


  }
}



