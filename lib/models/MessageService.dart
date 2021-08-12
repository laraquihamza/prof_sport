import 'package:cloud_firestore/cloud_firestore.dart';

import 'Message.dart';

class MessageService
{
   sendMessage(String idSender,String idReceiver, String idConversation, String message){
     var doc=FirebaseFirestore.instance.collection("messages").doc();

     doc.set({
       "id":doc.id,
       'idSender':idSender,
       'idReceiver':idReceiver,
       'message':message,
       'idConversation':idConversation,
       'date':DateTime.now(),
     });

   }

  deleteMessage(Message message) async{
    await FirebaseFirestore.instance.collection("messages").doc(message.id).delete();
  }
}