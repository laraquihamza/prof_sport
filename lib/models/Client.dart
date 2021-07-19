import 'package:flutter/cupertino.dart';

class Client {
  String uid = "";
  String email = "";
  DateTime birthdate = DateTime(1900);
  String password = "";
  String city = "";
  String address = "";
  String firstname = "";
  String lastname = "";
  String phone = "";
  Client(
      String uid,
      String email,
      DateTime birthdate,
      String password,
      String city,
      String address,
      String firstname,
      String lastname,
      String phone) {
    this.uid = uid;
    this.email = email;
    this.birthdate = birthdate;
    this.password = password;
    this.city = city;
    this.address = address;
    this.firstname = firstname;
    this.lastname = lastname;
    this.phone = phone;
  }
}
