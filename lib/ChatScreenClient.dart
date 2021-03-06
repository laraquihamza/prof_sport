import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prof_sport/CustomAppBar.dart';
import 'package:prof_sport/models/Client.dart';
import 'package:prof_sport/models/Coach.dart';
import 'package:bubble/bubble.dart';
import 'package:prof_sport/models/Message.dart';
import 'package:prof_sport/models/MessageService.dart';
import 'package:prof_sport/validators.dart';
import 'package:toast/toast.dart';

import 'models/AuthImplementation.dart';
import 'models/Conversation.dart';

class ChatScreenClient extends StatefulWidget {
  Conversation conversation;
  ChatScreenClient({required this.conversation});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenClient> {
  String text="";

  TextEditingController controller=TextEditingController();
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return    Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: custom_appbar("Exercices Coach", context, true,false),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.7,
              child:                            StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("messages").where("idConversation",isEqualTo: widget.conversation.id).orderBy("date").snapshots(),
                  builder: (context,snapshot){
                    Timer(
                      Duration(milliseconds: 100),
                          () => _controller.jumpTo(_controller.position.maxScrollExtent),
                    );
                    return snapshot.hasData?ListView.builder(
                      controller: _controller,
                      shrinkWrap: true,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context,index){
                          Message message=Message(id: snapshot.data!.docs[index]["id"],idReceiver:snapshot.data!.docs[index]["idReceiver"],
                              idSender: snapshot.data!.docs[index]["idSender"],text: snapshot.data!.docs[index]["message"],
                              date: snapshot.data!.docs[index]["date"].toDate(),
                            idConversation: snapshot.data!.docs[index]["idConversation"]
                          );
                          return Bubble(
                              alignment: message.idSender==widget.conversation.idClient?Alignment.topRight:Alignment.topLeft,
                              nip: message.idSender==widget.conversation.idClient?BubbleNip.rightTop:BubbleNip.leftTop,
                              child: Text(message.text),
                            );
                        }):Text("");
                  }),
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.2,
              child:             Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    child:                   TextField(

                      controller: controller,
                      onChanged: (s){
                        text=s;
                      },
                    )
                    ,
                  )
                  ,IconButton(onPressed: (){
                    if(!Validators().message_valid(text)){
                      Toast.show("Vous ne pouvez pas envoyer de coordonn??es personnelles",context,duration: Toast.LENGTH_LONG);
                    }
                    else if(text!="" ) {
                      MessageService().sendMessage(
                          widget.conversation.idClient, widget.conversation.idCoach,widget.conversation.id, text);
                    }
                    controller.text="";
                    text="";
                  }, icon: Icon(Icons.send,color: Colors.green,))
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

