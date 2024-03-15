import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:selfstudy/app_config.dart';
import 'package:selfstudy/generalTools/vodeo_player_with_url.dart';
import 'package:selfstudy/module/main_group_model.dart';
import 'package:selfstudy/module/subgrp_model.dart';
import 'package:selfstudy/module/server_response_model.dart';

import '../../module/data_module.dart';
import '../../shorts/youtub_player.dart';



class UserUploadWebsite extends StatefulWidget {
  final String DataType;

  const UserUploadWebsite({
    super.key,
    required this.DataType,
  });

  @override
  State<UserUploadWebsite> createState() => CreateSList();
}
class CreateSList extends State<UserUploadWebsite>{
  late SharedPreferences prefs;
  List<VideoDataModel> UserdData = [];
  List<VideoDataModel> UserdDataApprovPending = [];
  List<VideoDataModel> UserdDataApproved = [];

  int UserID = 0;

  @override
  void initState() {
    super.initState();
    //fetchUploadedShorts();
  }
  Future<void> fetchUploadedShorts() async {
    prefs = await SharedPreferences.getInstance();
    UserID = prefs.getInt('Userid')!;
    print("-------------------- >>>>>>>>>>>>>>>>>>>>>> UserID : ${UserID} , ${widget.DataType}");
    var body = {
      "ACTION": "30",
      "ROWNO": 0,
      "GROUPID": UserID,
    };
    var jsonBody = json.encode(body);

    // you can replace your api link with this link
    var response = await
    http.post(Uri.parse(AppConfig.BASE_API_URL + 'Fetch_SelfStudy.php'),
        body: jsonBody,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }
    );
    print("--------------------Save server response : ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);

      print(">>>>>>>>>>>>>>>>>jsonData------------------------jsonData----------------- : ${jsonData}");
      setState(() {
        UserdData = jsonData.map((data) => VideoDataModel.fromJson(data)).toList();
        UserdDataApprovPending = UserdData.where((data) => data.Approve.contains("0")).toList();
        UserdDataApproved = UserdData.where((data) => data.Approve.contains("1")).toList();
        print(">>>>>>>>>>>>>>>>>UserUploadData------------------------UserUploadData----------------- : ${UserdDataApproved}");
      });
    }

  }
  //------------------------
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchUploadedShorts,
        child : Container(
          color: Colors.grey,
          child: SafeArea(
            child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(widget.DataType,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22,
                            color: Color.fromRGBO(189, 183, 8, 8)),),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.fromLTRB(5, 15, 5, 10),
                      child: Text("Approved",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22,
                            color: Colors.black),),
                    ),
                  ),
                  // SliverGrid(
                  //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  //     maxCrossAxisExtent: 180.0,
                  //     mainAxisSpacing: 3.0,
                  //     crossAxisSpacing: 3.0,
                  //     childAspectRatio: 0.46,
                  //   ),
                  //   delegate: SliverChildBuilderDelegate(
                  //         (BuildContext context, int index) {
                  //       return Column(
                  //         children: [
                  //           Container(
                  //             margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  //             decoration: BoxDecoration(
                  //               color: Color.fromARGB(198, 195, 222, 216),
                  //               borderRadius: BorderRadius.circular(10),
                  //             ),
                  //             child: Column(
                  //               children: [
                  //                 Container(
                  //                   width: DW * 0.3,
                  //                   height: DH * 0.15,
                  //                   margin: EdgeInsets.all(5),
                  //                   alignment: Alignment.center,
                  //                   child: Image.network(UserdDataApproved[index].ImgUrl, fit: BoxFit.fill,
                  //                     scale: 0.3,),
                  //                 ),
                  //                 Container(
                  //                   padding: EdgeInsets.all(3),
                  //                   width: DW * 0.28,
                  //                   height: DH * 0.05,
                  //                   child: Text("Title : ${UserdDataApproved[index].SubTitle}"),
                  //                 ),
                  //                 Container(
                  //                   width: DW * 0.28,
                  //                   height: DH * 0.09,
                  //                   padding: EdgeInsets.all(3),
                  //                   child: Text("Group : ${UserdDataApproved[index].GroupName}"),
                  //                 ),
                  //               ],
                  //             ),
                  //           )
                  //         ],
                  //       );
                  //
                  //     },
                  //     childCount: UserdDataApproved.length,
                  //   ),
                  // ),
                  //----------------------------
                  SliverToBoxAdapter(
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.fromLTRB(5, 25, 5, 10),
                      child: Text("Approval Pending",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22,
                            color: Colors.black),),
                    ),
                  ),
                  //--------------
                  // SliverGrid(
                  //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  //     maxCrossAxisExtent: 180.0,
                  //     mainAxisSpacing: 3.0,
                  //     crossAxisSpacing: 3.0,
                  //     childAspectRatio: 0.4,
                  //   ),
                  //   delegate: SliverChildBuilderDelegate(
                  //         (BuildContext context, int index) {
                  //       return Column(
                  //         children: [
                  //           Container(
                  //             margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  //             decoration: BoxDecoration(
                  //               color: Color.fromARGB(198, 195, 222, 216),
                  //               borderRadius: BorderRadius.circular(10),
                  //             ),
                  //             child: Column(
                  //               children: [
                  //                 Container(
                  //                   margin: EdgeInsets.all(5),
                  //                   alignment: Alignment.center,
                  //                   child: Image.network(UserdDataApprovPending[index].ImgUrl, fit: BoxFit.fill,),
                  //
                  //                 ),
                  //                 Container(
                  //                   width: DW * 0.28,
                  //                   height: DH * 0.05,
                  //                   padding: EdgeInsets.all(3),
                  //                   child: Text("Title : ${UserdDataApprovPending[index].SubTitle}"),
                  //                 ),
                  //                 Container(
                  //                   width: DW * 0.28,
                  //                   height: DH * 0.09,
                  //                   padding: EdgeInsets.all(3),
                  //                   child: Text("Group : ${UserdDataApprovPending[index].GroupName}"),
                  //                 ),
                  //               ],
                  //             ),
                  //           )
                  //         ],
                  //       );
                  //
                  //     },
                  //     childCount: UserdDataApprovPending.length,
                  //   ),
                  // ),
                  //---------------


                ]
            ),
          ),
        ),
      ),
    );
  }



//-----------------------



//------------------------------------------
} //CreateSList