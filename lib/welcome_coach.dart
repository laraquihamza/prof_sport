import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:prof_sport/models/Client.dart';
import 'package:prof_sport/models/Coach.dart';
import 'package:prof_sport/models/ReservationService.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
    ReservationService().get_coach_reservations(widget.coach.uid);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body:
            Column(
                  children: [
                    Text("Bonjour Coach"),
                    FutureBuilder(
                        future: get_reservations(),
                        builder: (context,snapshot) {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: reservations.length,
                              itemBuilder: (context, index) {
                                return Column(
                                    children: [
                                      FutureBuilder(
                                          future: getClient(reservations[index].idclient),
                                          builder: (context,snapshot) {
                                            getClient(reservations[index].idclient);
                                            print("urlclient:$url");
                                        return reservations.length == 0 ? Text("Liste Vide") :
                                        Row(children:[
                                          Container(width: 40,height: 40,decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: NetworkImage(url,)
                                              )
                                          ),),
                                          SizedBox(width: 5,),
                                          Text(client.firstname),
                                          SizedBox(width: 5,),
                                          Text(client.lastname),
                                          Spacer(),
                                          reservations[index].isConfirmed == false ?
                                         Wrap( children:
                                         [
                                           ElevatedButton(onPressed: ()
                                           {
                                             setState(() {
                                               ReservationService().confirm_reservation(reservations[index]);
                                             });

                                           },
                                               child: Text("Valider")),
                                           SizedBox(width: 5,),
                                           ElevatedButton(onPressed: ()async
                                           {
                                             ReservationService().refus_reservation(reservations[index]);
                                             setState(() {
                                               get_reservations();
                                             });
                                           },
                                               child: Text("Refuser"))
                                         ],)  :
                                          ElevatedButton(
                                              onPressed: ()
                                          {
                                           print("validé");

                                          },
                                              child: Text("Validé")),


                                        ]);
                                      })
                                    ]
                                );
                              }
                          );
                        }
                    )
                  ],
                ),
    );
  }


  List<Appointment> getAppointments(){
    List <Appointment> meetings= <Appointment>[];
    final DateTime today= DateTime.now();
    final DateTime startTime= DateTime(today.year,today.month,today.day,9,0,0);
    final DateTime endTime= DateTime(today.year,today.month,today.day,11,0,0);
    meetings.add(Appointment(startTime: startTime, endTime: endTime, subject: "TTT"));
    return meetings;
  }
}
class MeetingDataSource extends CalendarDataSource{
  MeetingDataSource(List<Appointment> source){
    appointments=source;
  }
}
