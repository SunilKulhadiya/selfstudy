import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';
import 'package:selfstudy/shorts/video_player.dart';
import 'package:selfstudy/module/main_group_model.dart';
import 'package:selfstudy/module/subgrp_model.dart';
import 'package:selfstudy/module/server_response_model.dart';



class UploadShorts extends StatefulWidget {

  const UploadShorts({super.key});

  @override
  State<UploadShorts> createState() => CreateSList();
}
class CreateSList extends State<UploadShorts> with TickerProviderStateMixin{
  late SharedPreferences prefs;
  int UserID = 0;
  late AnimationController Progresscontroller;
  List<MainGroupDataModel> MainGroups = [];
  List<SubGroupDataModel> SubGroups = [];
  List<ServerResponseModel> ServerRespons = [];

  File? galleryFile = null;
  final picker = ImagePicker();

  int GrpDWBTN = 0, SubGrpDWBTN = 0, isUploading = 0;
  late MainGroupDataModel SelectedGrpName = MainGroupDataModel(GroupID: "0",
      GroupName: "Select Group");
  late SubGroupDataModel SelectedSubGrpName = SubGroupDataModel(SubGrpID: "0",
      SubGrpName: "Select Title");

  DateFormat dateFormat = DateFormat("ddMMyyyy_HHmmss");
  String ServerMessage = 'Submit';
  final URLController = TextEditingController();
  var TEXTGrpName = "";
  final GrpNameController = TextEditingController();
  var TEXTSubGrpTitle = "";
  final SubTitleController = TextEditingController();

  void GrpNameChanged() {
    TEXTGrpName = GrpNameController.text;
  }
  void SubGrpTitleChanged() {
    TEXTSubGrpTitle = SubTitleController.text;
  }

