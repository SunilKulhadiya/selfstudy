import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:selfstudy/shorts/video_player.dart';
import 'package:selfstudy/module/data_module.dart';
import 'package:selfstudy/shorts/youtub_player.dart';

final List<String> VideoUrl = <String>[
  'https://sewabhartidabra.in/Self_Study/GK/Video/Gk2.mp4',
  'https://sewabhartidabra.in/Self_Study/GK/Video/Gk3.mp4',
  'https://sewabhartidabra.in/Self_Study/GK/Video/Gk4.mp4'];

class ShortsList extends StatefulWidget {
  final String clientName;
  final int GroupID;
  final BuildContext context;

  const ShortsList({super.key,
    required this.clientName,
    required this.GroupID, required this.context});

  @override
  State<ShortsList> createState() => CreateSList();
}
class CreateSList extends State<ShortsList>{
  List<VideoDataModel> VDModel = [];
  ScrollController LVcontroller = ScrollController();
  int StartRowNo = 0;

  @override
  void initState() {
    super.initState();
    print("-----------<<<<<<<<<<<<<<< &&&&&&&&&&&&&&&&&& >>>>>>>>>>>>>>>>>");

    LVcontroller.addListener(handleScrolling);
    print("-----------<<<<<<<<<<<<<<< &&&&&&&&&&&&&&&&&& ${LVcontroller}");
    fetchProducts();
  }
  void handleScrolling() {
    print("-----------<<<<<<<<<<<<<<< StartRowNo ${StartRowNo}");
    print("-----------<<<<<<<<<<<<<<< LVcontroller.offset ${LVcontroller.offset}");
    print("-----------<<<<<<<<<<<<<<< LVcontroller.position.maxScrollExtent ${LVcontroller.position.maxScrollExtent}");
    if (LVcontroller.position.pixels == LVcontroller.position.maxScrollExtent) {
      print("-----------<<<<<<<<<<<<<<< StartRowNo ---------------------------------");
      setState(() {
        StartRowNo += 3;
      });
      print("-----------<<<<<<<<<<<<<<< StartRowNo ${StartRowNo}");
    }
  }
  Future<void> fetchProducts() async {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> GID : ${widget.GroupID}");
    final body = {
      "ACTION": "4",
      "ROWNO": StartRowNo,
      "GROUPID": widget.GroupID,
    };
    final jsonBody = json.encode(body);

    // you can replace your api link with this link
    final response = await
    http.post(Uri.parse('https://sewabhartidabra.in/APIs/Fetch_SelfStudy.php'),
        body: jsonBody,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json',}
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      print("--------------------jsonData : ${jsonData}");
      setState(() {
        VDModel = jsonData.map((data) => VideoDataModel.fromJson(data)).toList();
      });
      print("--------------------VDModel : ${VDModel[0].VUrl}");
    } else {
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.clientName),
      ),
      body:Center(
          child: ListView(
            children: [
              Container(
                height: 777,
                width: 290,
                child: ListView.builder(
                  controller: LVcontroller,
                  itemCount: VDModel.isEmpty ? 0 : VDModel.length,
                  itemBuilder: (BuildContext context, int index) =>
                      Container(
                        width: 290,
                        height: 777,
                        alignment: Alignment.center,

                        child: Container(
                            key: new PageStorageKey(
                              "keydata$index",
                            ),

                            child: YouTubePlayer(
                              VideoUrl: VDModel[index].VUrl,
                              context: context,
                            )
                        ),
                      ),
                ),
              ),
            ],
          ),

      ),
    );
  }

} //CreateSList