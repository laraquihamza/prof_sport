import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prof_sport/CustomAppBar.dart';
import 'package:prof_sport/models/Client.dart';
import 'package:prof_sport/models/Coach.dart';
import 'package:bubble/bubble.dart';
import 'package:prof_sport/models/Message.dart';
import 'package:prof_sport/models/MessageService.dart';

class ChatScreenClient extends StatefulWidget {
  Client client;
  Coach coach;
  ChatScreenClient({required this.client,required this.coach});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenClient> {
  String text="";
  TextEditingController controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return    Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: custom_appbar("Exercices Coach", context, true,false),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.7,
              child:                            StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("messages").orderBy("date").snapshots(),
                  builder: (context,snapshot){
                    return ListView.builder(
                      shrinkWrap: true,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context,index){
                          Message message=Message(id: snapshot.data!.docs[index]["id"],idReceiver:snapshot.data!.docs[index]["idReceiver"],
                              idSender: snapshot.data!.docs[index]["idSender"],text: snapshot.data!.docs[index]["message"],
                              date: snapshot.data!.docs[index]["date"].toDate()
                          );
                          if([widget.coach.uid,widget.client.uid].contains(message.idSender) && [widget.coach.uid,widget.client.uid].contains(message.idReceiver) ){
                            return Bubble(
                              alignment: message.idSender==widget.client.uid?Alignment.topRight:Alignment.topLeft,
                              nip: message.idSender==widget.client.uid?BubbleNip.rightTop:BubbleNip.leftTop,
                              child: Text(message.text),
                            );

                          }
                          return Text("");
                        });
                  }),
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.2,
              child:             Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.7,
                    child:                   TextField(

                      controller: controller,
                      onChanged: (s){
                        text=s;
                      },
                    )
                    ,
                  )
                  ,ElevatedButton(onPressed: (){
                    MessageService().sendMessage(widget.client.uid,widget.coach.uid , text);
                  }, child: Text("envoyer"))
                ],
              )
              ,
            )

          ],
        ),
      ),

    );


  }
}

