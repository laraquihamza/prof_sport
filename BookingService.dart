import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firestoreInstance = FirebaseFirestore.instance;

class Booking {
  String? id;
  String? clientId;
  String? coachId;
  // Float? dureeEnHeure;
  // DateTime? datetime;

  Booking({
    this.id,
    this.clientId,
    this.coachId,
  });
}

class Demande {
  String? id;
  String? clientId;
  String? coachId;

  Demande({this.id, this.clientId, this.coachId});

  List<Demande> demandes = [];

// Client Action //

  void bookDemande(String id, String clientUid, String coachId) {
    List<Demande> demandes = [];

    var firebaseUser = FirebaseAuth.instance.currentUser;
    firestoreInstance.collection("demandes").doc(firebaseUser!.uid).set({
      "ClientId": clientUid.toString(),
      "CoachId": coachId.toString(),
    }, SetOptions(merge: true)).then((_) {
      print("success!");
    });

    demandes.add(Demande(
      id: id,
      clientId: clientUid,
      coachId: coachId,
    ));
  }

// Coach Action //

  void repondreDemande(
      String id, String coachId, String clientId, bool response) {
    if (response == true) {
      List<Booking> bookings = [];

      var firebaseUser = FirebaseAuth.instance.currentUser;
      firestoreInstance.collection("booking").doc(firebaseUser!.uid).set({
        "ClientId": clientId.toString(),
        "CoachId": coachId.toString(),
      }, SetOptions(merge: true)).then((_) {
        print("success!");
      });

      bookings.add(Booking(
        id: id,
        clientId: clientId,
        coachId: coachId,
      ));

      print("Demande Accepté");

      demandes.removeWhere((demande) => demande.id == id);
    } else {
      print("Demande refusé");
      demandes.removeWhere((demande) => demande.id == id);
    }
  }
}
