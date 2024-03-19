import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> BackGHandle(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("------------------------------------Title : ${message.notification!.title}");
    print("------------------------------------Body : ${message.notification!.body}");
    print("------------------------------------Payload : ${message.data}");
  }

  void ForgroundfirebaseMessagingListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message data: ${jsonEncode(message.toMap())}');
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Message: ${message.notification!.title}');
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Message: ${message.notification!.body}');

      if (message.notification != null) {
        // that means new message

        try {
        } catch (e) {
        }
      }
    });
  }
    Future<void> initNotifications() async {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      // NotificationSettings settings = await messaging.requestPermission(
      //   alert: true,
      //   announcement: false,
      //   badge: true,
      //   carPlay: false,
      //   criticalAlert: true,
      //   provisional: false,
      //   sound: true,
      // );
    await firebaseMessaging.requestPermission();
    final fCMToken = await firebaseMessaging.getToken();
    print("=================================================Device Token : ${fCMToken}");

    try {
      FirebaseMessaging.onBackgroundMessage(BackGHandle);
      ForgroundfirebaseMessagingListener();
    }catch(e){
      print("*********************-----------Error : {e}");
    }
  }
}


//eiYWbzriRSagaZI49L9qST:APA91bGqc9mcgQYlWGWh2OLRwj8NQ7jerGURhblB6ObSHZYWVRLOeKc3tkpM1XR13VxzVnWBsEoPcLXPtxIznWmeyqxUosbuJmR3f3uhuh_qTk25twZ7OF_09FjBoB0w7K-Lm5z-NLat
//eiYWbzriRSagaZI49L9qST:APA91bGqc9mcgQYlWGWh2OLRwj8NQ7jerGURhblB6ObSHZYWVRLOeKc3tkpM1XR13VxzVnWBsEoPcLXPtxIznWmeyqxUosbuJmR3f3uhuh_qTk25twZ7OF_09FjBoB0w7K-Lm5z-NLat