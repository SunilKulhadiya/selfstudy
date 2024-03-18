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
//import 'package:selfstudy/generalTools/general_tools.dart';
//import 'package:selfstudy/repository/api_request.dart';

final List<String> VideoUrl = <String>[
  'https://sewabhartidabra.in/Self_Study/GK/Video/Gk2.mp4',
  'https://sewabhartidabra.in/Self_Study/GK/Video/Gk3.mp4',
  'https://sewabhartidabra.in/Self_Study/GK/Video/Gk4.mp4'];

class ShortsList extends StatefulWidget {
  final String clientName;
  final int GroupID;
  final int Action;
  final BuildContext context;

  const ShortsList({super.key,
    required this.clientName,
    required this.GroupID,
    required this.Action,
    required this.context});

  @override
  State<ShortsList> createState() => CreateSList();
}
class CreateSList extends State<ShortsList>{
  List<VideoDataModel> VDModel = [];
  List<SubTitleDataModel> VSubTitle = [];
  List<AuthorDataModel> AuthTeacher = [];

  ScrollController LVcontroller = ScrollController();
  int StartRowNo = 0;
  late int VDResponseCode = 200;
  late int drp1;
  late int drpAuthor1;
  //late String SelectedSbuTitle;
  late SubTitleDataModel SelectedSbuTitle = SubTitleDataModel(SubTitle: "Select you like");
  late AuthorDataModel SelectedTeacher = AuthorDataModel(Author: "Select Teacher");


