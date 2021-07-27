import 'package:flutter/cupertino.dart';
import 'User.dart';
class Coach extends User2 {
  Coach(
      String uid,
      String email,
      DateTime birthdate,
      String password,
      String city,
      String address,
      String firstname,
      String lastname,
      String phone) : super('', '', DateTime.now(), '', '', '', '', '', '') {
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
