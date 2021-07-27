import 'package:flutter/material.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:prof_sport/models/Coach.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
class Welcome_Coach extends StatefulWidget {
  final String title;
  final Coach coach;
  Welcome_Coach({Key? key, required this.title, required this.coach})
      : super(key: key);
  @override
  _Welcome_Coach createState() {
    return _Welcome_Coach();
  }
}

class _Welcome_Coach extends State<Welcome_Coach> {
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
        Text("Bonjour Coach")
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
