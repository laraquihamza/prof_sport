import 'package:cloud_firestore/cloud_firestore.dart';

import 'Client.dart';
import 'Coach.dart';
import 'Conversation.dart';

class ConversationService{

  Future<bool> conversation_exists(Coach coach, Client client) async{
    var doc= (await FirebaseFirestore.instance.collection("conversations").where("idCoach",isEqualTo: coach.uid).where("idClient",isEqualTo: client.uid).snapshots().first).docs;
    if (doc.length==0){
      return false;
    }
    print("conversation exists");
    return true;

  }
  create_conversation(Coach coach, Client client){
    var doc= FirebaseFirestore.instance.collection("conversations").doc();
    doc.set(
      {
        'id': doc.id,
        'idCoach': coach.uid,
        'idClient': client.uid,
      }
    );
  }
  Future<Conversation> get_conversation(Client client, Coach coach) async{
    var doc= (await FirebaseFirestore.instance.collection("conversations").where("idCoach",isEqualTo: coach.uid).where("idClient",isEqualTo: client.uid).snapshots().first).docs;
    return Conversation(id: doc[0]["id"], idClient: doc[0]["idClient"], idCoach: doc[0]["idCoach"]);
  }
  delete_conversation(Conversation conversation){
    FirebaseFirestore.instance.collection("conversations").doc(conversation.id).delete();
  }
}