  @override
  void initState() {
    super.initState();
    drp1 = 0;
    drpAuthor1 = 0;
    // SelectedSbuTitle = VideoDataModel(id: 0, title: "",
    //     SubTitle: "Select you like", Author: "", Url: "", ImgUrl: "",
    //     GroupID: "0", Approve: "0");

    print("-----------<<<<<<<<<<<<<<< &&&&&&&&&&&&&&&&&& >>>>>>>>>>>>>>>>>");

    LVcontroller.addListener(handleScrolling);
    print("-----------<<<<<<<<<<<<<<< &&&&&&&&&&&&&&&&&& ${LVcontroller}");
    fetchProducts(Action: widget.Action, StartRN: StartRowNo,
        GrpID: widget.GroupID, SubT: "", Auth: "");
    fetchSingleTimeData();
    // setState(() {
    //   VDModel =  ApiRequest.ShortList_Fetch(url: "Fetch_SelfStudy",
    //       Action: widget.Action, StartRowNo: StartRowNo, GroupID: widget.GroupID) as List<VideoDataModel>;
    // });


  }
  Future<void> fetchSingleTimeData() async {
    final body = {
      "ACTION": 50,
      "ROWNO": "0",
      "GROUPID": widget.GroupID,
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
      print("------Sub title--------::::::::::::::::------response.body : ${response.body}");
      List<dynamic> jsonData = json.decode(response.body);
      print("--------------------jsonData : ${jsonData}");
      SubTitleDataModel subTitle = new SubTitleDataModel(SubTitle: "Select you like");
      VSubTitle.add(subTitle);
      for(var h in jsonData) {
        print("--------------------***************************************** h : ${h}");
        SubTitleDataModel subTitle = new SubTitleDataModel(SubTitle: h['sub_title']);
        VSubTitle.add(subTitle);
      }
      print("--------------------SubTitle : ${VSubTitle}");
    } else {
      print("????????????????????????????  Error GID : ${widget.GroupID}");
      print("????????????????????????????  Error Action : ${widget.Action}");
    }

    final body1 = {
      "ACTION": 501,
      "ROWNO": "0",
      "GROUPID": widget.GroupID,
      "SubTitle": ""
    };
    final jsonBody1 = json.encode(body1);

    // you can replace your api link with this link
    final response1 = await
    http.post(Uri.parse(AppConfig.BASE_API_URL+'Fetch_SelfStudy.php'),
        body: jsonBody1,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json',}
    );
    if (response1.statusCode == 200) {
      print("--------------::::::::::::::::------response.body : ${response1.body}");
      List<dynamic> jsonData1 = json.decode(response1.body);

      AuthorDataModel authTitle = new AuthorDataModel(Author: "Select Teacher");
      AuthTeacher.add(authTitle);
      for(var h in jsonData1) {
        AuthorDataModel authTitle = new AuthorDataModel(Author: h['author']);
        AuthTeacher.add(authTitle);
        print("--------------------********************************>>>>>>>>>>        AuthTeacher ********* h : ${AuthTeacher}");
      }
    } else {
      print("????????????????????????????  Error GID : ${widget.GroupID}");
      print("????????????????????????????  Error Action : ${widget.Action}");
    }

  }
  void handleScrolling() {
    if (LVcontroller.position.pixels == LVcontroller.position.maxScrollExtent) {
      print("-----------<<<<<<<<<<<<<<< StartRowNo ---------------------------------");
      // setState(() {
      //   StartRowNo += 3;
      // });
      print("-----------<<<<<<<<<<<<<<< StartRowNo ${StartRowNo}");
    }
  }
  Future<void> fetchProducts({required Action,
    required StartRN, required GrpID, required SubT, required Auth}) async {
    print(">>>>>>>>>>>>>>>>fetchProducts>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(">>>>>>>>>>>>>>>>fetchProducts>>>>>>>>>>>>>>>>>>>>>>>>>>>>> GID : ${GrpID}");
    print(">>>>>>>>>>>>>>>>fetchProducts>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Action : ${Action}");
    final body = {
      "ACTION": Action,
      "ROWNO": StartRN,
      "GROUPID": GrpID,
      "SubTitle": SubT,
      "AUTHORNAME": Auth,
    };
    final jsonBody = json.encode(body);

    // you can replace your api link with this link
    final response = await
    http.post(Uri.parse(AppConfig.BASE_API_URL+'Fetch_SelfStudy.php'),
        body: jsonBody,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json',}
    );
    print("--------------::::::::>>>>>>>>>>>::::::::------ 1111     response : ${response.body}");
    if (response.statusCode == 200) {
      //print(responses['code']);

      List<dynamic> jsonData = json.decode(response.body);

      //VideoDataModel VDResponse = new VideoDataModel(id: jsonData[0][], title: title, SubTitle: SubTitle, Author: Author, Url: Url, ImgUrl: ImgUrl, GroupID: GroupID, Approve: Approve);
      print("--------------::::::::>>>>>>>>>>>::::::::------jsonData : ${jsonData[0]}");
      if(jsonData[0]["title"] == "0" && jsonData[0]["url"] == "0"){
        VDResponseCode = 1;
      }else{
        VDResponseCode = 200;
        setState(() {
          VDModel = jsonData.map((data) => VideoDataModel.fromJson(data)).toList();
          //VSubTitle.add(VDModel as VideoDataModel);
        });
      }

    } else {
      VDResponseCode = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(117, 254, 250, 51),
        title: Text(widget.clientName),
      ),
      body:Center(
        child: ListView(
          children: [
            Container(
              height: DH * 0.05,
              width: DW,
              alignment: Alignment.topCenter,
              //color: Color.fromRGBO(1, 1, 1, 50),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(177, 161, 188, 50),
                    ),
                    alignment: Alignment.centerRight,
                    width: DW * 0.492,
                    child: CDropdownButton(context),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(5.3, 0, 0, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(177, 161, 188, 50),
                    ),
                    alignment: Alignment.centerRight,
                    width: DW * 0.492,
                    child: CDropdownAuthor(context),
                  ),
                ],
              ),
            ),
            Container(
              height: 777,
              width: 290,
              child: VDResponseCode == 200 ? ListView.builder(
                controller: LVcontroller,
                itemCount: VDModel.isEmpty ? 0 : VDModel.length,
                itemBuilder: (BuildContext context, int index) =>

                // (VDModel[index].SubTitle == SelectedSbuTitle ||
                //     SelectedSbuTitle == "Select")?
                Container(
                  width: 290,
                  height: 777,
                  alignment: Alignment.center,
                  key: UniqueKey(),
                  child: Container(
                      key: new PageStorageKey(
                        "keydata$index",
                      ),

                      child: YouTubePlayer(
                        VideoUrl: VDModel[index].Url,
                        AutoPlay: index == 0 ? 1 : 0,
                        PageNo: 1,
                        context: context,
                      )
                  ),
                ),
                // : Container(
                //         width: 290,
                //         height: 777,
                //         alignment: Alignment.center,
                //       ),
              ): Container(
                alignment: Alignment.center,
                child: Text("Sorry, no data available",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
              ),
            ),
          ],
        ),

      ),
    );
  }
