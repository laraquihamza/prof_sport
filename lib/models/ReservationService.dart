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
    var doc=FirebaseFirestore.instance.collection("reservations").doc();

    doc.set({
      "id":doc.id,
      'idCoach':idCoach,
      'idClient':idClient,
      'dateDebut':dateDebut,
      'duration':duration,
      'isConfirmed': false,
      'isPaid':false
    });
  }
  Future<List<Reservation>> get_coach_reservations(String idCoach) async{
    List<Reservation> res= [];
    var docs=(await FirebaseFirestore.instance.collection("reservations").
    where("idCoach",isEqualTo: idCoach).snapshots().first).docs;
    var c;
    for(c in docs){
      res.add(Reservation(id:c["id"] ,idclient:c["idClient"],idcoach:c["idCoach"],dateDebut:c["dateDebut"].toDate(),duration:c["duration"],isConfirmed:c["isConfirmed"],isPaid:c["isPaid"]));
      print("idClient${c["idClient"]}");
      print("idCoach${c["idCoach"]}");
      print("dateDebut${c["dateDebut"]}");
      print("duration${c["duration"]}");
      print("isConfirmed${c["isConfirmed"]}");
    }

    return res;
  }


  Future<Null> confirm_reservation(Reservation reservation) async{
    await FirebaseFirestore.instance.collection("reservations").doc(reservation.id).set(
        {
          'id':reservation.id,
          'idCoach': reservation.idcoach,
          'idClient': reservation.idclient,
          'dateDebut': reservation.dateDebut,
          'duration': reservation.duration,
          'isConfirmed': true,
          'isPaid':false
        }
    );
  }
  Future<Null> pay_reservation(Reservation reservation) async{
    await FirebaseFirestore.instance.collection("reservations").doc(reservation.id).set(
        {
          'id':reservation.id,
          'idCoach': reservation.idcoach,
          'idClient': reservation.idclient,
          'dateDebut': reservation.dateDebut,
          'duration': reservation.duration,
          'isConfirmed': true,
          'isPaid':true
        }
    );
  }


  Future<Null> refus_reservation(Reservation reservation) async{
    await FirebaseFirestore.instance.collection("reservations").doc(reservation.id).delete();
  }


  Future<List<Reservation>> get_client_reservations(String idClient) async{
    List<Reservation> res= [];
    var docs=(await FirebaseFirestore.instance.collection("reservations").
    where("idClient",isEqualTo: idClient).snapshots().first).docs;
    var c;
    for(c in docs){
      res.add(Reservation(id:c["id"],idclient:c["idClient"],idcoach:c["idCoach"],dateDebut:c["dateDebut"].toDate(),duration:c["duration"],isConfirmed:c["isConfirmed"],isPaid: c["isPaid"]));
      print("idClient${c["idClient"]}");
      print("idCoach${c["idCoach"]}");
      print("dateDebut${c["dateDebut"]}");
      print("duration${c["duration"]}");
      print("isConfirmed${c["isConfirmed"]}");

    }

    return res;
  }

}