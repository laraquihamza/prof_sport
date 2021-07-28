import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:prof_sport/models/Client.dart';
import 'package:prof_sport/models/Coach.dart';
class ReservationService{
  void add_reservation(String idCoach,String idClient,DateTime dateDebut,int duration){
    FirebaseFirestore.instance.collection("reservations").doc().set({
      'idCoach':idCoach,
      'idClient':idClient,
      'dateDebut':dateDebut,
      'duration':duration,
      'isConfirmed': false
    });
  }
}