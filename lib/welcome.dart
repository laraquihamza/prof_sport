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
class Welcome extends StatefulWidget {
  final String title;
  final Client client;
  Welcome({Key? key, required this.title, required this.client})
      : super(key: key);
  @override
  _Welcome createState() {
    return _Welcome();
  }
}

class _Welcome extends State<Welcome> {
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
          SfCalendar(
          view: CalendarView.week,
          monthViewSettings: MonthViewSettings(showAgenda: true),
            dataSource: meetingDataSource,
            onTap: (x){
            meetingDataSource.appointments!.add(Appointment(subject:"Séance [A confirmer]",startTime: x.date!, endTime: x.date!.add(Duration(hours:1))));
            meetingDataSource!.notifyListeners(CalendarDataSourceAction.add, meetingDataSource.appointments!);
            },
        )
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
  Future<Null> list_documents() async {
    List list = await Auth().get_documents();
    print("kkikii$list");
    for (int i = 0; i < list.length; i++) {
      docs.add(Text(list[i]));
    }
  }
}
class MeetingDataSource extends CalendarDataSource{
  MeetingDataSource(List<Appointment> source){
    appointments=source;
  }
}
