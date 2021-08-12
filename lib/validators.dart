import 'dart:html';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
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
    if (name.length <= 3 && name is String) {
      return false;
    } else {
      return true;
    }
  }

  // Confirm Adress //

  bool isAdressValid(String adress) {
    if (adress.length <= 14 && adress is String) {
      return false;
    } else {
      return true;
    }
  }

  // Numero Telephone Valid //

  bool isPhoneNumberValid(String value) {
    String pattern = r'/^(?:[+0]9)?[0-9]{10})$/';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  //

  // Cin Doc // Diplome Doc // Cv Doc //

  bool isDocumentValid(String document) {
    if (document != "") {
      return true;
    } else {
      return false;
    }
  }

  // Login Validation //
  bool isEmailAlreadyUsed(String error) {
    if (error.contains("email already used")) {
      return true;
    } else {
      return false;
    }
  }

  bool isEmailNotExist(String error) {
    if (error.contains("email not exist")) {
      return true;
    } else {
      return false;
    }
  }

  bool isPasswordWrong(String error) {
    if (error.contains("password wrong")) {
      return true;
    } else {
      return false;
    }
  }

  // Messages Return For Toasts for each Exception //

  void toastException(String text, BuildContext context) {
    return Toast.show(text, context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }
}