//----------------------------------------------------------
  CDropdownButton(BuildContext context) {
    print("/////------------------------------------      CDropdownButton --------------->>>>>>>>>>>>>>********************** ${SelectedSbuTitle.SubTitle}");

    final double DW = MediaQuery.of(context).size.width;

    if(drp1 == 0){
      return Container(
        width: DW * 0.692,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
        child: DropdownButton<SubTitleDataModel>(
          icon: Icon(Icons.filter_alt_sharp, color: Color.fromRGBO(1, 1, 1, 51),),
          iconSize: 24,
          elevation: 16,
          isExpanded: false,
          isDense: false,
          alignment: Alignment.centerLeft,
          style: TextStyle(color: Colors.deepPurple),
          hint: Container(
            width: DW * 0.4,
            child: new Text('Select you like', textAlign: TextAlign.start,
              style: TextStyle(fontFamily: "Gotham"),
            ),
          ),
          onChanged: (newValue) {
            setState(() {
              SelectedSbuTitle = newValue!;
              drp1 = 1;
            });
            if(SelectedTeacher.Author == "Select Teacher") {
              if(SelectedSbuTitle.SubTitle == 'Select you like'){
                fetchProducts(Action: 5,
                    StartRN: StartRowNo,
                    GrpID: widget.GroupID,
                    SubT: "",
                    Auth: "");
              }else{
                fetchProducts(Action: 51,
                    StartRN: StartRowNo,
                    GrpID: widget.GroupID,
                    SubT: newValue!.SubTitle,
                    Auth: "");
              }
            }else{
              fetchProducts(Action: 5152,
                  StartRN: StartRowNo,
                  GrpID: widget.GroupID,
                  SubT: newValue!.SubTitle,
                  Auth: SelectedSbuTitle.SubTitle);
            }
          },
          //value: SelectedSbuTitle,

          items:
          VSubTitle.map<DropdownMenuItem<SubTitleDataModel>>((SubTitleDataModel Vvalue) {
            return DropdownMenuItem<SubTitleDataModel>(
              value: Vvalue,
              child: Container(
                width: DW * 0.4,
                alignment: Alignment.centerLeft,
                child: new Text(
                  Vvalue.SubTitle, textAlign: TextAlign.start,
                  style: TextStyle(fontFamily: "Gotham"),

                ),
              ),

            );
          }).toList(),

        ),
      );

    }else{
      return Container(
        width: DW * 0.692,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
        child: DropdownButton<SubTitleDataModel>(
          icon: Icon(Icons.filter_alt_sharp, color: Color.fromRGBO(1, 1, 1, 51),),
          iconSize: 24,
          elevation: 16,
          isExpanded: false,
          isDense: false,
          alignment: Alignment.centerLeft,
          style: TextStyle(color: Colors.deepPurple),
          hint: Container(
            width: DW * 0.4,
            child: new Text('Select you like', textAlign: TextAlign.start,
              style: TextStyle(fontFamily: "Gotham"),
            ),
          ),
          onChanged: (newValue) {
            if(SelectedTeacher.Author == "Select Teacher") {
              if(SelectedSbuTitle.SubTitle == 'Select you like'){
                fetchProducts(Action: 5,
                    StartRN: StartRowNo,
                    GrpID: widget.GroupID,
                    SubT: "",
                    Auth: "");
              }else{
                fetchProducts(Action: 51,
                    StartRN: StartRowNo,
                    GrpID: widget.GroupID,
                    SubT: newValue!.SubTitle,
                    Auth: "");
              }
            }else{
              fetchProducts(Action: 5152,
                  StartRN: StartRowNo,
                  GrpID: widget.GroupID,
                  SubT: newValue!.SubTitle,
                  Auth: SelectedSbuTitle.SubTitle);
            }
            setState(() {
              SelectedSbuTitle = newValue!;
              drp1 = 1;
            });
          },
          value: SelectedSbuTitle,

          items:
          VSubTitle.map<DropdownMenuItem<SubTitleDataModel>>((SubTitleDataModel Vvalue) {
            return DropdownMenuItem<SubTitleDataModel>(
              value: Vvalue,
              child: Container(
                width: DW * 0.4,
                alignment: Alignment.centerLeft,
                child: new Text(
                  Vvalue.SubTitle, textAlign: TextAlign.start,
                  style: TextStyle(fontFamily: "Gotham"),

                ),
              ),

            );
          }).toList(),
        ),
      );

    }


  }
