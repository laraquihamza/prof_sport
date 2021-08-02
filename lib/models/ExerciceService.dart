import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prof_sport/models/Exercice.dart';

class ExerciceService{
  Exercice add_exercice(String idReservation,String picture,int rep, String name, String state){
    var doc=FirebaseFirestore.instance.collection("exercices").doc();

    doc.set({
      "id":doc.id,
      'idReservation':idReservation,
      'picture':picture,
      'rep':rep,
      'name':name,
      'state': state,
    });
    return Exercice(id:doc.id,idReservation: idReservation,picture: picture,rep:rep,name:name,state:state);

  }
  Future<Null> delete_exercice(Exercice exercice) async{
    await FirebaseFirestore.instance.collection("exercices").doc(exercice.id).delete();
  }

  Future<List<Exercice>> get_exercices(String id) async {
    List<Exercice> exercices = [];
    var docs = (await FirebaseFirestore.instance
        .collection("exercices")
        .
    where("id", isEqualTo: id)
        .snapshots()
        .first).docs;
    var c;
    for (c in docs) {
      exercices.add(Exercice(id: c["id"],
          rep: c["rep"],
          idReservation: c["idReservation"],
          state: c["state"],
          picture: c["picture"],
          name: c["name"]));
    }
    return exercices;
  }
    Future<Null> update_exercice(Exercice exercice) async{
      await FirebaseFirestore.instance.collection("exercices").doc(exercice.id).set(
          { "id": exercice.id,
            'idReservation': exercice.idReservation,
            'picture': exercice.picture,
            'rep': exercice.rep,
            'name': exercice.name,
            'state': exercice.state,
          }
      );
      }


  }
