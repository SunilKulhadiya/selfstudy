import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:selfstudy/shorts/shorts_list.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_config.dart';

class UploadNotes extends StatefulWidget {

  const UploadNotes({super.key});

  @override
  State<UploadNotes> createState() => CreateSList();
}
class CreateSList extends State<UploadNotes>{

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("Notes",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22,
                  color: Color.fromRGBO(189, 183, 8, 8)),),
          )
        ],
      ),
    );
  }

} //CreateSList