import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:prof_sport/models/Coach.dart';
import 'package:prof_sport/models/NotificationService.dart';
import 'package:prof_sport/models/ReservationService.dart';
import 'package:toast/toast.dart';

import 'CustomAppBar.dart';
import 'main.dart';
import 'models/AuthImplementation.dart';
import 'models/Client.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mailer/mailer.dart';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();

  Coach coach ;

  ReservationPage({required this.coach});

}

class _ReservationPageState extends State<ReservationPage> {
  String url="";
  DateTime? reservation;
  TimeOfDay? time;
  int duration=1;
  late String user_uid;
  String username = 'coachinowtest@gmail.com';
  String password = '1234@Abcd';

  Future<Null> getUrl(String path) async{
    url=await Auth().downloadURL(path);
  }
/*  Future<Null> getUid() async{
    user_uid=await Auth().getCurrentUserUid();
  }
*/
  @override
  Widget build(BuildContext context) {
    final smtpServer = gmail(username, password);
    return Scaffold(
      appBar: custom_appbar("Réserver ", context,false,false),
      body: Column(
        children:
        [
           SizedBox(height: 40,),
          FutureBuilder(

              future: getUrl(widget.coach.picture),
              builder: (context,snapshot){
                getUrl(widget.coach.picture);
            return   Center(child: Container(width: 40,height: 40,decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(url)
            )
            ),),);
          }),
          SizedBox(height: 30,),
          Center(
            child: Wrap(
              children:
              [
              Text(widget.coach.firstname),
              SizedBox(width: 5,),
              Text(widget.coach.lastname),
              ],
            ),
          ),
          SizedBox(height: 20,),

          Text(widget.coach.city),
          SizedBox(height: 10,),
          Text(widget.coach.price.toString()),
          SizedBox(height: 10,),
          Text(widget.coach.sport),
          SizedBox(height: 10,),
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            color: Colors.grey.shade200,
            onPressed: choisirJour,
            child: Text(reservation != null
                ? "${reservation!.day}/${reservation!.month}/${reservation!.year}"
                : "Jour de la séance"),
          ),
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            color: Colors.grey.shade200,
            onPressed: choisirHeure,
            child: Text(time != null
                ? "${time!.hour}:${time!.minute}"
                : "Heure de la séance"),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                children: [
                  Icon(Icons.lock_clock),
                  Text("Durée de réservation"),
                ],
              ),
              DropdownButton<int>(
                value: duration,
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    duration = newValue!;
                  });
                },

                items:<int>[1, 2,3]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      value.toString()+"h",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  );
                }).toList(),
              )
            ],
          ),


          Center(child: ElevatedButton(
            onPressed: () async {
              Client client = await Auth().getCurrentClient();
              if (await ReservationService().isAlreadyBooked(client,
                  reservation!.add(Duration(
                      hours: time!.hour, minutes: time!.minute, seconds: 0)),
                  duration)) {
                Toast.show("Already Booked", context);
              }
              else {
                ReservationService().add_reservation(
                    widget.coach.uid, await Auth().getCurrentUserUid(),
                    reservation!.add(Duration(
                        hours: time!.hour, minutes: time!.minute, seconds: 0)),
                    duration);
                final message = Message()
                  ..from = Address(username, 'Coachinow')
                  ..recipients.add(widget.coach.email)
                  ..subject = "Vous avez reçu une nouvelle demande !"
                  ..text = "Vous avez reçu une demande pour une séance de la part de ${client.firstname} ${client.lastname} le ${reservation!.add(Duration(
                      hours: time!.hour, minutes: time!.minute, seconds: 0))} ";
                try {
                  final sendReport = await send(message, smtpServer);
                  print('Message sent: ' + sendReport.toString());
                } on MailerException catch (e) {
                  print('Message not sent.');
                  for (var p in e.problems) {
                    print('Problem: ${p.code}: ${p.msg}');
                  }
                }
                Toast.show("Réservation réussie", context);
                Navigator.pop(context);
              }
            },
            child: Text("Reserver"),
          ),)



        ],
      ),
    );
  }
  Future<Null> choisirJour() async {
    DateTime? res = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days:30)));
    if (res != null) {
      setState(() {
        reservation = res;
      });
    }
  }
  Future<Null> choisirHeure() async {
    TimeOfDay? res = await showTimePicker(
        context: context,
    initialTime: TimeOfDay.now());
    if (res != null) {
      setState(() {
        time = res;
      });
    }
  }



}
