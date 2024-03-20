//import 'dart:html';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
//import 'package:splashscreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:selfstudy/shorts/shorts_type.dart';
import 'package:selfstudy/drawer_menus/drawer_menu.dart';
import 'package:selfstudy/home/home.dart';
import 'package:selfstudy/read/docu_list.dart';
import 'package:selfstudy/syllabus/syllabus.dart';

import 'package:selfstudy/firebase_api/firebase_api.dart';

Future<void> BackGHandle(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("------------------------------------Back ground handler notification------------------------------");
  print("------------------------------------Title : ${message.notification!.title}");
  print("------------------------------------Body : ${message.notification!.body}");
  print("------------------------------------Payload : ${message.data}");
}
void ForgroundfirebaseMessagingListener() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("------------------------------------forground handler notification------------------------------");
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  try {
    FirebaseMessaging.onBackgroundMessage(BackGHandle);
    ForgroundfirebaseMessagingListener();
    await FirebaseFirestore.instance.collection("SelfStudy").doc("User2").set({
      "Email": "skand@gmail.com",
      "Name": "Sunil KK",
      "Token": "eiYWbzriRSagaZI49L9qST:APA91bGqc9mcgQYlWGWh2OLRwj8NQ7jerGURhblB6ObSHZYWVRLOeKc3tkpM1XR13VxzVnWBsEoPcLXPtxIznWmeyqxUosbuJmR3f3uhuh_qTk25twZ7OF_09FjBoB0w7K-Lm5z-NLat",});
  }catch(e){
    print("*********************-----------Error : {e}");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Self Study',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple.shade100),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences prefs;
  String DToken = "";
  int _counter = 0;
  int _selectedIndex = 0;
  List _pages = [
    Home(),
    ShortsType(),
    DocumentList(),
    Syllabus()
  ];
  List _pagesTitle = [
    "Home",
    "Shorts",
    "Notes",
    "Syllabus"
  ];
  final ScrollController _homeController = ScrollController();

  @override
  void initState() {
    super.initState();
    RequestPermission();
    FetchUserID();
  }
  Future<void> FetchUserID() async {
    prefs = await SharedPreferences.getInstance();
  }
  Future<void> RequestPermission() async {
    print("------------main=============AuthorizationStatus : ********************************************");
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings notificationSettings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print("------------main=============AuthorizationStatus : ${notificationSettings.authorizationStatus}");
    if(notificationSettings.authorizationStatus == AuthorizationStatus.authorized){
      print("------------main=============AuthorizationStatus : ${notificationSettings.authorizationStatus}");
    }else if(notificationSettings.authorizationStatus == AuthorizationStatus.provisional){
      print("------------main=============AuthorizationStatus : ${notificationSettings.authorizationStatus}");
    }else{
      print("------------main=============AuthorizationStatus : ${notificationSettings.authorizationStatus}");
      print("------------=============////////////////////// User declined or has not accepted permission");
    }
  }

    void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Stack(
        children: [

          Scaffold(

            appBar: AppBar(
              // TRY THIS: Try changing the color here to a specific color (to
              // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
              // change color while the other colors stay the same.
              backgroundColor: Color.fromRGBO(117, 254, 250, 51),
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(_pagesTitle[_selectedIndex]),
            ),
            body: _pages[_selectedIndex],
            drawer: DrawerMenu(),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage("assets/images/shorts.png")),
                  label: 'shorts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.file_open_sharp),
                  label: 'Notes',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage("assets/images/syllabus2.png")),
                  label: 'Syllabus',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Color.fromRGBO(117, 254, 250, 51),
              unselectedItemColor: Colors.black26,
              selectedIconTheme: IconThemeData(size: 40),
              unselectedIconTheme: IconThemeData(size: 24),
              onTap: (int index) {
                print("--------------------${index}");
                switch (index) {
                  case 0:
                  // only scroll to top when current index is selected.
                    if (_selectedIndex == index) {
                      _homeController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    }
                    break;
                  case 1:
                  //ShortsType();
                    break;
                }
                setState(
                      () {
                    _selectedIndex = index;
                  },
                );
              },
            ),

            // floatingActionButton: FloatingActionButton(
            //   onPressed: _incrementCounter,
            //   tooltip: 'Increment',
            //   child: ImageIcon(AssetImage("assets/images/chat3d.png"), size: 30, color: Colors.cyan,),
            // ),

            // This trailing comma makes auto-formatting nicer for build methods.
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.only(top: 55, right: 50),
              child: const Banner(
                message: "Self Study",
                location: BannerLocation.bottomStart,
              ),
            ),
          ),
        ]
    );
  }
}
