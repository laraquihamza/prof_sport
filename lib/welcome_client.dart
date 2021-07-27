import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:toast/toast.dart';
import 'package:prof_sport/models/Client.dart';
import 'Signup_Client.dart';
import 'Signup_Coach.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
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
  late MeetingDataSource meetingDataSource;
  @override
  Widget build(BuildContext context) {
    meetingDataSource=MeetingDataSource(getAppointments());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
        Text("Bonjour Client"),
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
