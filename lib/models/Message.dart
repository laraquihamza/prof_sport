class Message{
  String id;
  String idSender;
  String idReceiver;
  String text;
  DateTime date;
  String idConversation;

  Message({required this.id , required this.idSender  , required this.idReceiver  , required this.text , required this.date,required this.idConversation  });
}