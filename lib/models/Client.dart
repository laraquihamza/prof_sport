import 'package:flutter/cupertino.dart';
import 'User.dart';
class Client extends User2{
  late String picture;
  late double imc;
  late double img;
  late int height;
  late int weight;
  late String gender;
  Client(
      String uid,
      String email,
      DateTime birthdate,
      String password,
      String city,
      String address,
      String firstname,
      String lastname,
      String phone,
      String picture,
      double imc,
      double img,
      int height,
      int weight,
      String gender,
      ) : super('', '', DateTime.now(), '', '', '', '', '', '') {
    this.uid = uid;
    this.email = email;
    this.birthdate = birthdate;
    this.password = password;
    this.city = city;
    this.address = address;
    this.firstname = firstname;
    this.lastname = lastname;
    this.phone = phone;
    this.picture=picture;
    this.imc=imc;
    this.img=img;
    this.height=height;
    this.weight=weight;
    this.gender=gender;

  }
}
