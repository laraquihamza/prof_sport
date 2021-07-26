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
      String picture ,

      DateTime birthdate);

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
  Future<Client> getCurrentUser();
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
    });

    return user.user!.uid;
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

  Future<Client> getCurrentUser() async {
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

  Future<String> UploadDocument(String filePath) async {
    File file = File(filePath);
    Client client = await getCurrentUser();
    List list = (await FirebaseFirestore.instance
            .collection("users")
            .doc(client.uid)
            .get())
        .data()!["documents_list"];
    print("jojojo$list");
    if (list == null) list = [];
    list.add("uploads$filePath");
    print("kokokoko$list");
    try {
      await FirebaseStorage.instance
          .ref("uploads/$filePath")
          .putFile(file)
          .whenComplete(() => () {});
      FirebaseFirestore.instance.collection("users").doc(client.uid).set({
        'id': client.uid,
        'firstname': client.firstname, // John Doe
        'lastname': client.lastname, // Stokes and Sons
        'city': client.city, // 42
        'address': client.address, // 42
        'phone': client.city, // 42
        'birthdate': client.birthdate,
        "documents_list": list
      });
    } on FirebaseException catch (e) {
      print(e.message);
      return "failure";
    }
    return "success";
  }

  Future<String> downloadURL(String path) async {
    var downloadURL =
        await FirebaseStorage.instance.ref("/uploads" + path).getDownloadURL();
    return downloadURL;
  }

  Future<List> get_documents() async {
    Client client = await getCurrentUser();
    List list = (await FirebaseFirestore.instance
            .collection("users")
            .doc(client.uid)
            .get())
        .data()!["documents_list"];
    return list;
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
      'phone': city, // 42
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
