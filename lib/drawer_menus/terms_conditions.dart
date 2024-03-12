import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:selfstudy/shorts/shorts_list.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_config.dart';

class TermsConditions extends StatefulWidget {

  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => CreateSList();
}
class CreateSList extends State<TermsConditions>{

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;

    return MaterialApp(
        home: DefaultTabController(
        length: 4,
        child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Terms & Conditions'),
          backgroundColor: Color.fromRGBO(117, 254, 250, 51),
        ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("Remember",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22,
                  color: Color.fromRGBO(189, 183, 8, 8)),),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: RichText(
              text: TextSpan(
                text: 'Your upload must be related to ',
                style: TextStyle(fontSize: 18, color: Colors.black),
                children: const <TextSpan>[
                  TextSpan(text: 'Education,', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' other wise your uploading will not be public,'),
                  TextSpan(text: ' because this is'),
                  TextSpan(text: ' Education', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' app.'),
                ],
              ),
            )
          ),
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: RichText(
                text: TextSpan(
                  text: 'You may make money by uploading',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  children: const <TextSpan>[
                    TextSpan(text: ' Shorts, Tutorials, Images, Notes & Websites.', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' Here you can also watch your uploads without any instructions and make views.'),
                  ],
                ),
              )
          ),
        ],
      ),
    ),
        ),
    );
  }

} //CreateSList