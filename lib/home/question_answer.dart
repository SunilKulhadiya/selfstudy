import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';
import '../module/ques_ans_model.dart';
import 'package:selfstudy/home/create_ques_ans.dart';
//import 'package:selfstudy/repository/api_request.dart';

int UserId = 0;

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
  late SharedPreferences prefs;

  ScrollController LVcontroller = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchQuestAnsData();
  }
  Future<void> fetchQuestAnsData() async {
    prefs = await SharedPreferences.getInstance();

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
        UserId = (prefs.getInt('Userid') == null ? 0 : prefs.getInt('Userid'))!;
      });
      print("------Q       A--------::::::::::::::::------length : ${QuestionAnswer[4].Qid} ${QuestionAnswer[4].Name}");

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
        title: Text("Question/Answer"),
      ),
      body: RefreshIndicator(
          onRefresh: fetchQuestAnsData,
        child: Column(
          children: [
            Container(
              height: DH * 0.883,
              width: DW * 0.98,
              child: ListView(
                children: [
                  Container(
                      height: DH * 0.883,
                      width: DW * 0.98,
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                        controller: LVcontroller,
                        itemCount: QuestionAnswer.isEmpty ? 0 : QuestionAnswer.length,
                        itemBuilder: (BuildContext context, int index) =>
                        QuestionAnswer[index].Qid >0 ? Container() : Column(
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
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              child: Text('@',
                                                style: TextStyle(fontSize: 16, color: Colors.white),),
                                            ),
                                            Container(
                                              child: Text(QuestionAnswer[index].Name,
                                                style: TextStyle(fontSize: 16, color: Colors.blue),),
                                            )
                                          ],
                                        )
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text('Q.: ${ QuestionAnswer[index].UserText}',
                                        style: TextStyle(fontSize: 16, color: Colors.black),),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      child: QuestionAnswer[index].UserID == UserId ? Icon(Icons.edit_note, size: 40,) :
                                        Icon(Icons.add, size: 0,),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      alignment: Alignment.bottomLeft,
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text('Answer',
                                                style: TextStyle(fontSize: 20, color: Colors.black38,
                                                    fontWeight: FontWeight.bold),),
                                            ),
                                            Container(
                                              child: GestureDetector(
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) =>
                                                CreateQuestionAnswer(PageTitle: 'Create Answer',
                                                    QID: QuestionAnswer[index].id,
                                                    UserID: UserId,
                                                    Action: 39,
                                                    Question: QuestionAnswer[index].UserText,
                                                    context: context)
                                                ));
                                              },
                                                child: Icon(Icons.add, size: 35, color: Colors.blue,),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: ShowAnswer(QuestionAnswer[index].id),
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
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            ),
          ],
        )

      ),
    ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 40, 15, 0),
              child: GestureDetector(
              onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                CreateQuestionAnswer(PageTitle: 'Create Question', QID: 0,
                    UserID: UserId,
                    Action: 39,
                    Question: "", context: context)
              ));
              },
              child: Image.asset("assets/images/letter-q.png",)

            ),
          ),
          ),
        ]
    );
  }
//----------------------------------------------------------
  ShowAnswer(int QID) {
    int j = 0;
    for(j =0; j<QuestionAnswer.length; j++){
      if(QuestionAnswer[j].Qid == QID){
        return Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Text('@',
                      style: TextStyle(fontSize: 16, color: Colors.white),),
                ),
                  Container(
                    child: Text(QuestionAnswer[j].Name,
                      style: TextStyle(fontSize: 16, color: Colors.blue),),
                  ),
                ],
                )
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: Text('${ QuestionAnswer[j].UserText}',
                style: TextStyle(fontSize: 16, color: Colors.black),),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: QuestionAnswer[j].UserID == UserId ? Icon(Icons.edit_note, size: 40,) :
              Icon(Icons.add, size: 0,),
            ),
          ],

        );
      }
    }
  }

} //CreateSList
