import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:selfstudy/shorts/shorts_list.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:selfstudy/module/data_module.dart';
import 'package:selfstudy/read/pdf_viewer.dart';
import 'package:selfstudy/image_viewer/image_view_zoom.dart';

import '../app_config.dart';
import '../module/carousel_model.dart';
import '../module/group_model.dart';


// final List<String> VideoUrl = <String>[
//   'https://sewabhartidabra.in/Self_Study/GK/Video/Gk2.mp4',
//   'https://sewabhartidabra.in/Self_Study/GK/Video/Gk3.mp4',
//   'https://sewabhartidabra.in/Self_Study/GK/Video/Gk4.mp4'];

class ShortsType extends StatefulWidget {

  const ShortsType({super.key});

  @override
  State<ShortsType> createState() => CreateSList();
}
class CreateSList extends State<ShortsType>{
  List<CarouselDataModel> CaroUselData2 = [];
  List<GroupDataModel> GroupName = [];
  //----------Prelims----------GS-1
  // List<VideoDataModel> GKPdfList = [];        //GID=1
  // List<VideoDataModel> HistoryPdfList = [];        //GID=2
  // List<VideoDataModel> NationalMovementPdfList = [];        //GID=3
  // List<VideoDataModel> GeographyPdfList = [];        //GID=4
  // List<VideoDataModel> IndianPolityGovernancePdfList = [];        //GID=5
  // List<VideoDataModel> EconomicSocialDevpPdfList = [];        //GID=6
  // List<VideoDataModel> EnvironmentEcologyPdfList = [];        //GID=7
  // List<VideoDataModel> ScienceTechnologyPdfList = [];        //GID=8
  //----------Prelims----------GS-2
  // List<VideoDataModel> ComprehensionPdfList = [];        //GID=9
  // List<VideoDataModel> InterpersonalSkillsPdfList = [];        //GID=10
  // List<VideoDataModel> LogicalReasoningPdfList = [];        //GID=11
  // List<VideoDataModel> DecisionMakingPdfList = [];        //GID=12
  // List<VideoDataModel> GMentalAbilityPdfList = [];        //GID=13
  // List<VideoDataModel> BasicNumeracyPdfList = [];       //Mathematic //GID=14
  // List<VideoDataModel> DataInterpretationPdfList = [];        //GID=15
  // List<VideoDataModel> EnglishLanguagePdfList = [];        //GID=16
  // List<VideoDataModel> ComputerKnowledgePdfList = [];        //GID=17
  //----------Main----------GSP-1
  //----------Main----------GSP-2
  //----------Main----------GSP-3
  //----------Main----------GSP-4

  late ScrollController LVcontroller;
  late int VDResponseCode = 200;
  int StartRowNo = 0;
  var pixelRatio = window.devicePixelRatio;
  String MyV1 = "Sunil";

  //Size in physical pixels
  var physicalScreenSize = window.physicalSize;
  // var physicalWidth = physicalScreenSize.width;
  // var physicalHeight = physicalScreenSize.height;

  FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
  // Size size = view.physicalSize;
  // double width = size.width;
  // double height = size.height;