  @override
  void initState() {
    super.initState();
    GrpDWBTN = 0;
    SubGrpDWBTN = 0;
    fetchGroups();
    GrpNameController.addListener(GrpNameChanged);
    SubTitleController.addListener(SubGrpTitleChanged);
    //SubmitProgressIndicator(0);
  }
  Future<void> fetchGroups() async {
    prefs = await SharedPreferences.getInstance();
    UserID = prefs.getInt('Userid')!;
    var body = {
      "ACTION": "9",
      "ROWNO": 0,
      "GROUPID": "0",
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
    setState(() {
      MainGroups.add(SelectedGrpName);
    });
    if (response.statusCode == 200) {
      print("--------------------Home : ${response.body}");
      List<dynamic> jsonData = json.decode(response.body);
      print("--------------------Home : ${jsonData}");
      for(var h in jsonData) {
        print("--------------------***************************************** h : ${h}");
        MainGroupDataModel subTitle = new MainGroupDataModel(GroupID: h['group_id'],
            GroupName: h['group_name']);
        setState(() {
          MainGroups.add(subTitle);
        });
      }
      MainGroupDataModel other = MainGroupDataModel(GroupID: "0",
          GroupName: "Other");
      setState(() {
        MainGroups.add(other);
      });
    } else {
      MainGroupDataModel other = MainGroupDataModel(GroupID: "0",
          GroupName: "Other");
      setState(() {
        MainGroups.add(other);
      });
    }
  }
  Future<void> fetchSubGroups() async {
    print("--------------------sub group, group : ${SelectedGrpName.GroupName} ${SelectedGrpName.GroupID}");
    SubGroups = [];
    var body = {
      "ACTION": "10",
      "ROWNO": 0,
      "GROUPID": SelectedGrpName.GroupID,
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
    setState(() {
      SubGroups.add(SelectedSubGrpName);
    });
    if (response.statusCode == 200) {
      print("--------------------sub group : ${response.body}");
      List<dynamic> jsonData = json.decode(response.body);
      print("--------------------sub group : ${jsonData}");
      for(var h in jsonData) {
        print("--------------------***************************************** h : ${h}");
        SubGroupDataModel subTitle = new SubGroupDataModel(SubGrpID: h['id'],
            SubGrpName: h['sub_group']);
        setState(() {
          SubGroups.add(subTitle);
        });
      }
      SubGroupDataModel other = SubGroupDataModel(SubGrpID: "0",
          SubGrpName: "Other");
      setState(() {
        SubGroups.add(other);
      });
    } else {
      SubGroupDataModel other = SubGroupDataModel(SubGrpID: "0",
          SubGrpName: "Other");
      setState(() {
        SubGroups.add(other);
      });
    }
    //----
  }
  //----------------------
  Future<void> SubmitProgressIndicator(int duration)async {
    if(duration == 0) {
      Progresscontroller = AnimationController(
        /// [AnimationController]s can be created with `vsync: this` because of
        /// [TickerProviderStateMixin].
        vsync: this,
        duration: null,
      )
        ..addListener(() {
          setState(() {});
        });
      Progresscontroller.repeat(reverse: false);
    }else{
      Progresscontroller = AnimationController(
        /// [AnimationController]s can be created with `vsync: this` because of
        /// [TickerProviderStateMixin].
        vsync: this,
        duration: Duration(seconds: 25),
      )
        ..addListener(() {
          setState(() {});
        });
      Progresscontroller.repeat(reverse: false);
    }

  }
  //----------------------
  Future<void> SaveDataOnServer(File URL, String GrpNme,
      String SubGrpNme) async {
    setState(() {
      ServerMessage = "Uploading in progress......";
      isUploading = 1;
    });
    //SubmitProgressIndicator(1);
    String formattedDate = dateFormat.format(DateTime.now());
    String Ext = URL!.path;
    Ext = Ext.substring(Ext.lastIndexOf(".")+1, Ext.length);
    String NewFileName = "G"+SelectedGrpName.GroupID+"SG"+SelectedSubGrpName.SubGrpID+"_"+formattedDate+"."+Ext;
    final request = http.MultipartRequest('POST', Uri.parse(AppConfig.BASE_API_URL + 'Upload_Shorts.php'))
      ..fields['NEWFILENAME'] = NewFileName
      ..files.add(await http.MultipartFile.fromPath('myFile', URL!.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      print("33333333333333333333333333>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Data ${responseData}");
      final responseString = String.fromCharCodes(responseData);
      print("33333333333333333333333333>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> String ${responseString}");
      final jasonMap = jsonDecode(responseString);
      List<dynamic> jsonData = json.decode(responseString);
      ServerRespons =
          jsonData.map((data) => ServerResponseModel.fromJson(data)).toList();
      print("33333333333333333333333333>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Map ${ServerRespons[0].Response}");
      print("33333333333333333333333333>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Map ${ServerRespons[0].Code}");
      if(ServerRespons[0].Code == "200"){
        var body = {
          "ACTION": "11",
          "ROWNO": 0,
          "USERID": UserID,
          "GROUPID": SelectedGrpName.GroupID,
          "GROUPNAME": GrpNme,
          "SUBGROUPID": SelectedSubGrpName.SubGrpID,
          "SUBGROUPNAME": SubGrpNme,
          "IMGURL": AppConfig.BASE_URL_PACKAGE+"Shorts/"+NewFileName,
          "SELECTEDGROUP": SelectedGrpName.GroupName,
          "SELECTEDSUBGROUP": SelectedSubGrpName.SubGrpName
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
          print("--------------------SQL -------------------- server response : ${response.body}");
          List<dynamic> jsonData1 = json.decode(response.body);
          setState(() {
            ServerRespons =
                jsonData1.map((data) => ServerResponseModel.fromJson(data))
                    .toList();
            ServerMessage = ServerRespons[0].Response;
            ServerRespons = [];
            isUploading = 0;
            //SubmitProgressIndicator(0);
          });

          print("--------------------sub group : ${jsonData1[0].rsponse}");

          Future.delayed(Duration(seconds: 7), () {
            setState(() {
              ServerMessage = "Submite";
            });
          });
        }else{
          setState(() {
            ServerMessage = "Try again, something went wrong.";
          });
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              ServerMessage = "Submite";
            });
          });

        }
      }
    }
    //-------
  }
  //------------------------
  @override
  void dispose() {
    SubTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
        color: Colors.grey,
        child: SafeArea(
        child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text("Short",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22,
              color: Color.fromRGBO(189, 183, 8, 8)),),
              ),
          ),
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: GestureDetector(
              onTap: (){
              _showPicker(context: context);
              },
              child: Column(
              children: [
              Container(
                child: galleryFile == null ?
                Icon(Icons.video_camera_back_outlined, size: 200,) :
                Container(
                  width: DW * 0.4,
                  height: DW * 0.4,
                  alignment: Alignment.center,
                  child: galleryFile == null ? Icon(Icons.video_camera_back_outlined, size: 200,) :
                    MyVideoPlayer(VideoUrl: galleryFile, context: context),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Text("Touch me", style:
                TextStyle(fontSize: galleryFile == null ? 15 : 25,
                fontWeight: galleryFile == null ? FontWeight.normal : FontWeight.bold),),
              ),
            ]
              ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    width: DW * 0.97,
                    margin: EdgeInsets.fromLTRB(10, 25, 0, 5),
                    child: GrpDropdownButton(context),
                  ),
                ]
            ),
          ),

          SliverToBoxAdapter(
            child: SelectedGrpName.GroupName != 'Other' ? null : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                    child: TextFormField(
                      controller: GrpNameController,
                      // onChanged: (value) {
                      //   SubTitle = SubTitleController.text;
                      // },
                      decoration: InputDecoration(
                        hintText: 'Group',
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
                    width: DW * 0.97,
                    margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                    child: SubGrpDropdownButton(context),
                  ),
                ]
            ),
          ),

          SliverToBoxAdapter(
            child: SelectedSubGrpName.SubGrpName != 'Other' ? null : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    child: TextFormField(
                      controller: SubTitleController,
                      // onChanged: (value) {
                      //   SubTitle = SubTitleController.text;
                      // },
                      decoration: InputDecoration(
                        hintText: 'Title',
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
                      alignment: Alignment.center,
                      height: DH * 0.05,
                      margin: EdgeInsets.fromLTRB(30, 100, 30, 30),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: GestureDetector(
                        onTap: (){
                          print("-------------------------------------Submit");
                          if(SelectedGrpName.GroupName == 'Select Group' ||
                              SelectedSubGrpName.SubGrpName == 'Select Title' ||
                              galleryFile == null){
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('All fields are required.....')));
                          }else{
                            if(SelectedGrpName.GroupName != 'Other'){
                              TEXTGrpName = SelectedGrpName.GroupName;
                            }
                            if(SelectedSubGrpName.SubGrpName != 'Other'){
                              TEXTSubGrpTitle = SelectedSubGrpName.SubGrpName;
                            }
                            if(galleryFile == null){
                              ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
                                  const SnackBar(content: Text('Please select file or sync in progress...')));
                            }else {
                              SaveDataOnServer(
                                  galleryFile!, TEXTGrpName, TEXTSubGrpTitle);
                            }
                          }
                        },
                        child: Text(ServerMessage,
                            style: TextStyle(fontSize: 22,
                                color: Colors.white)),
                      )
                  ),
                ]
            ),
          ),


        ]
      ),
    ),
    ),
    );
  }


  void _showPicker({required BuildContext context,}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  getVideo(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getVideo(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getVideo(ImageSource img,) async {
    print("----------------------------galleryFile----------------------------------------------${galleryFile}");
    final pickedFile = await picker.pickVideo(
        source: img,
        preferredCameraDevice: CameraDevice.front,
        maxDuration: const Duration(minutes: 1)
    );
    XFile? xfilePick = pickedFile;
    setState(
          () {
        if (xfilePick != null) {
          if(galleryFile == null){
            setState(() {
              galleryFile = File(pickedFile!.path);
            });
          }else {
            setState(() {
              galleryFile = null;
            });
            print(
                "----------------------------galleryFile----------------------------------------------${galleryFile}");
            Future.delayed(Duration(seconds: 2), () {
              setState(() {
                galleryFile = File(pickedFile!.path);
              });
            });
          }
          print("----------------------------pickedFile!.path----------------------------------------------${pickedFile!.path}");
          print("----------------------------xfilePick----------------------------------------------${xfilePick.path}");
          print(galleryFile);

        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
//--------------------------------
  GrpDropdownButton(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    if(GrpDWBTN == 0){
      return Container(
        width: DW * 0.95,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: DropdownButton<MainGroupDataModel>(
          icon: Icon(Icons.keyboard_arrow_down, color: Color.fromRGBO(1, 1, 1, 51),),
          iconSize: 33,
          elevation: 16,
          // isExpanded: false,
          // isDense: false,
          alignment: Alignment.centerLeft,
          style: TextStyle(color: Colors.deepPurple),
          hint: Container(
            width: DW * 0.8,
            child: new Text('Select Group', textAlign: TextAlign.start,
              style: TextStyle(fontFamily: "Gotham"),
            ),
          ),
          onChanged: (newValue) {
            setState(() {
              SelectedGrpName = newValue!;
              GrpDWBTN = 1;
            });
            fetchSubGroups();
          },
          //value: SelectedSbuTitle,

          items:
          MainGroups.map<DropdownMenuItem<MainGroupDataModel>>((MainGroupDataModel Vvalue) {
            return DropdownMenuItem<MainGroupDataModel>(
              value: Vvalue,
              child: Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  Vvalue.GroupName, textAlign: TextAlign.start,
                  style: TextStyle(fontFamily: "Gotham"),

                ),
              ),

            );
          }).toList(),

        ),
      );
    }else{
      return Container(
        width: DW * 0.95,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: DropdownButton<MainGroupDataModel>(
          icon: Icon(Icons.keyboard_arrow_down, color: Color.fromRGBO(1, 1, 1, 51),),
          iconSize: 33,
          elevation: 16,
          isExpanded: false,
          isDense: false,
          alignment: Alignment.centerLeft,
          style: TextStyle(color: Colors.black),
          hint: Container(
            width: DW * 0.8,
            child: new Text('Select Group', textAlign: TextAlign.start,
              style: TextStyle(fontFamily: "Gotham"),
            ),
          ),
          onChanged: (newValue) {
            setState(() {
              SelectedGrpName = newValue!;
              GrpDWBTN = 1;
            });
            print("RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
            fetchSubGroups();
          },
          value: SelectedGrpName,

          items:
          MainGroups.map<DropdownMenuItem<MainGroupDataModel>>((MainGroupDataModel Vvalue) {
            return DropdownMenuItem<MainGroupDataModel>(
              value: Vvalue,
              child: Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  Vvalue.GroupName, textAlign: TextAlign.start,
                  style: TextStyle(fontFamily: "Gotham"),

                ),
              ),

            );
          }).toList(),
        ),
      );

    }
  }
//--------------------------------
  SubGrpDropdownButton(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;

    if(SubGrpDWBTN == 0){
      return Container(
        width: DW * 0.95,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: DropdownButton<SubGroupDataModel>(
          icon: Icon(Icons.keyboard_arrow_down, color: Color.fromRGBO(1, 1, 1, 51),),
          iconSize: 33,
          elevation: 16,
          isExpanded: false,
          isDense: false,
          alignment: Alignment.centerLeft,
          style: TextStyle(color: Colors.deepPurple),
          hint: Container(
            width: DW * 0.8,
            child: new Text('Select Title', textAlign: TextAlign.start,
              style: TextStyle(fontFamily: "Gotham"),
            ),
          ),
          onChanged: (newValue) {
            setState(() {
              SelectedSubGrpName = newValue!;
              SubGrpDWBTN = 1;
            });
          },
          //value: SelectedSbuTitle,

          items:
          SubGroups.map<DropdownMenuItem<SubGroupDataModel>>((SubGroupDataModel Vvalue) {
            return DropdownMenuItem<SubGroupDataModel>(
              value: Vvalue,
              child: Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  Vvalue.SubGrpName, textAlign: TextAlign.start,
                  style: TextStyle(fontFamily: "Gotham"),

                ),
              ),

            );
          }).toList(),

        ),
      );

    }else{
      return Container(
        width: DW * 0.95,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: DropdownButton<SubGroupDataModel>(
          icon: Icon(Icons.keyboard_arrow_down, color: Color.fromRGBO(1, 1, 1, 51),),
          iconSize: 33,
          elevation: 16,
          isExpanded: false,
          isDense: false,
          alignment: Alignment.centerLeft,
          style: TextStyle(color: Colors.black),
          hint: Container(
            width: DW * 0.8,
            child: new Text('Select Title', textAlign: TextAlign.start,
              style: TextStyle(fontFamily: "Gotham"),
            ),
          ),
          onChanged: (newValue) {
            setState(() {
              SelectedSubGrpName = newValue!;
              SubGrpDWBTN = 1;
            });
          },
          value: SelectedSubGrpName,

          items:
          SubGroups.map<DropdownMenuItem<SubGroupDataModel>>((SubGroupDataModel Vvalue) {
            return DropdownMenuItem<SubGroupDataModel>(
              value: Vvalue,
              child: Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  Vvalue.SubGrpName, textAlign: TextAlign.start,
                  style: TextStyle(fontFamily: "Gotham"),

                ),
              ),

            );
          }).toList(),
        ),
      );

    }
  }
//-----------------------



//------------------------------------------
} //CreateSList