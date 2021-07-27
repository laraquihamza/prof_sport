import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prof_sport/models/Client.dart';
import 'package:prof_sport/models/Coach.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'User.dart';
abstract class AuthImplementation {
  Future<String> SignIn(String email, String password);
  Future<String> SignUp(String email, String password);
  Future<String> SignUpBig(
      String email,
      String password,
      String firstname,
      String lastname,
      String city,
      String address,
      String phonenumber,
      String picture,
      double imc,
      double img,
      int height,
      int weight,
      String gender,
      DateTime birthdate);
  Future<String> user_type();
  Future<String> SignInCoach(String email, String password);
  Future<String> SignUpCoach(String email, String password);
  Future<String> SignUpBigCoach(
      String email,
      String password,
      String firstname,
      String lastname,
      String city,
      String address,
      String phonenumber,
      String sport,
      int price,
      String diplome,
      String cin,
      String cv,
      String picture,
      DateTime birthdate);
  Future<String> UploadDocument(String filePath);
  Future<String> downloadURL(String path);

  Future<void> signOut();
  Future<String> getCurrentUserUid();
  Future<Client> getCurrentClient();
  Future<Coach> getCurrentCoach();

}

class Auth implements AuthImplementation {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String> SignIn(String email, String password) async {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user!.uid;
  }

// Methode pour le Signup //
  Future<String> SignUp(String email, String password) async {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.user!.uid;
  }

  Future<String> SignUpBig(
      String email,
      String password,
      String firstname,
      String lastname,
      String city,
      String address,
      String phonenumber,
      String picture,
      double imc,
      double img,
      int height,
      int weight,
      String gender,
      DateTime birthdate) async {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseFirestore.instance.collection("users").doc(user.user!.uid).set({
      'id': user.user!.uid,
      'firstname': firstname, // John Doe
      'lastname': lastname, // Stokes and Sons
      'city': city, // 42
      'address': address, // 42
      'phone': phonenumber, // 42
      'birthdate': birthdate,
      'picture': picture,
      'imc':imc,
      'img':img,
      'height':height,
      'weight':weight,
      'gender':gender
    });

    return user.user!.uid;
  }

  Future<String> user_type() async{
    String uid= await getCurrentUserUid();
    bool isClient=true;
    bool isCoach=true;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get().then((value) {
      if(!value.exists){
        isClient=false;
      }
    });
      await FirebaseFirestore.instance
          .collection("coaches")
          .doc(uid)
          .get().then((value) {
            if(!value.exists){
              isCoach=false;
            }
      });
    print("isclient:"+isClient.toString());
    print("iscoach:"+isCoach.toString());
    if(isClient){
      return "client";
    }
    else if(isCoach){
      return "coach";
    }
    return "error";
  }

// Logout the user //
  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
// savoir l'utlilisateur logué au moment réel //

  Future<String> getCurrentUserUid() async {
    User user = await _firebaseAuth.currentUser!;
    return user.uid;
  }

  Future<Client> getCurrentClient() async {
    User user = await _firebaseAuth.currentUser!;
      var c = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .snapshots()
          .first;
      Client client = Client(
          user.uid,
          user.email!,
          DateTime.fromMillisecondsSinceEpoch(
              (c.data()!["birthdate"] as Timestamp).millisecondsSinceEpoch),
          "",
          c.data()!["city"],
          c.data()!["address"],
          c.data()!["firstname"],
          c.data()!["lastname"],
          c.data()!["phone"]);
      return client;
 }
  Future<Coach> getCurrentCoach() async {
    User user = await _firebaseAuth.currentUser!;
    var c = await FirebaseFirestore.instance
        .collection("coaches")
        .doc(user.uid)
        .snapshots()
        .first;
    Coach coach = Coach(
        user.uid,
        user.email!,
        DateTime.fromMillisecondsSinceEpoch(
            (c.data()!["birthdate"] as Timestamp).millisecondsSinceEpoch),
        "",
        c.data()!["city"],
        c.data()!["address"],
        c.data()!["firstname"],
        c.data()!["lastname"],
        c.data()!["phone"]);
    return coach;
  }


  Future<String> UploadDocument(String filePath) async {
    File file = File(filePath);
    try {
      await FirebaseStorage.instance
          .ref("$filePath")
          .putFile(file)
          .whenComplete(() => () {});
    } on FirebaseException catch (e) {
      print(e.message);
      return "failure";
    }
    return "success";
  }

  Future<String> downloadURL(String path) async {
    var downloadURL =
        await FirebaseStorage.instance.ref(path).getDownloadURL();
    return downloadURL;
  }

// Methode pour le Signup //

  Future<String> SignInCoach(String email, String password) async {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user!.uid;
  }

  Future<String> SignUpCoach(String email, String password) async {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.user!.uid;
  }

  Future<String> SignUpBigCoach(
      String email,
      String password,
      String firstname,
      String lastname,
      String city,
      String address,
      String phonenumber,
      String sport,
      int price,
      String diplome,
      String cin,
      String cv,
      String picture,
      DateTime birthdate) async {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseFirestore.instance.collection("coaches").doc(user.user!.uid).set({
      'id': user.user!.uid,
      'firstname': firstname, // John Doe
      'lastname': lastname, // Stokes and Sons
      'city': city, // 42
      'address': address, // 42
      'phone': phonenumber, // 42
      'birthdate': birthdate,
      'cin': cin,
      'cv':cv,
      'picture':picture,
      'diplome':diplome,
      'price':price,
      'sport':sport,

    });

    return user.user!.uid;
  }
}
