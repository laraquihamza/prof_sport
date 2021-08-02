import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prof_sport/models/Coach.dart';
import 'package:prof_sport/models/ReservationService.dart';
import 'package:toast/toast.dart';

import 'CustomAppBar.dart';
import 'main.dart';
import 'models/AuthImplementation.dart';

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
  Future<Null> getUrl(String path) async{
    url=await Auth().downloadURL(path);
  }
/*  Future<Null> getUid() async{
    user_uid=await Auth().getCurrentUserUid();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: custom_appbar("Réserver ", context,false),
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


              ReservationService().add_reservation(widget.coach.uid, await Auth().getCurrentUserUid(), reservation!.add(Duration(hours:time!.hour,minutes: time!.minute,seconds: 0)), duration);
              Toast.show("Réservation réussie", context);
              Navigator.pop(context);
              print("nada"); },
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
