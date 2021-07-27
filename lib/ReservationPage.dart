import 'package:flutter/material.dart';
import 'package:prof_sport/models/Coach.dart';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();

  Coach coach ;

  ReservationPage({required this.coach});

}

class _ReservationPageState extends State<ReservationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fiche Coach"),
      ),
      body: Text(widget.coach.phone),
    );
  }
}