//----------------------------------------------------------
  CDropdownAuthor(BuildContext context) {
    print("/////>>>>>>>>>>>>--------------------        CDropdownAuthor  >>********************** ${AuthTeacher}");

    final double DW = MediaQuery.of(context).size.width;
    if(drpAuthor1 == 0){
      return Container(
        width: DW * 0.692,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
        child: DropdownButton<AuthorDataModel>(
          icon: Icon(Icons.filter_alt_sharp, color: Color.fromRGBO(1, 1, 1, 51),),
          iconSize: 24,
          elevation: 16,
          alignment: Alignment.centerLeft,
          style: TextStyle(color: Colors.deepPurple),
          hint: Container(
            width: DW * 0.4,
            child: new Text('Select Teacher', textAlign: TextAlign.start,
              style: TextStyle(fontFamily: "Gotham"),
            ),
          ),
          onChanged: (newValue) {
            if (SelectedSbuTitle.SubTitle == "Select you like"){
              if(SelectedTeacher.Author == 'Select Teacher'){
                fetchProducts(Action: 5,
                    StartRN: StartRowNo,
                    GrpID: widget.GroupID,
                    SubT: "",
                    Auth: "");
              }else{
                fetchProducts(Action: 52,
                    StartRN: StartRowNo,
                    GrpID: widget.GroupID,
                    SubT: "",
                    Auth: newValue!.Author);
              }
            }else{
              fetchProducts(Action: 5152,
                  StartRN: StartRowNo,
                  GrpID: widget.GroupID,
                  SubT: SelectedSbuTitle.SubTitle,
                  Auth: newValue!.Author);
            }
              setState(() {
                drpAuthor1 = 1;
                SelectedTeacher = newValue!;
                print("/////>>>>>>>>>    11----    SelectedTeacher        >>>>>>>>>>>>>>>>>>///////////// ${SelectedTeacher.Author}");
              });

          },
          //value: SelectedTeacher,

          items:
          AuthTeacher.map<DropdownMenuItem<AuthorDataModel>>((AuthorDataModel Vvalue) {
            return DropdownMenuItem<AuthorDataModel>(
              value: Vvalue,
              child: Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  Vvalue.Author, textAlign: TextAlign.start,
                  style: TextStyle(fontFamily: "Gotham"),
                ),
              ),
            );
          }).toList(),
        ),
      );

    }else{
      return Container(
        width: DW * 0.692,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
        child: DropdownButton<AuthorDataModel>(
          icon: Icon(Icons.filter_alt_sharp, color: Color.fromRGBO(1, 1, 1, 51),),
          iconSize: 24,
          elevation: 16,
          alignment: Alignment.centerLeft,
          style: TextStyle(color: Colors.deepPurple),
          value: SelectedTeacher,
          hint: Container(
            width: DW * 0.4,
            child: new Text('Select Teacher', textAlign: TextAlign.start,
              style: TextStyle(fontFamily: "Gotham"),
            ),
          ),
          onChanged: (newValue) {
            if (SelectedSbuTitle.SubTitle == "Select you like"){
              if(SelectedTeacher.Author == 'Select Teacher'){
                fetchProducts(Action: 5,
                    StartRN: StartRowNo,
                    GrpID: widget.GroupID,
                    SubT: "",
                    Auth: "");
              }else{
              fetchProducts(Action: 52,
                  StartRN: StartRowNo,
                  GrpID: widget.GroupID,
                  SubT: "",
                  Auth: newValue!.Author);
              }
            }else{
              fetchProducts(Action: 5152,
                  StartRN: StartRowNo,
                  GrpID: widget.GroupID,
                  SubT: SelectedSbuTitle,
                  Auth: newValue!.Author);
            }
            setState(() {
              SelectedTeacher = newValue!;
              print("/////>>>>>>>>>       222--- SelectedTeacher        >>>>>>>>>>>>>>>>>>///////////// ${SelectedTeacher}");
            });
          },

          items:
          AuthTeacher.map<DropdownMenuItem<AuthorDataModel>>((AuthorDataModel Vvalue) {
            return DropdownMenuItem<AuthorDataModel>(
              value: Vvalue,
              child: Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  Vvalue.Author, textAlign: TextAlign.start,
                  style: TextStyle(fontFamily: "Gotham"),
                ),
              ),
            );
          }).toList(),
        ),
      );

    }


  }

} //CreateSList
