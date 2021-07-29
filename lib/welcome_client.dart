import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
class Wrapper{
  late String str;
  Wrapper(String str){
    this.str=str;
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
  List<Widget> docs = [];
  Wrapper city= Wrapper('Agadir');
  Wrapper sport= Wrapper('Boxe');
  WrapperInt tarif=WrapperInt(100);
  late MeetingDataSource meetingDataSource;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: custom_appbar(widget.title, context),
      body:
          Column(
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
                items:List<int>.generate(10, (index) => (index*50)+100)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      value.toString()+" DH/h",
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
                child: ElevatedButton(child: Text("Recherche"),onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchResult(city.str,sport.str,tarif.str)));
                },),


              ),
              SizedBox(height: 40,),
              ElevatedButton(child: Text("Liste RDV"),onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ListeDemande(client: widget.client, title: 'Liste RDV')));
              },),


            ],
          )

    );
  }


}
class MeetingDataSource extends CalendarDataSource{
  MeetingDataSource(List<Appointment> source){
    appointments=source;
  }
}
class WrapperInt{
  late int str;
  WrapperInt(int str){
    this.str=str;
  }
}