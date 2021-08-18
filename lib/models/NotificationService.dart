import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_messaging/firebase_messaging.dart";
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:toast/toast.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'AuthImplementation.dart';

var postUrl = "https://fcm.googleapis.com/fcm/send";

class NotificationService{
  static int _messageCount=0;
  Future<void> sendNotification(String uid,String message)async {
    final data = {
    "app_id":"4ce78b24-9c33-42f2-bc11-61485d012dd6",
      "include_external_user_ids":[uid],
      "channel_for_external_user_ids":"push",
      "contents":{"fr":message,"en":message}
    };
    try {
      var h=await http.post(
        Uri.parse('https://onesignal.com/api/v1/notifications'),
        headers: {
          "Content-Type": "application/json;charset=utf-8",
          'Authorization': "Basic ZGY5YzZmZjEtMDZiOC00OWU1LWE0MWItOGEzNmY2ODkzZTc3"

        },
        body: jsonEncode(data),
      );
      print(h.reasonPhrase);
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

}
