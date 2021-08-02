import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:prof_sport/CustomAppBar.dart';
import 'package:prof_sport/ReservationPage.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:prof_sport/models/Coach.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SearchResult extends StatefulWidget {
  late String city;
  late String sport;
  late int tarif;
  SearchResult(String city, String sport, int tarif){
    this.city=city;
    this.sport=sport;
    this.tarif=tarif;
  }
  @override
  _SearchResult createState() => _SearchResult();

}

class _SearchResult extends State<SearchResult> {
  String url="";
  Future<Null> getUrl(String path) async{
    url=await Auth().downloadURL(path);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: custom_appbar("Recherche", context,false),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("coaches").
        where("city",isEqualTo: widget.city).where("sport",isEqualTo:widget.sport).snapshots(),
        builder: (context,snapshot){

          return (snapshot.connectionState==ConnectionState.waiting?
          Center(child:CircularProgressIndicator()):
              ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index
                  )  {
                return StreamBuilder(
                  stream: FirebaseStorage.instance.ref(snapshot.data!.docs[index]["picture"]).getDownloadURL().asStream(),
                    builder: (context,snap){
                      return Row(
                        children: [
                      snapshot.data!.docs[index]["price"]<=widget.tarif?Row(children:[
                        Container(width: 40,height: 40,decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(snap.data.toString())
                          )
                        ),),
                        SizedBox(width: 5,),
                        Text(snapshot.data!.docs[index]["firstname"]),
                        SizedBox(width: 5,),
                        Text(snapshot.data!.docs[index]["lastname"]),
                        SizedBox(width: 5,),
                        Text("${snapshot.data!.docs[index]['price']}DH/h"),
                        SizedBox(width: 20,),


                        //  Spacer(),
                        ElevatedButton(

                            onPressed: ()
                          {
                            Coach coach=Coach(snapshot.data!.docs[index]["id"],
                          "",
                          snapshot.data!.docs[index]["birthdate"].toDate(),
                          "", snapshot.data!.docs[index]["city"],
                          snapshot.data!.docs[index]["address"],
                          snapshot.data!.docs[index]["firstname"],
                          snapshot.data!.docs[index]["lastname"],
                          snapshot.data!.docs[index]["phone"],
                            snapshot.data!.docs[index]["picture"],
                              snapshot.data!.docs[index]["price"],
                              snapshot.data!.docs[index]["sport"]
                            ) ;
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ReservationPage(coach: coach,)
                              ));
                          },
                         child: Text("Reserver"))
                      ]):Text(''),
                        ],
                      );

                    }
                );

              })
          );
        },
      )
    );
  }
}
