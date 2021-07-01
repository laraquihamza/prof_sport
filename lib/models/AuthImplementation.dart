import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class AuthImplementation
{
  Future<String> SignIn(String email , String password) ;
  Future<String> SignUp(String email , String password) ;
  Future<void> signOut() ;
  Future<String> getCurrentUserUid() ;
  Future<User> getCurrentUser() ;

}

class Auth implements AuthImplementation
{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance ;
  Future<String> SignIn(String email , String password) async
  {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword( email : email , password :password );
    return user.user!.uid ;
  }
// Methode pour le Signup //
  Future<String> SignUp(String email , String password) async
  {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword( email : email , password :password );
    return user.user!.uid ;
  }
// Logout the user //
  Future<void> signOut() async
  {
    _firebaseAuth.signOut();
  }
// savoir l'utlilisateur logué au moment réel //

Future<String> getCurrentUserUid() async{
      User user= await _firebaseAuth.currentUser!;
       return user.uid;
}
  Future<User> getCurrentUser() async{
    User user= await _firebaseAuth.currentUser!;
    return user;
  }


}