  @override
  void initState() {
    super.initState();
    LVcontroller = ScrollController()..addListener(handleScrolling);
    fetchProducts();
  }
  void handleScrolling() {
    print("-----------<<<<<<<<<<<<<<< StartRowNo ${StartRowNo}");
    if (LVcontroller.offset >= LVcontroller.position.maxScrollExtent) {
      setState(() {
        StartRowNo += 3;
      });
      print("-----------<<<<<<<<<<<<<<< StartRowNo ${StartRowNo}");
    }
  }
  Future<void> fetchProducts() async {
    //---------------------Carousel
    var body = {
      "ACTION": "0",
      "ROWNO": 0,
      "GROUPID": 0,
      "PAGE": "1"
    };
    var jsonBody = json.encode(body);

    // you can replace your api link with this link
    var response = await
    http.post(Uri.parse(AppConfig.BASE_API_URL+'Fetch_SelfStudy.php'),
        body: jsonBody,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }
    );
    print("-----------------------------------------------------------------------------------------------------------");
    print(">>>>>>>>>>>>>>>>>Carousel Data : ${response}");
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        CaroUselData2 = jsonData.map((data) => CarouselDataModel.fromJson(data)).toList();
        print(">>>>>>>>>>>>>>>>>Carousel Data------------------------CaroUselData----------------- : ${CaroUselData2[1].ImgUrl}");
      });
    }
    else {
      CarouselDataModel CDM = new CarouselDataModel(id: 0,
          title: "",
          Subtitle: "",
          ImgUrl: AppConfig.CAROUSE_URL + 'India_EtoW_NtoS_Length.jpg',
          GroupName: '',
          GroupID: "0",
          SubGroupID: "0",
          Approve: "1",
          Page: "0", ImgDeco: 0, UserID: 0);
      CaroUselData2.add(CDM);
      CDM = new CarouselDataModel(id: 0,
          title: "",
          Subtitle: "",
          ImgUrl: AppConfig.CAROUSE_URL + 'ArabSagarMeMilneBaliNadiyan.jpg',
          GroupName: '',
          GroupID: "0",
          SubGroupID: "0",
          Approve: "1",
          Page: "0", ImgDeco: 0, UserID: 0);
      CaroUselData2.add(CDM);
      CDM = new CarouselDataModel(id: 0,
          title: "",
          Subtitle: "",
          ImgUrl: AppConfig.CAROUSE_URL + 'ArabSagarMeMilneBaliNadiyan.jpg',
          GroupName: '',
          GroupID: "0",
          SubGroupID: "0",
          Approve: "1",
          Page: "0", ImgDeco: 0, UserID: 0);
      CaroUselData2.add(CDM);
    }
    //-------------------------------Fetch Main Group
    body = {
      "ACTION": "4",
      "ROWNO": 0,
      "GROUPID": "0" //widget.GroupID,
    };
    jsonBody = json.encode(body);

    // you can replace your api link with this link
    response = await
    http.post(Uri.parse(AppConfig.BASE_API_URL+'Fetch_SelfStudy.php'),
        body: jsonBody,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }
    );
    if (response.statusCode == 200) {
      print("--------------------response  ????????????????????? : ${response
          .body}");
      List<dynamic> jsonData = json.decode(response.body);
      print("--------------------jsonData : ${jsonData}");
      setState(() {
        GroupName =
            jsonData.map((data) => GroupDataModel.fromJson(data)).toList();
      });
      VDResponseCode = 200;
    } else {
      // Handle error if needed
      VDResponseCode = 1;
    }
    //-------------------------------
    // if (VDResponseCode == 200) {
    //   int j = 0;
    //   for (j = 0; j < GroupName.length; j++) {
    //     body = {
    //       "ACTION": "60",
    //       "ROWNO": StartRowNo,
    //       "GROUPID": GroupName[j].GroupID, //widget.GroupID,
    //     };
    //     jsonBody = json.encode(body);
    //
    //     // you can replace your api link with this link
    //     response = await
    //     http.post(
    //         Uri.parse('https://sewabhartidabra.in/APIs/Fetch_SelfStudy.php'),
    //         body: jsonBody,
    //         headers: {
    //           'Accept': 'application/json',
    //           'Content-Type': 'application/json',
    //         }
    //     );
    //     if (response.statusCode == 200) {
    //       List<dynamic> jsonData = json.decode(response.body);
    //       if (GroupName[j].GroupID == "1") {
    //         setState(() {
    //           GKPdfList =
    //               jsonData.map((data) => VideoDataModel.fromJson(data))
    //                   .toList();
    //         });
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "2"){
    //         setState(() {
    //           HistoryPdfList =
    //               jsonData.map((data) => VideoDataModel.fromJson(data))
    //                   .toList();
    //         });
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "3"){
    //         setState(() {
    //           NationalMovementPdfList =
    //               jsonData.map((data) => VideoDataModel.fromJson(data))
    //                   .toList();
    //         });
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "4"){
    //         setState(() {
    //           GeographyPdfList =
    //               jsonData.map((data) => VideoDataModel.fromJson(data))
    //                   .toList();
    //         });
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "5"){
    //         setState(() {
    //           IndianPolityGovernancePdfList =
    //               jsonData.map((data) => VideoDataModel.fromJson(data))
    //                   .toList();
    //         });
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "6"){
    //         EconomicSocialDevpPdfList =
    //             jsonData.map((data) => VideoDataModel.fromJson(data))
    //                 .toList();
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "7"){
    //         EnvironmentEcologyPdfList =
    //             jsonData.map((data) => VideoDataModel.fromJson(data))
    //                 .toList();
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "8"){
    //         ScienceTechnologyPdfList =
    //             jsonData.map((data) => VideoDataModel.fromJson(data))
    //                 .toList();
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "9"){
    //         ComprehensionPdfList =
    //             jsonData.map((data) => VideoDataModel.fromJson(data))
    //                 .toList();
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "10"){
    //         InterpersonalSkillsPdfList =
    //             jsonData.map((data) => VideoDataModel.fromJson(data))
    //                 .toList();
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "11"){
    //         LogicalReasoningPdfList =
    //             jsonData.map((data) => VideoDataModel.fromJson(data))
    //                 .toList();
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "12"){
    //         DecisionMakingPdfList =
    //             jsonData.map((data) => VideoDataModel.fromJson(data))
    //                 .toList();
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "13"){
    //         GMentalAbilityPdfList =
    //             jsonData.map((data) => VideoDataModel.fromJson(data))
    //                 .toList();
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "14"){
    //         BasicNumeracyPdfList =
    //             jsonData.map((data) => VideoDataModel.fromJson(data))
    //                 .toList();
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "15"){
    //         DataInterpretationPdfList =
    //             jsonData.map((data) => VideoDataModel.fromJson(data))
    //                 .toList();
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "16"){
    //         EnglishLanguagePdfList =
    //             jsonData.map((data) => VideoDataModel.fromJson(data))
    //                 .toList();
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //       if (GroupName[j].GroupID == "17"){
    //         ComputerKnowledgePdfList =
    //             jsonData.map((data) => VideoDataModel.fromJson(data))
    //                 .toList();
    //         print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
    //             .Group} : ${jsonData}");
    //       }
    //
    //       VDResponseCode = 1;
    //     } else {
    //       // Handle error if needed
    //     }
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchProducts,
        child: Container(
        width: DW,
        height: DH,
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
                        alignment: Alignment.center,
                        height: 200,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: CarouselSlider(
                          items: CaroUselData2.map((fileImage) {
                            int index = CaroUselData2.indexOf(fileImage);
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  margin: EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    child: Container(
                                      margin: EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image: NetworkImage(fileImage.ImgUrl),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                              Image_View_Zoom(CaroUselData: CaroUselData2,
                                                  ShowFirst: index.toDouble(),
                                                  context: context)));
                                    },
                                  ),
                                );
                              },
                            );
                          }).toList(),

                          //Slider Container properties
                          options: CarouselOptions(
                            height: 200.0,
                            //enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration: Duration(milliseconds: 800),
                            viewportFraction: 0.8,
                          ),
                        ),
                      ),
                    ]
                ),
              ),
              //--------------------------------------Group
              SliverToBoxAdapter(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 10, 0, 5),
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 130.0,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  childAspectRatio: 0.6,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 140,
                              height: DH * 0.3,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ShortsList(clientName: GroupName[index].Group,
                                              GroupID: int.parse(GroupName[index].GroupID),
                                              Action: 5,
                                              context: context)));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      child: Image.network(GroupName[index].ImgUrl),
                                    ),
                                    Container(
                                      child: Text(GroupName[index].Group,
                                        style: TextStyle(fontSize: 14),),
                                    )
                                  ],
                                )
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: GroupName.length,
                ),
              ),



              //--------------------------------------

            ],
          ),
        ),
      ),
      ),
    );
  }

} //CreateSList