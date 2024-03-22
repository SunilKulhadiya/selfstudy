import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';
import 'package:selfstudy/module/main_group_model.dart';
import 'package:selfstudy/module/server_response_model.dart';
import 'package:selfstudy/module/data_response_model.dart';
import 'package:selfstudy/module/user_data_model.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => CreateSList();
}
class CreateSList extends State<UserProfile> {
  late SharedPreferences prefs;
  List<DataResponseModel> ServerRespons = [];
  List<UserDataModel> UserData = [];
  int UserID = 0;
  String ServerMessage = 'Submit';
  var TEXTUSERNAME = "";
  final USERNAMEController = TextEditingController();
  var TEXTEMAIL = "";
  final EMAILController = TextEditingController();
  var TEXTPASSWORD = "";
  final PASSWORDController = TextEditingController();
  var TEXTCOUNTRY = "";
  final COUNTRYController = TextEditingController();
  var TEXTSTATE = "";
  final STATEController = TextEditingController();
  var TEXTCITY = "";
  final CITYController = TextEditingController();
  var TEXTBANKNAME = "";
  final BANKNAMEController = TextEditingController();
  var TEXTIFSCCODE = "";
  final IFSCCODEController = TextEditingController();
  var TEXTHOLDERNAME = "";
  final HOLDERNAMEController = TextEditingController();
  var TEXTACCOUNTNUMBER = "";
  final ACCOUNTNUMBERController = TextEditingController();
  var TEXTCOUNTRYCODE = "";
  final COUNTRYCODEController = TextEditingController();
  var TEXTCONTACTNO = "";
  final CONTACTNOController = TextEditingController();

  void USERNAMEChanged() {
    setState(() {
      TEXTUSERNAME = USERNAMEController.text;
    });
  }
  void EMAILChanged() {
    setState(() {
      TEXTEMAIL = EMAILController.text;
    });
  }
  void PASSWORDChanged() {
    setState(() {
      TEXTPASSWORD = PASSWORDController.text;
    });
  }
  void COUNTRYChanged() {
    setState(() {
      TEXTCOUNTRY = COUNTRYController.text;
    });
  }
  void STATEChanged() {
    setState(() {
      TEXTSTATE = STATEController.text;
    });
  }
  void CITYChanged() {
    setState(() {
      TEXTCITY = CITYController.text;
    });
  }
  void BANKNAMEChanged() {
    setState(() {
      TEXTBANKNAME = BANKNAMEController.text;
    });
  }
  void IFSCCODEChanged() {
    setState(() {
      TEXTIFSCCODE = IFSCCODEController.text;
    });
  }
  void HOLDERNAMEChanged() {
    setState(() {
      TEXTHOLDERNAME = HOLDERNAMEController.text;
    });
  }
  void ACCOUNTNOChanged() {
    setState(() {
      TEXTACCOUNTNUMBER = ACCOUNTNUMBERController.text;
    });
  }
  void COUNTRYCODEChanged() {
    setState(() {
      TEXTCOUNTRYCODE = COUNTRYCODEController.text;
    });
  }
  void CONTACTNOChanged() {
    setState(() {
      TEXTCONTACTNO = CONTACTNOController.text;
    });
  }


  @override
  void initState() {
    super.initState();
    fetchProfile();
    USERNAMEController.addListener(USERNAMEChanged);
    EMAILController.addListener(EMAILChanged);
    PASSWORDController.addListener(PASSWORDChanged);
    COUNTRYController.addListener(COUNTRYChanged);
    STATEController.addListener(STATEChanged);
    CITYController.addListener(CITYChanged);
    BANKNAMEController.addListener(BANKNAMEChanged);
    IFSCCODEController.addListener(IFSCCODEChanged);
    HOLDERNAMEController.addListener(HOLDERNAMEChanged);
    ACCOUNTNUMBERController.addListener(ACCOUNTNOChanged);
    COUNTRYCODEController.addListener(COUNTRYCODEChanged);
    CONTACTNOController.addListener(CONTACTNOChanged);
  }

