import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

class Validators {
  // Email Validation //
  bool isEmailValid(String email) {
    if (EmailValidator.validate(email)) {
      return true;
    } else {
      return false;
    }
  }

  // Password Validation //

  bool validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  // Match Password //

  bool matchConfirmPassword(String pass1, String pass2) {
    if (pass1 == pass2) {
      return true;
    } else {
      return false;
    }
  }

  // Valid firstname or lastname //

  bool isFirstLastNameValid(String name) {
    String pattern = "^[a-zA-Z0-9_]*\$";
    RegExp regex = new RegExp(pattern);

    if (name.length!=0 && !regex.hasMatch(name))
    {
      return false;
    } else {
      return true;
    }
  }

  // Confirm Adress //

  bool isAdressValid(String adress) {
    if (adress.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  // Numero Telephone Valid //

  bool isPhoneNumberValid(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
     { return false; }
    else
     { return true; }
  }

  //

  // Cin Doc // Diplome Doc // Cv Doc //

  bool isDocumentValid(String document) {
    if (document != "") {
      return true;
    }
    return false;
  }

  // Login Validation //
  Future<bool> isEmailAlreadyUsed(String email) async{
    var docs= (await FirebaseFirestore.instance.collection("users").snapshots().first).docs;
    var c;
    for (c in docs){
      if(c["email"]==email){
        return true;
      }
    }
    docs= (await FirebaseFirestore.instance.collection("coaches").snapshots().first).docs;
    for (c in docs){
      if(c["email"]==email){
        return true;
      }
    }
    return false;
  }

  bool isEmailNotExist(String error) {
    if (error.contains("email not exist")) {
      return true;
    }
      return false;
  }

  bool isPasswordWrong(String error) {
    if (error.contains("password wrong")) {
      return true;
    }
      return false;
  }

  bool message_valid(String message){
    String pattern = r'((?:[+0]9)?[0-9]{10,12})';
    String pattern2=r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    RegExp regExp2 = RegExp(pattern2);
    print("ddddd"+regExp2.allMatches(message).toString());
    return !message.contains(regExp) && !message.contains(regExp2);

  }

  // Messages Return For Toasts for each Exception //

  void toastException(String text, BuildContext context) {
    return Toast.show(text, context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }
}
