class Reservation
{
  late String idcoach;
  late String idclient;
  late String id;
  late DateTime dateDebut;
  late int duration;
  late bool isConfirmed ;

  Reservation({required this.idclient,required this.idcoach,required this.dateDebut,required this.duration,required this.isConfirmed});
}