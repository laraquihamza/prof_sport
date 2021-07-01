import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:toast/toast.dart';
import 'SignupPage.dart';
class Welcome extends StatefulWidget{
  final String title;
  final User user;
  Welcome({Key? key, required this.title, required this.user}) : super(key: key);
  @override
  _Welcome createState() {
    return _Welcome();
  }
}
class _Welcome extends State<Welcome>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children:[Text(widget.user.email!)]
        ),
      ),
    );
  }

}