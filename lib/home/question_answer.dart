import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:selfstudy/shorts/video_player.dart';
import 'package:selfstudy/module/data_module.dart';
import 'package:selfstudy/shorts/youtub_player.dart';
import 'package:selfstudy/module/sub_title_data_model.dart';
import 'package:selfstudy/module/author_data_model.dart';

import '../app_config.dart';
import '../module/ques_ans_model.dart';
//import 'package:selfstudy/generalTools/general_tools.dart';
//import 'package:selfstudy/repository/api_request.dart';

class QuestionAnswerList extends StatefulWidget {
  // final String clientName;
  // final int GroupID;
  // final int Action;
  // final BuildContext context;

  const QuestionAnswerList({super.key,
    // required this.clientName,
    // required this.GroupID,
    // required this.Action,
    // required this.context
  });

  @override
  State<QuestionAnswerList> createState() => CreateSList();
}
class CreateSList extends State<QuestionAnswerList>{
  List<QAnsModel> QuestionAnswer = [];

  ScrollController LVcontroller = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchQuestAnsData();
  }
  Future<void> fetchQuestAnsData() async {
    final body = {
      "ACTION": "37",
      "ROWNO": "0",
      "GROUPID": "0",
      "SubTitle": ""
    };
    final jsonBody = json.encode(body);

    // you can replace your api link with this link
    final response = await
    http.post(Uri.parse(AppConfig.BASE_API_URL+'Fetch_SelfStudy.php'),
        body: jsonBody,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json',}
    );
    if (response.statusCode == 200) {
      print("------Q       A--------::::::::::::::::------response.body : ${response.body}");
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        QuestionAnswer = jsonData.map((data) => QAnsModel.fromJson(data)).toList();
      });

    } else {
    }

  }
  void handleScrolling() {
    if (LVcontroller.position.pixels == LVcontroller.position.maxScrollExtent) {
      print("-----------<<<<<<<<<<<<<<< StartRowNo ---------------------------------");
      // setState(() {
      //   StartRowNo += 3;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(117, 254, 250, 51),
        title: Text("Question/Answer"),
      ),
      body:Center(
        child: ListView(
          children: [
            Container(
              height: DH * 0.8,
              width: DW * 0.98,
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                controller: LVcontroller,
                itemCount: QuestionAnswer.isEmpty ? 0 : QuestionAnswer.length,
                itemBuilder: (BuildContext context, int index) =>
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.bottomLeft,
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(228, 229, 229, 51),
                          borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: QuestionAnswer.length >0 ? Text('By: ${QuestionAnswer[index].Name}',
                              style: TextStyle(fontSize: 16, color: Colors.black),) : null,
                          ),
                          Container(
                            child: QuestionAnswer.length >0 ? Text('Q.: ${ QuestionAnswer[index].UserText}',
                              style: TextStyle(fontSize: 16,
                                  color: Colors.black),) : null,
                          ),
                        ],
                      )
                      ),
                    ],
                  ),
              )
            ),
          ],
        ),

      ),
    );
  }
//----------------------------------------------------------

} //CreateSList
