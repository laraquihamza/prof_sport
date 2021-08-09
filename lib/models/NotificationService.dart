import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_messaging/firebase_messaging.dart";
import 'package:toast/toast.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'AuthImplementation.dart';

var postUrl = "https://fcm.googleapis.com/fcm/send";

class NotificationService{
  static int _messageCount=0;
  Future<void> sendNotification(receiver,msg)async {
    var token = await getToken(receiver);
    print('token : $token');

    final data = {
      "notification": {
        "body": "Accept Ride Request",
        "title": "This is Ride Request"
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": "$token"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AIzaSyAQJoDMev53paHbrYjY7x3HE1NwVyL_zq4'
    };


    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AIzaSyAQJoDMev53paHbrYjY7x3HE1NwVyL_zq4',
        },
        body: jsonEncode({
          'notification': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        }),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }

/*    try {
      final response = await Dio(options).post(postUrl,
          data: data);

      if (response.statusCode == 200) {
      } else {
        print('notification sending failed');
// on failure do sth
      }
    }
    catch(e){
      print('exception $e');
    }
*/
  }
  Future<String> getToken(userId) async{

    final FirebaseFirestore _db = FirebaseFirestore.instance;

    var doc=(await _db.collection('tokens').where("userId",isEqualTo: userId).snapshots().first).docs;



    return doc![0]["id"];

  }


//Now Receiving End

  late FirebaseMessaging _fcm=FirebaseMessaging.instance ;

  saveDeviceToken(uid) async {
    String uid = await Auth().getCurrentUserUid();

    // Get the token for this device
    String fcmToken = (await _fcm.getToken())!;

    // Save it to Firestore
    if (fcmToken != null) {
      final FirebaseFirestore _db = FirebaseFirestore.instance;
      var tokens=await _db.collection('tokens').doc(uid).set({
        "id":fcmToken,
        "userId": uid
      });
    }
  }

}
