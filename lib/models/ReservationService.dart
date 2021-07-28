import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prof_sport/models/AuthImplementation.dart';
import 'package:prof_sport/models/Client.dart';
import 'package:prof_sport/models/Coach.dart';
import 'package:prof_sport/models/Reservation.dart';
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
  Future<List<Reservation>> get_coach_reservations(String idCoach) async{
    List<Reservation> res= [];
    var docs=(await FirebaseFirestore.instance.collection("reservations").
    where("idCoach",isEqualTo: idCoach).snapshots().first).docs;
    var c;
    for(c in docs){
      res.add(Reservation(idclient:c["idClient"],idcoach:c["idCoach"],dateDebut:c["dateDebut"].toDate(),duration:c["duration"],isConfirmed:c["isConfirmed"]));
      print("idClient${c["idClient"]}");
      print("idCoach${c["idCoach"]}");
      print("dateDebut${c["dateDebut"]}");
      print("duration${c["duration"]}");
      print("isConfirmed${c["isConfirmed"]}");
    }

    return res;
  }

  Future<List<Reservation>> get_client_reservations(String idCoach) async{
    List<Reservation> res= [];
    var docs=(await FirebaseFirestore.instance.collection("reservations").
    where("idClient",isEqualTo: idCoach).snapshots().first).docs;
    var c;
    for(c in docs){
      res.add(Reservation(idclient:c["idClient"],idcoach:c["idCoach"],dateDebut:c["dateDebut"].toDate(),duration:c["duration"],isConfirmed:c["isConfirmed"]));
      print("idClient${c["idClient"]}");
      print("idCoach${c["idCoach"]}");
      print("dateDebut${c["dateDebut"]}");
      print("duration${c["duration"]}");
      print("isConfirmed${c["isConfirmed"]}");

    }

    return res;
  }

}