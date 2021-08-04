import 'package:flutter/cupertino.dart';
import 'User.dart';
class Coach extends User2 {
  late String picture;
  late int price;
  late String sport;
  late String cin;
  late String cv;
  late String diplome;
  Coach(
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
      int price,
      String sport,
      String cin,
      String cv,
      String diplome
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
    this.price=price;
    this.sport=sport;
    this.cin=cin;
    this.cv=cv;
    this.diplome=diplome;
  }
}