  Future<void> fetchProfile() async {
    prefs = await SharedPreferences.getInstance();
    UserID = prefs.getInt('Userid')!;
    print("/////////////*********************--------------------UserID : ${UserID}");
    if(UserID > 0) {
      var body = {
        "ACTION": "25",
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
      if (response.statusCode == 200) {
        print("------------------===============================response.body : ${response.body}");
        print("------------------===============================response.body : ${response.body.length}");
        List<dynamic> jsonData = json.decode(response.body);
        print("------------------===============================jsonData : ${jsonData}");
        print("------------------============================Length ===jsonData : ${jsonData.length}");
        // ServerRespons = jsonData.map((mdata) => DataResponseModel.fromJson(mdata)).toList();
        // print("------------------===============================ServerRespons : ${ServerRespons}");
        // print("------------------===============================ServerRespons : ${ServerRespons[0].Data}");
        if(jsonData.length > 0){
          UserData = jsonData.map((data) => UserDataModel.fromJson(data)).toList();
          print("------------------===========?????????????????????=UserData : ${UserData[0].HolderName}");
          USERNAMEController.text = UserData[0].Name;
          EMAILController.text = UserData[0].Email;
          PASSWORDController.text = UserData[0].PassWord;
          CONTACTNOController.text = UserData[0].ContactNo;
          COUNTRYController.text = UserData[0].Country;
          STATEController.text = UserData[0].State;
          CITYController.text = UserData[0].City;
          BANKNAMEController.text = UserData[0].BankName;
          IFSCCODEController.text = UserData[0].IFSCcode;
          HOLDERNAMEController.text = UserData[0].HolderName;
          ACCOUNTNUMBERController.text = UserData[0].AccountNo;
        }
      }
    }
  }
  //----------------------
  Future<void> SaveDataOnServer() async {
    int action = 26;
    if(UserID == null || UserID == 0){
      action = 26;
    }else{
      action = 27;
    }
    prefs = await SharedPreferences.getInstance();
      setState(() {
        ServerMessage = "Profile update in progress...";
      });
      var body = {
        "ACTION": action,
        "ROWNO": 0,
        "GROUPID": UserID,
        "UNAME": TEXTUSERNAME,
        "EMAIL": TEXTEMAIL,
        "PASSWORD": TEXTPASSWORD,
        "CONTACTNO": TEXTCONTACTNO,
        "COUNTRY": TEXTCOUNTRY,
        "STATE": TEXTSTATE,
        "CITY": TEXTCITY,
        "BANKNAME": TEXTBANKNAME,
        "IFSCCODE": TEXTIFSCCODE,
        "HOLDERNAME": TEXTHOLDERNAME,
        "ACCOUNTNO": TEXTACCOUNTNUMBER,
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
      if (response.statusCode == 200) {
        print("--------------------Save server response : ${response.body}");
        List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          ServerRespons =
              jsonData.map((data) => DataResponseModel.fromJson(data)).toList();
          ServerMessage = ServerRespons[0].Response;
        });
        if((ServerRespons[0].Response == "Successfully Submited" ||
            ServerRespons[0].Response == "Successfully updated") && action == 26) {
          UserID = int.parse(ServerRespons[0].Code);
          prefs.setInt('Userid', UserID);
        }
        print("----------->>>>>>>>>>>>>>>>>>>>>>>>>>>---------TEXTUSERNAME : ${TEXTUSERNAME}");
        prefs.setString('UserName', TEXTUSERNAME);

        print("--------------------sub group : ${jsonData}");

        Future.delayed(Duration(seconds: 4), () {
          // setState(() {
          //   ServerMessage = "Submite";
          //   TEXTURL = '';
          //   // SelectedGrpName = MainGroupDataModel(GroupID: "0",
          //   //     GroupName: "Select Group");
          //   // SelectedSubGrpName = SubGroupDataModel(SubGrpID: "0",
          //   //     SubGrpName: "Select Title");
          // });
          ServerRespons = [];
        });
      }
      //-------
  }

