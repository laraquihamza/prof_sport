class Reservation
{
  late String idcoach;
  late String idclient;
  late String id;
  late DateTime dateDebut;
  late int duration;
  late bool isConfirmed ;
  late bool isPaid;
  late bool isOver;

  Reservation({required this.idclient,required this.idcoach,required this.dateDebut,required this.duration,required this.isConfirmed, required this.id, required this.isPaid,required this.isOver});
}