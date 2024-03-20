import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> SaveTokenOnFirebase(String token) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    //final firestore=FirebaseFirestore.instance;
    // Create a new document in the users collection.
    // firestore.collection('user1').add({
    //   "Email": "skandsolution@gmail.com",
    //   "Token": token
    // });

    // UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: "skandsolution@gmail.com", password: "7000336187");
    // User? user = result.user;
    // await FirebaseFirestore.instance.collection('users')
    //     .doc("user1").set({ 'Name': "dkfjdskfjsdk"});


    // FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
    //     email: email, password: password);
    //
    // FirebaseFirestore.instance.collection('users').document().setData({ 'userid': user.uid, 'displayName': 'bobby' });
    //
    // return user.uid;

  }


    Future<void> initNotifications() async {
      late SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();

      //if(prefs.get('DeviceToken') == "" || prefs.get('DeviceToken') == null) {
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        await firebaseMessaging.requestPermission();
        final fCMToken = await firebaseMessaging.getToken();
        await FirebaseFirestore.instance.collection("SelfStudy").doc("User2").set({"token": fCMToken,});
        print("=================================================Device Token : ${fCMToken}");
        prefs.setString('DeviceToken', fCMToken!);
        SaveTokenOnFirebase(fCMToken);
      //}

      final postUrl = 'https://fcm.googleapis.com/fcm/send';

      final data = {
        "notification": {"body": "this is a body", "title": "this is a title"},
        "priority": "high",
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": "1",
          "status": "done"
        },
        "to": "eiYWbzriRSagaZI49L9qST:APA91bGqc9mcgQYlWGWh2OLRwj8NQ7jerGURhblB6ObSHZYWVRLOeKc3tkpM1XR13VxzVnWBsEoPcLXPtxIznWmeyqxUosbuJmR3f3uhuh_qTk25twZ7OF_09FjBoB0w7K-Lm5z-NLat"
      };
      final headers = {
        'content-type': 'application/json',
        'Authorization': 'key=<FCM SERVER KEY>'
      };
      final response = await http.post(Uri.parse(postUrl),
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        // on success do sth
        print("=================================================Notification Send : ${response}");
      } else {
        print("=================================================Notification Fail : ${response}");
      }


    }
}


//eiYWbzriRSagaZI49L9qST:APA91bGqc9mcgQYlWGWh2OLRwj8NQ7jerGURhblB6ObSHZYWVRLOeKc3tkpM1XR13VxzVnWBsEoPcLXPtxIznWmeyqxUosbuJmR3f3uhuh_qTk25twZ7OF_09FjBoB0w7K-Lm5z-NLat
//eiYWbzriRSagaZI49L9qST:APA91bGqc9mcgQYlWGWh2OLRwj8NQ7jerGURhblB6ObSHZYWVRLOeKc3tkpM1XR13VxzVnWBsEoPcLXPtxIznWmeyqxUosbuJmR3f3uhuh_qTk25twZ7OF_09FjBoB0w7K-Lm5z-NLat
// Future<void> BackGHandle(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("------------------------------------Title : ${message.notification!.title}");
//   print("------------------------------------Body : ${message.notification!.body}");
//   print("------------------------------------Payload : ${message.data}");
// }
//
// void ForgroundfirebaseMessagingListener() {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print("------------------------------------forground handler notification------------------------------");
//     print('Message data: ${jsonEncode(message.toMap())}');
//     print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Message: ${message.notification!.title}');
//     print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Message: ${message.notification!.body}');
//
//     if (message.notification != null) {
//       // that means new message
//
//       try {
//       } catch (e) {
//       }
//     }
//   });
// }
