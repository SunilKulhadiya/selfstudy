import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

import '../app_config.dart';
import 'package:selfstudy/shorts/video_player.dart';
import 'package:selfstudy/module/main_group_model.dart';



class UploadShorts extends StatefulWidget {

  const UploadShorts({super.key});

  @override
  State<UploadShorts> createState() => CreateSList();
}
class CreateSList extends State<UploadShorts>{
  List<MainGroupDataModel> MainGroups = [];
  File? galleryFile;
  final picker = ImagePicker();

  var SubTitle = "";
  final SubTitleController = TextEditingController();

  void _nameChanged() {
    SubTitle = SubTitleController.text;
    print(
        "text controller changed to '${SubTitleController.text}' ($SubTitle)");
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    SubTitleController.addListener(_nameChanged);
  }
  Future<void> fetchProducts() async {
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
    if (response.statusCode == 200) {
      print("--------------------Home : ${response.body}");
      List<dynamic> jsonData = json.decode(response.body);
      print("--------------------Home : ${jsonData}");
      setState(() {
        MainGroups =
            jsonData.map((data) => MainGroupDataModel.fromJson(data)).toList();
      });
    } else {}
  }

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
              child: MyVideoPlayer(VideoUrl: galleryFile, context: context),
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
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(10, 45, 10, 5),
                    child: TextFormField(
                            controller: SubTitleController,
                            // onChanged: (value) {
                            //   SubTitle = SubTitleController.text;
                            // },
                            decoration: InputDecoration(
                              hintText: 'Sub Title',
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
                    margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                    child: TextFormField(
                      controller: SubTitleController,
                      // onChanged: (value) {
                      //   SubTitle = SubTitleController.text;
                      // },
                      decoration: InputDecoration(
                        hintText: 'Sub Title',
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
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    child: TextFormField(
                      controller: SubTitleController,
                      // onChanged: (value) {
                      //   SubTitle = SubTitleController.text;
                      // },
                      decoration: InputDecoration(
                        hintText: 'Sub Title',
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
                    margin: EdgeInsets.fromLTRB(30, 70, 30, 30),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GestureDetector(
                      onTap: (){

                      },
                      child: Text('Submit',
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
    final pickedFile = await picker.pickVideo(
        source: img,
        preferredCameraDevice: CameraDevice.front,
        maxDuration: const Duration(minutes: 1));
    XFile? xfilePick = pickedFile;
    setState(
          () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
          print("--------------------------------------------------------------------------");
          print(galleryFile);

        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
//--------------------------------
//   CDropdownButton(BuildContext context) {
//     print("/////------------------------------------      CDropdownButton --------------->>>>>>>>>>>>>>********************** ${SelectedSbuTitle.SubTitle}");
//
//     final double DW = MediaQuery.of(context).size.width;
//
//     if(drp1 == 0){
//       return Container(
//         width: DW * 0.692,
//         alignment: Alignment.centerLeft,
//         margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
//         child: DropdownButton<SubTitleDataModel>(
//           icon: Icon(Icons.filter_alt_sharp, color: Color.fromRGBO(1, 1, 1, 51),),
//           iconSize: 24,
//           elevation: 16,
//           isExpanded: false,
//           isDense: false,
//           alignment: Alignment.centerLeft,
//           style: TextStyle(color: Colors.deepPurple),
//           hint: Container(
//             width: DW * 0.4,
//             child: new Text('Select you like', textAlign: TextAlign.start,
//               style: TextStyle(fontFamily: "Gotham"),
//             ),
//           ),
//           onChanged: (newValue) {
//             setState(() {
//               SelectedSbuTitle = newValue!;
//               drp1 = 1;
//             });
//             if(SelectedTeacher.Author == "Select Teacher") {
//               if(SelectedSbuTitle.SubTitle == 'Select you like'){
//                 fetchProducts(Action: 5,
//                     StartRN: StartRowNo,
//                     GrpID: widget.GroupID,
//                     SubT: "",
//                     Auth: "");
//               }else{
//                 fetchProducts(Action: 51,
//                     StartRN: StartRowNo,
//                     GrpID: widget.GroupID,
//                     SubT: newValue!.SubTitle,
//                     Auth: "");
//               }
//             }else{
//               fetchProducts(Action: 5152,
//                   StartRN: StartRowNo,
//                   GrpID: widget.GroupID,
//                   SubT: newValue!.SubTitle,
//                   Auth: SelectedSbuTitle.SubTitle);
//             }
//           },
//           //value: SelectedSbuTitle,
//
//           items:
//           VSubTitle.map<DropdownMenuItem<SubTitleDataModel>>((SubTitleDataModel Vvalue) {
//             return DropdownMenuItem<SubTitleDataModel>(
//               value: Vvalue,
//               child: Container(
//                 alignment: Alignment.centerLeft,
//                 child: new Text(
//                   Vvalue.SubTitle, textAlign: TextAlign.start,
//                   style: TextStyle(fontFamily: "Gotham"),
//
//                 ),
//               ),
//
//             );
//           }).toList(),
//
//         ),
//       );
//
//     }else{
//       return Container(
//         width: DW * 0.692,
//         alignment: Alignment.centerLeft,
//         margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
//         child: DropdownButton<SubTitleDataModel>(
//           icon: Icon(Icons.filter_alt_sharp, color: Color.fromRGBO(1, 1, 1, 51),),
//           iconSize: 24,
//           elevation: 16,
//           isExpanded: false,
//           isDense: false,
//           alignment: Alignment.centerLeft,
//           style: TextStyle(color: Colors.deepPurple),
//           hint: Container(
//             width: DW * 0.4,
//             child: new Text('Select you like', textAlign: TextAlign.start,
//               style: TextStyle(fontFamily: "Gotham"),
//             ),
//           ),
//           onChanged: (newValue) {
//             if(SelectedTeacher.Author == "Select Teacher") {
//               if(SelectedSbuTitle.SubTitle == 'Select you like'){
//                 fetchProducts(Action: 5,
//                     StartRN: StartRowNo,
//                     GrpID: widget.GroupID,
//                     SubT: "",
//                     Auth: "");
//               }else{
//                 fetchProducts(Action: 51,
//                     StartRN: StartRowNo,
//                     GrpID: widget.GroupID,
//                     SubT: newValue!.SubTitle,
//                     Auth: "");
//               }
//             }else{
//               fetchProducts(Action: 5152,
//                   StartRN: StartRowNo,
//                   GrpID: widget.GroupID,
//                   SubT: newValue!.SubTitle,
//                   Auth: SelectedSbuTitle.SubTitle);
//             }
//             setState(() {
//               SelectedSbuTitle = newValue!;
//               drp1 = 1;
//             });
//           },
//           value: SelectedSbuTitle,
//
//           items:
//           VSubTitle.map<DropdownMenuItem<SubTitleDataModel>>((SubTitleDataModel Vvalue) {
//             return DropdownMenuItem<SubTitleDataModel>(
//               value: Vvalue,
//               child: Container(
//                 alignment: Alignment.centerLeft,
//                 child: new Text(
//                   Vvalue.SubTitle, textAlign: TextAlign.start,
//                   style: TextStyle(fontFamily: "Gotham"),
//
//                 ),
//               ),
//
//             );
//           }).toList(),
//         ),
//       );
//
//     }
//
//
//   }



//------------------------------------------
} //CreateSList