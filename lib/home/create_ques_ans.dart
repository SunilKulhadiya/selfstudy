import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';
import '../module/ques_ans_model.dart';
import '../module/user_data_model.dart';
import 'package:selfstudy/module/user_token_model.dart';
import 'package:selfstudy/firebase_api/firebase_api.dart';


class CreateQuestionAnswer extends StatefulWidget {
  final String PageTitle;
  final int QID;
  final int UserID;
  final int Action;
  final String Question;
  final BuildContext context;

  const CreateQuestionAnswer({super.key,
    required this.PageTitle,
    required this.QID,
    required this.UserID,
    required this.Action,
    required this.Question,
    required this.context
  });

  @override
  State<CreateQuestionAnswer> createState() => CreateSList();
}
class CreateSList extends State<CreateQuestionAnswer>{
  List<UserTokenModel> UserTokens = [];
  List<QAnsModel> QuestionAnswer = [];
  late SharedPreferences prefs;
  final QATextController = TextEditingController();
  var TEXTQA = "";
  String ServerMessage = 'Submit';

  void QATextChanged() {
      TEXTQA = QATextController.text;
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
    QATextController.addListener(QATextChanged);
  }
  Future<void> fetchUsers() async {
    final body = {
      "ACTION": "38",
      "ROWNO": "0",
      "GROUPID": widget.UserID,
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
        UserTokens = jsonData.map((data) => UserTokenModel.fromJson(data)).toList();
      });
    } else {
    }
  }

  Future<void> SubmitToServer() async {
    if(TEXTQA.length > 1) {
      setState(() {
        ServerMessage = "Please wait......";
      });
      var now = new DateTime.now();
      var Dateformatter = new DateFormat('yyyy-MM-dd');
      var Timeformatter = DateFormat('kk:mm');
      print("------Q       A--------::::::::::::::::------TEXTQA : ${TEXTQA}");

      prefs = await SharedPreferences.getInstance();
      final body = {
        "ACTION": "39",
        "ROWNO": "0",
        "GROUPID": widget.UserID,
        "QUESTIONID": widget.QID,
        "UserName": prefs.getString('UserName') == null ? "Skand Solution" : prefs
            .getString('UserName'),
        "QUESTANS": TEXTQA,
        "DATE": Dateformatter.format(now),
        "Time": Timeformatter.format(now),
      };
      final jsonBody = json.encode(body);

      // you can replace your api link with this link
      final response = await
      http.post(Uri.parse(AppConfig.BASE_API_URL + 'Fetch_SelfStudy.php'),
          body: jsonBody,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          }
      );
      if (response.statusCode == 200) {
        print(
            "------Q       A--------::::::::::::::::------response.body : ${response
                .body}");
        // List<dynamic> jsonData = json.decode(response.body);
        // setState(() {
        //   QuestionAnswer =
        //       jsonData.map((data) => QAnsModel.fromJson(data)).toList();
        //   //UserId = (prefs.getInt('Userid') == null ? 0 : prefs.getInt('Userid'))!;
        // });
        //print("------Q       A--------::::::::::::::::------length : ${QuestionAnswer[4].Qid} ${QuestionAnswer[4].Name}");
        //------------------send Notification
        int j = 0;
        for (j = 0; j < UserTokens.length; j++) {
          print("------Q       A--------::::::::::::::::------UserTokens[j].UserToken : ${UserTokens[j].UserToken}");
          FirebaseApi().SendNotification(widget.QID > 0 ? "Answer" : "Question",
              TEXTQA.substring(0, TEXTQA.length > 100 ? 100 : TEXTQA.length),
              UserTokens[j].UserToken);
          if(j>=UserTokens.length-1){
            setState(() {
              ServerMessage = "Successfully submitted....";
            });
          }
        }
        Future.delayed(Duration(seconds: 7), () {
          setState(() {
            ServerMessage = "Submite";
          });
        });
      } else {}
    }
  }
  void _incrementCounter() {
  }

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;
    return Stack(
        children: [

          Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(117, 254, 250, 51),
              title: Text(widget.PageTitle),
            ),
            body:Center(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            padding: EdgeInsets.all(5),
                            child: widget.Question.length > 0 ? Text('Q.: ${widget.Question}') : null,
                          ),
                        ]
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: DW * 0.98,
                                height: DH * 0.3,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: TextFormField(
                                  controller: QATextController,
                                  maxLines: 10,

                                  // onChanged: (value) {
                                  //   SubTitle = SubTitleController.text;
                                  // },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    // filled: true,
                                    // fillColor: Colors.grey,
                                    hintText: widget.Question.length > 0 ? 'Your Answer ?' : 'Your Question ?',
                                  ),
                                ),
                              ),
                            ]
                        ),
                    ),
                    SliverToBoxAdapter(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                height: DH * 0.05,
                                margin: EdgeInsets.fromLTRB(30, 100, 30, 30),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: GestureDetector(
                                  onTap: (){
                                    SubmitToServer();
                                  },
                                  child: Text(ServerMessage,
                                    style: TextStyle(fontSize: 22,
                                        color: Colors.white),
                                  ),
                                )
                            ),
                        ]
                        ),
                    ),
                          ]
                      ),
                    ),

                  ],
                )

            ),
          ),

        ]
    );
  }
//----------------------------------------------------------

} //CreateSList
