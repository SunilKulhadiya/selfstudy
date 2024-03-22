import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:selfstudy/api_repository/api_repository.dart';

class FirebaseApi {
  late SharedPreferences prefs;
  int UserID = 0;

  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> SendNotification(String MTitle, String MBody, String UToken) async {
    var serverKey =
        'AAAAHuhBdvg:APA91bHo5p3fkB8U9NYQZWgit4mIdgiAfJHqQnNqHla8pa1zIDar9JGQ7Hn5H0wK4sf0b3t3AECG1uyyWQBoEJ-A7XwQzb6Hk3xss2xgqNNVdhOL-2HtUSBtRGrT_evm5gAjUGcdbPfy';
    //var UToken = "eiYWbzriRSagaZI49L9qST:APA91bGqc9mcgQYlWGWh2OLRwj8NQ7jerGURhblB6ObSHZYWVRLOeKc3tkpM1XR13VxzVnWBsEoPcLXPtxIznWmeyqxUosbuJmR3f3uhuh_qTk25twZ7OF_09FjBoB0w7K-Lm5z-NLat";
    try {
        http.Response response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': MBody,
                'title': MTitle
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'user_id': '5',
                'app': 'SelfStudy',
                'status': 'done'
              },
              'to': UToken,
            },
          ),
        );

        print("--------------------------------->>>>>>>>>>>>>>>>>>> api response : ${response}");
        print("--------------------------------->>>>>>>>>>>>>>>>>>> api response : ${jsonEncode(response)}");

    } catch (e) {
      print("error push notification");
    }
  }


    Future<void> initNotifications() async {
      late SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();

      //if(prefs.get('DeviceToken') == "" || prefs.get('DeviceToken') == null) {
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        await firebaseMessaging.requestPermission();
        final fCMToken = await firebaseMessaging.getToken();
        await FirebaseFirestore.instance.collection("SelfStudy").doc("User2").set({"token": fCMToken,});
        print("=================================================Device Token : ${fCMToken?.length}");
        prefs.setString('DeviceToken', fCMToken!);
        //SendNotification();
        ApiRepository().UserTokenUpdate();
      //}

    }
}