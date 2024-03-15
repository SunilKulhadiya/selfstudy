import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../app_config.dart';
import 'package:selfstudy/drawer_menus/upload_image.dart';
import 'package:selfstudy/drawer_menus/upload_notes.dart';
import 'package:selfstudy/drawer_menus/upload_shorts.dart';
import 'package:selfstudy/drawer_menus/upload_video.dart';
import 'package:selfstudy/drawer_menus/upload_web_url.dart';
import 'package:selfstudy/drawer_menus/user_uploads/user_upload_shorts.dart';
import 'package:selfstudy/drawer_menus/user_uploads/user_upload_images.dart';
import 'package:selfstudy/drawer_menus/user_uploads/user_upload_pdf.dart';
import 'package:selfstudy/drawer_menus/user_uploads/user_upload_weburl.dart';

class UploadFiles extends StatefulWidget {
  final int Route;
  final BuildContext context;

  const UploadFiles({super.key,
    required this.Route,
    required this.context});

  @override
  State<UploadFiles> createState() => CreateSList();
}
class CreateSList extends State<UploadFiles>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: ImageIcon(AssetImage("assets/images/shorts.png"))),
                Tab(icon: Icon(Icons.video_collection_sharp)),
                Tab(icon: Icon(Icons.image_sharp)),
                Tab(icon: Icon(Icons.file_copy_sharp)),
                Tab(icon: Icon(Icons.language_sharp)),
              ],
            ),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: widget.Route == 0 ? const Text('Upload') : const Text('Your Upload'),
            backgroundColor: Color.fromRGBO(117, 254, 250, 51),
          ),
          body: widget.Route == 0 ? const TabBarView(
            children: [
              Center(
                child: UploadShorts(),
              ),
              Center(
                child: UploadVideo(),
              ),
              Center(
                child: UploadImage(),
              ),
              Center(
                child: UploadNotes(),
              ),
              Center(
                child: UploadWebUrl(),
              ),
            ],
          ) : const TabBarView(
            children: [
              Center(
                child: UserUploadShorts(DataType: "Shorts"),
              ),
              Center(
                child: UserUploadShorts(DataType: "Tutorial"),
              ),
              Center(
                child: UserUploadImages(DataType: "Image"),
              ),
              Center(
                child: UserUploadPdf(DataType: "Notes"),
              ),
              Center(
                child: UserUploadWebsite(DataType: "Website"),
              ),
            ],
          )
        ),
      ),
    );
  }

} //CreateSList