  //------------------------
  @override
  void dispose() {
    //SubTitleController.dispose();
    //super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        backgroundColor: Color.fromRGBO(117, 254, 250, 51),
      ),
      body: RefreshIndicator(
        onRefresh: fetchProfile,
        child: Container(
          color: Colors.grey,
          child: SafeArea(
            child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                            child: TextFormField(
                              controller: USERNAMEController,
                              // onChanged: (value) {
                              //   setState(() {
                              //     TEXTUSERNAME = value;
                              //   });
                              //   print("-------------**************** TEXTUSERNAME : ${TEXTUSERNAME}");
                              // },
                              decoration: InputDecoration(
                                hintText: 'Your name',
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
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: TextFormField(
                              controller: EMAILController,
                              // onChanged: (value) {
                              //   SubTitle = SubTitleController.text;
                              // },
                              decoration: InputDecoration(
                                hintText: 'Email id',
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
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: TextFormField(
                              controller: PASSWORDController,
                              // onChanged: (value) {
                              //   SubTitle = SubTitleController.text;
                              // },
                              decoration: InputDecoration(
                                hintText: 'Password',
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
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: TextFormField(
                              controller: CONTACTNOController,
                              // onChanged: (value) {
                              //   SubTitle = SubTitleController.text;
                              // },
                              decoration: InputDecoration(
                                hintText: 'Contact No. (optional)',
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
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: TextFormField(
                              controller: COUNTRYController,
                              // onChanged: (value) {
                              //   SubTitle = SubTitleController.text;
                              // },
                              decoration: InputDecoration(
                                hintText: 'Country (optional)',
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
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: TextFormField(
                              controller: STATEController,
                              // onChanged: (value) {
                              //   SubTitle = SubTitleController.text;
                              // },
                              decoration: InputDecoration(
                                hintText: 'State (optional)',
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
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: TextFormField(
                              controller: CITYController,
                              // onChanged: (value) {
                              //   SubTitle = SubTitleController.text;
                              // },
                              decoration: InputDecoration(
                                hintText: 'City (optional)',
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
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: TextFormField(
                              controller: BANKNAMEController,
                              // onChanged: (value) {
                              //   SubTitle = SubTitleController.text;
                              // },
                              decoration: InputDecoration(
                                hintText: 'Bank Name (optional)',
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
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: TextFormField(
                              controller: IFSCCODEController,
                              // onChanged: (value) {
                              //   SubTitle = SubTitleController.text;
                              // },
                              decoration: InputDecoration(
                                hintText: 'IFSC Code (optional)',
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
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: TextFormField(
                              controller: HOLDERNAMEController,
                              // onChanged: (value) {
                              //   SubTitle = SubTitleController.text;
                              // },
                              decoration: InputDecoration(
                                hintText: 'Holder Name (optional)',
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
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: TextFormField(
                              controller: ACCOUNTNUMBERController,
                              // onChanged: (value) {
                              //   SubTitle = SubTitleController.text;
                              // },
                              decoration: InputDecoration(
                                hintText: 'Account No. (optional)',
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  //-----------------------------BUTTON
                  SliverToBoxAdapter(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              height: DH * 0.05,
                              margin: EdgeInsets.fromLTRB(30, 15, 30, 30),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                    if(TEXTUSERNAME.length > 5 && TEXTEMAIL.length > 7 &&
                                        TEXTPASSWORD.length>5) {
                                      SaveDataOnServer();
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Complete necessary info....')));
                                    }
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
        ),
      ),
    );
  }

//-----------------------
//------------------------------------------
} //CreateSList
// Future<void> fetchProfile() {
// }
