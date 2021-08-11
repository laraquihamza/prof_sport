import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Future<Null> updatePicture(Client client,String path);
  Future<Null> updateCoach(Coach coach);


  }

class Auth implements AuthImplementation {
   FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
   Future<String> SignIn(String email, String password) async {
     _firebaseAuth.setPersistence(Persistence.SESSION);
     UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user!.uid;
  }
  Future<bool> isVerified()async{
     return _firebaseAuth.currentUser!.emailVerified;
  }
// Methode pour le Signup //
  Future<String> SignUp(String email, String password) async {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.user!.uid;
  }
  sendVerificationEmail() async{
     await _firebaseAuth.currentUser!.sendEmailVerification();
  }
  resetPassword(String email){
     _firebaseAuth.sendPasswordResetEmail(email: email);
  }
  reload(){
     _firebaseAuth.currentUser!..reload();
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
    user.user!.sendEmailVerification();
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
      'gender':gender,
      "email":email
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
    User? user = await _firebaseAuth.currentUser;
    if(user!=null){
      return user.uid;
    }
    return "error";
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
          c.data()!["email"],
          c.data()!["city"],
          c.data()!["address"],
          c.data()!["firstname"],
          c.data()!["lastname"],
          c.data()!["phone"],
        c.data()!["picture"],
        c.data()!["imc"],
        c.data()!["img"],
        c.data()!["height"],
        c.data()!["weight"],
        c.data()!["gender"]
      );
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
        c.data()!["email"],
        c.data()!["city"],
        c.data()!["address"],
        c.data()!["firstname"],
        c.data()!["lastname"],
        c.data()!["phone"],
        c.data()!["picture"],
      c.data()!["price"],
      c.data()!["sport"],
      c.data()!["cin"],
      c.data()!["cv"],
      c.data()!["diplome"]
    );
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
    _firebaseAuth.setPersistence(Persistence.SESSION);
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
    user.user!.sendEmailVerification();
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
      "email":email

    });

    return user.user!.uid;
  }


  Future<Null> updatePicture(Client client,String path) async{
    print("updatemypicture:${path}");
    await FirebaseFirestore.instance.collection("users").doc(client.uid).set(
        {       'id': client.uid,
          'firstname': client.firstname, // John Doe
          'lastname': client.lastname, // Stokes and Sons
          'city': client.city, // 42
          'address': client.address, // 42
          'phone': client.phone, // 42
          'birthdate': client.birthdate,
          'picture': path,
          'imc':client.imc,
          'img':client.img,
          'height':client.height,
          'weight':client.weight,
          'gender':client.gender

        }
    );

  }
  Future<Null> updateClient(Client client) async{
    await FirebaseFirestore.instance.collection("users").doc(client.uid).set(
        {       'id': client.uid,
          'firstname': client.firstname, // John Doe
          'lastname': client.lastname, // Stokes and Sons
          'city': client.city, // 42
          'address': client.address, // 42
          'phone': client.phone, // 42
          'birthdate': client.birthdate,
          'picture': client.picture,
          'imc':client.imc,
          'img':client.img,
          'height':client.height,
          'weight':client.weight,
          'gender':client.gender

        }
    );

  }
  Future<Null> updateCoach(Coach coach) async{
    await FirebaseFirestore.instance.collection("coaches").doc(coach.uid).set(
        {             'id': coach.uid,
          'firstname': coach.firstname, // John Doe
          'lastname': coach.lastname, // Stokes and Sons
          'city': coach.city, // 42
          'address': coach.address, // 42
          'phone': coach.phone, // 42
          'birthdate': coach.birthdate,
          'cin': coach.cin,
          'cv':coach.cv,
          'picture':coach.picture,
          'diplome':coach.diplome,
          'price':coach.price,
          'sport':coach.sport,

        }
    );

  }


}
