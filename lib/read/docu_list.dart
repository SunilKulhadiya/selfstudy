import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:selfstudy/module/data_module.dart';
import 'package:selfstudy/module/doc_group_model.dart';
import 'package:selfstudy/read/pdf_viewer.dart';
import 'package:selfstudy/image_viewer/image_view_zoom.dart';

import '../app_config.dart';
import '../module/carousel_model.dart';
import '../module/group_model.dart';


final List<String> VideoUrl = <String>[
  'https://sewabhartidabra.in/Self_Study/GK/Video/Gk2.mp4',
  'https://sewabhartidabra.in/Self_Study/GK/Video/Gk3.mp4',
  'https://sewabhartidabra.in/Self_Study/GK/Video/Gk4.mp4'];

class DocumentList extends StatefulWidget {

  const DocumentList({super.key});

  @override
  State<DocumentList> createState() => CreateSList();
}
class CreateSList extends State<DocumentList>{
  List<CarouselDataModel> CaroUselData = [];
  List<DocGroupDataModel> GroupName = [];
  //----------Prelims----------GS-1
  List<VideoDataModel> GKPdfList = [];        //GID=1
  List<VideoDataModel> HistoryPdfList = [];        //GID=2
  List<VideoDataModel> NationalMovementPdfList = [];        //GID=3
  List<VideoDataModel> GeographyPdfList = [];        //GID=4
  List<VideoDataModel> IndianPolityGovernancePdfList = [];        //GID=5
  List<VideoDataModel> EconomicSocialDevpPdfList = [];        //GID=6
  List<VideoDataModel> EnvironmentEcologyPdfList = [];        //GID=7
  List<VideoDataModel> ScienceTechnologyPdfList = [];        //GID=8
  //----------Prelims----------GS-2
  List<VideoDataModel> ComprehensionPdfList = [];        //GID=9
  List<VideoDataModel> InterpersonalSkillsPdfList = [];        //GID=10
  List<VideoDataModel> LogicalReasoningPdfList = [];        //GID=11
  List<VideoDataModel> DecisionMakingPdfList = [];        //GID=12
  List<VideoDataModel> GMentalAbilityPdfList = [];        //GID=13
  List<VideoDataModel> BasicNumeracyPdfList = [];       //Mathematic //GID=14
  List<VideoDataModel> DataInterpretationPdfList = [];        //GID=15
  List<VideoDataModel> EnglishLanguagePdfList = [];        //GID=16
  List<VideoDataModel> ComputerKnowledgePdfList = [];        //GID=17
  //----------Main----------GSP-1
  //----------Main----------GSP-2
  //----------Main----------GSP-3
  //----------Main----------GSP-4

  late ScrollController LVcontroller;
  late int VDResponseCode = 200;
  int StartRowNo = 0;
  var pixelRatio = window.devicePixelRatio;

  //Size in physical pixels
  var physicalScreenSize = window.physicalSize;

  FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

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
    //print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> GID : ${}");
    var body = {
      "ACTION": "0",
      "ROWNO": 0,
      "GROUPID": 0,
      "PAGE": 2
    };
    var jsonBody = json.encode(body);

    // you can replace your api link with this link
    var response = await
    http.post(Uri.parse(AppConfig.BASE_URL + 'Fetch_SelfStudy.php'),
        body: jsonBody,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }
    );
    if (response.statusCode == 200) {
      print(
          "--------------------Docu list--------------CaroUselData : ${response
              .body}");
      List<dynamic> jsonData = json.decode(response.body);
      print(
          "--------------------Docu list --------------------CaroUselData : ${jsonData}");
      setState(() {
        CaroUselData =
            jsonData.map((data) => CarouselDataModel.fromJson(data)).toList();
      });
    } else {
      CarouselDataModel CDM = new CarouselDataModel(id: 0,
          title: "",
          ImgUrl: AppConfig.CAROUSE_URL + 'India_EtoW_NtoS_Length.jpg',
          GroupName: '',
          GroupID: "0",
          Approve: "1",
          Page: "0");
      CaroUselData.add(CDM);
      CDM = new CarouselDataModel(id: 0,
          title: "",
          ImgUrl: AppConfig.CAROUSE_URL + 'ArabSagarMeMilneBaliNadiyan.jpg',
          GroupName: '',
          GroupID: "0",
          Approve: "1",
          Page: "0");
      CaroUselData.add(CDM);
      CDM = new CarouselDataModel(id: 0,
          title: "",
          ImgUrl: AppConfig.CAROUSE_URL + 'ArabSagarMeMilneBaliNadiyan.jpg',
          GroupName: '',
          GroupID: "0",
          Approve: "1",
          Page: "0");
      CaroUselData.add(CDM);
    }
    //-------------------------------
    body = {
      "ACTION": "6",
      "ROWNO": 0,
      "GROUPID": "0" //widget.GroupID,
    };
    jsonBody = json.encode(body);

    // you can replace your api link with this link
    response = await
    http.post(Uri.parse('https://sewabhartidabra.in/APIs/Fetch_SelfStudy.php'),
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
        GroupName = jsonData.map((data) => DocGroupDataModel.fromJson(data)).toList();
      });
      VDResponseCode = 200;
    } else {
      // Handle error if needed
      VDResponseCode = 1;
    }
    //-------------------------------
    if (VDResponseCode == 200) {
      int j = 0;
      for (j = 0; j < GroupName.length; j++) {
        body = {
          "ACTION": "60",
          "ROWNO": StartRowNo,
          "GROUPID": GroupName[j].GroupID, //widget.GroupID,
        };
        jsonBody = json.encode(body);

        // you can replace your api link with this link
        response = await
        http.post(
            Uri.parse('https://sewabhartidabra.in/APIs/Fetch_SelfStudy.php'),
            body: jsonBody,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            }
        );
        if (response.statusCode == 200) {
          List<dynamic> jsonData = json.decode(response.body);
            if (GroupName[j].GroupID == "1") {
              setState(() {
                GKPdfList =
                    jsonData.map((data) => VideoDataModel.fromJson(data))
                        .toList();
              });
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
            }
              if (GroupName[j].GroupID == "2"){
              setState(() {
                HistoryPdfList =
                    jsonData.map((data) => VideoDataModel.fromJson(data))
                        .toList();
              });
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
              }
            if (GroupName[j].GroupID == "3"){
              setState(() {
                NationalMovementPdfList =
                    jsonData.map((data) => VideoDataModel.fromJson(data))
                        .toList();
              });
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
            }
            if (GroupName[j].GroupID == "4"){
              setState(() {
                GeographyPdfList =
                    jsonData.map((data) => VideoDataModel.fromJson(data))
                        .toList();
              });
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
            }
            if (GroupName[j].GroupID == "5"){
              setState(() {
                IndianPolityGovernancePdfList =
                    jsonData.map((data) => VideoDataModel.fromJson(data))
                        .toList();
              });
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
            }
            if (GroupName[j].GroupID == "6"){
              EconomicSocialDevpPdfList =
                  jsonData.map((data) => VideoDataModel.fromJson(data))
                      .toList();
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
            }
            if (GroupName[j].GroupID == "7"){
              EnvironmentEcologyPdfList =
                  jsonData.map((data) => VideoDataModel.fromJson(data))
                      .toList();
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
            }
            if (GroupName[j].GroupID == "8"){
              ScienceTechnologyPdfList =
                  jsonData.map((data) => VideoDataModel.fromJson(data))
                      .toList();
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
            }
            if (GroupName[j].GroupID == "9"){
              ComprehensionPdfList =
                  jsonData.map((data) => VideoDataModel.fromJson(data))
                      .toList();
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
            }
            if (GroupName[j].GroupID == "10"){
              InterpersonalSkillsPdfList =
                  jsonData.map((data) => VideoDataModel.fromJson(data))
                      .toList();
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
            }
            if (GroupName[j].GroupID == "11"){
              LogicalReasoningPdfList =
                  jsonData.map((data) => VideoDataModel.fromJson(data))
                      .toList();
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
            }
            if (GroupName[j].GroupID == "12"){
              DecisionMakingPdfList =
                  jsonData.map((data) => VideoDataModel.fromJson(data))
                      .toList();
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
            }
            if (GroupName[j].GroupID == "13"){
              GMentalAbilityPdfList =
                  jsonData.map((data) => VideoDataModel.fromJson(data))
                      .toList();
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
            }
            if (GroupName[j].GroupID == "14"){
              BasicNumeracyPdfList =
                  jsonData.map((data) => VideoDataModel.fromJson(data))
                      .toList();
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
            }
            if (GroupName[j].GroupID == "15"){
              DataInterpretationPdfList =
                  jsonData.map((data) => VideoDataModel.fromJson(data))
                      .toList();
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
            }
            if (GroupName[j].GroupID == "16"){
              EnglishLanguagePdfList =
                  jsonData.map((data) => VideoDataModel.fromJson(data))
                      .toList();
              print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                  .Group} : ${jsonData}");
            }
          if (GroupName[j].GroupID == "17"){
            ComputerKnowledgePdfList =
                jsonData.map((data) => VideoDataModel.fromJson(data))
                    .toList();
            print("---->>>>>>>>>>>----------Data--for---${GroupName[j]
                .Group} : ${jsonData}");
          }

          VDResponseCode = 1;
        } else {
          // Handle error if needed
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchProducts,
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
                        alignment: Alignment.center,
                        height: 200,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: CarouselSlider(
                          items: CaroUselData.map((fileImage) {
                            int index = CaroUselData.indexOf(fileImage);
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
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                              Image_View_Zoom(CaroUselData: CaroUselData,
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
          //--------------------------------------GK-1
              SliverToBoxAdapter(
                child: GKPdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: GKPdfList.length > 0 ?
                        Text("General Knowledge", style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                                width: DW - 120,
                                height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                // margin: EdgeInsets.all(5),
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: GKPdfList[PDFindex].Url,
                                                PdfTitle: GKPdfList[PDFindex].SubTitle, context: context)));
                                  },

                                  child: Image.network(GKPdfList[PDFindex].ImgUrl),
                                ),
                            ),
                          ]
                      );
                  },
                  childCount: GKPdfList.length,
                ),
              ),
              //--------------------------------------History - 2
              SliverToBoxAdapter(
                child: HistoryPdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: HistoryPdfList.length > 0 ? Text("History", style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
                              height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyPDFViewer(PdfUrl: HistoryPdfList[PDFindex].Url,
                                              PdfTitle: HistoryPdfList[PDFindex].SubTitle,
                                              context: context)));
                                },
                                child: Image.network(HistoryPdfList[PDFindex].ImgUrl),
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: HistoryPdfList.length,
                ),
              ),
              //----------------------------------NationalMovementPdfList - 3
              SliverToBoxAdapter(
                child: NationalMovementPdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: NationalMovementPdfList.length > 0 ?
                          Text("National Movement", style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
                              height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                      MyPDFViewer(PdfUrl: NationalMovementPdfList[PDFindex].Url,
                                          PdfTitle: NationalMovementPdfList[PDFindex].SubTitle,
                                          context: context)));
                                },
                                child: Image.network(NationalMovementPdfList[PDFindex].ImgUrl),
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: NationalMovementPdfList.length,
                ),
              ),
             //----------------------------------Geography - 4
              SliverToBoxAdapter(
                child: GeographyPdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: GeographyPdfList.length > 0 ?
                          Text("Geography", style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
                              height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                      MyPDFViewer(PdfUrl: GeographyPdfList[PDFindex].Url,
                                          PdfTitle: GeographyPdfList[PDFindex].SubTitle,
                                          context: context)));
                                },
                                child: Image.network(GeographyPdfList[PDFindex].ImgUrl),
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: GeographyPdfList.length,
                ),
              ),
              //--------------------------------------IndianPolityGovernancePdfList - 5
              SliverToBoxAdapter(
                child: IndianPolityGovernancePdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: IndianPolityGovernancePdfList.length > 0 ?
                          Text("Indian Polity Governance", style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
                              height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyPDFViewer(PdfUrl: IndianPolityGovernancePdfList[PDFindex].Url,
                                              PdfTitle: IndianPolityGovernancePdfList[PDFindex].SubTitle,
                                              context: context)
                                  ));
                                },
                                child: Image.network(IndianPolityGovernancePdfList[PDFindex].ImgUrl),
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: IndianPolityGovernancePdfList.length,
                ),
              ),
              //--------------------------------------EconomicSocialDevpPdfList - 6
              SliverToBoxAdapter(
                child: EconomicSocialDevpPdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: EconomicSocialDevpPdfList.length > 0 ?
                        Text("Economic and Social Development", style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
                              height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyPDFViewer(PdfUrl: EconomicSocialDevpPdfList[PDFindex].Url,
                                              PdfTitle: EconomicSocialDevpPdfList[PDFindex].SubTitle,
                                              context: context)
                                  ));
                                },
                                child: Image.network(EconomicSocialDevpPdfList[PDFindex].ImgUrl),
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: EconomicSocialDevpPdfList.length,
                ),
              ),
              //--------------------------------------EnvironmentEcologyPdfList - 7
              SliverToBoxAdapter(
                child: EnvironmentEcologyPdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: EnvironmentEcologyPdfList.length > 0 ?
                        Text("Environment and Ecology", style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
                              height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyPDFViewer(PdfUrl: EnvironmentEcologyPdfList[PDFindex].Url,
                                              PdfTitle: EnvironmentEcologyPdfList[PDFindex].SubTitle,
                                              context: context)
                                  ));
                                },
                                child: Image.network(EnvironmentEcologyPdfList[PDFindex].ImgUrl),
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: EnvironmentEcologyPdfList.length,
                ),
              ),
              //--------------------------------------ComprehensionPdfList - 8
              SliverToBoxAdapter(
                child: ComprehensionPdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: ComprehensionPdfList.length > 0 ?
                        Text("Comprehension", style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
                              height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyPDFViewer(PdfUrl: ComprehensionPdfList[PDFindex].Url,
                                              PdfTitle: ComprehensionPdfList[PDFindex].SubTitle,
                                              context: context)
                                  ));
                                },
                                child: Image.network(ComprehensionPdfList[PDFindex].ImgUrl),
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: ComprehensionPdfList.length,
                ),
              ),
              //--------------------------------------InterpersonalSkillsPdfList - 9
              SliverToBoxAdapter(
                child: InterpersonalSkillsPdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: InterpersonalSkillsPdfList.length > 0 ?
                        Text("Interpersonal Skills Including Communication Skills", style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
                              height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyPDFViewer(PdfUrl: InterpersonalSkillsPdfList[PDFindex].Url,
                                              PdfTitle: InterpersonalSkillsPdfList[PDFindex].SubTitle,
                                              context: context)
                                  ));
                                },
                                child: Image.network(InterpersonalSkillsPdfList[PDFindex].ImgUrl),
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: InterpersonalSkillsPdfList.length,
                ),
              ),
              //--------------------------------------LogicalReasoningPdfList - 10
              SliverToBoxAdapter(
                child: LogicalReasoningPdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: LogicalReasoningPdfList.length > 0 ?
                        Text("Logical Reasoning and Analytical Ability", style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
                              height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyPDFViewer(PdfUrl: LogicalReasoningPdfList[PDFindex].Url,
                                              PdfTitle: LogicalReasoningPdfList[PDFindex].SubTitle,
                                              context: context)
                                  ));
                                },
                                child: Image.network(LogicalReasoningPdfList[PDFindex].ImgUrl),
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: LogicalReasoningPdfList.length,
                ),
              ),
              //--------------------------------------DecisionMakingPdfList - 10
              SliverToBoxAdapter(
                child: DecisionMakingPdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: DecisionMakingPdfList.length > 0 ?
                        Text("Decision Making and Problem Solving", style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
                              height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyPDFViewer(PdfUrl: DecisionMakingPdfList[PDFindex].Url,
                                              PdfTitle: DecisionMakingPdfList[PDFindex].SubTitle,
                                              context: context)
                                  ));
                                },
                                child: Image.network(DecisionMakingPdfList[PDFindex].ImgUrl),
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: DecisionMakingPdfList.length,
                ),
              ),
              //--------------------------------------GMentalAbilityPdfList - 10
              SliverToBoxAdapter(
                child: GMentalAbilityPdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: GMentalAbilityPdfList.length > 0 ?
                        Text("General Mental Ability", style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
                              height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyPDFViewer(PdfUrl: GMentalAbilityPdfList[PDFindex].Url,
                                              PdfTitle: GMentalAbilityPdfList[PDFindex].SubTitle,
                                              context: context)
                                  ));
                                },
                                child: Image.network(GMentalAbilityPdfList[PDFindex].ImgUrl),
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: GMentalAbilityPdfList.length,
                ),
              ),
              //--------------------------------------BasicNumeracyPdfList - 14
              SliverToBoxAdapter(
                child: BasicNumeracyPdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: BasicNumeracyPdfList.length > 0 ?
                        Text("Basic Numeracy", style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
                              height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyPDFViewer(PdfUrl: BasicNumeracyPdfList[PDFindex].Url,
                                              PdfTitle: BasicNumeracyPdfList[PDFindex].SubTitle,
                                              context: context)
                                  ));
                                },
                                child: Image.network(BasicNumeracyPdfList[PDFindex].ImgUrl),
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: BasicNumeracyPdfList.length,
                ),
              ),
              //--------------------------------------DataInterpretationPdfList - 15
              SliverToBoxAdapter(
                child: DataInterpretationPdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: DataInterpretationPdfList.length > 0 ?
                        Text("Data Interpretation", style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
                              height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyPDFViewer(PdfUrl: DataInterpretationPdfList[PDFindex].Url,
                                              PdfTitle: DataInterpretationPdfList[PDFindex].SubTitle,
                                              context: context)
                                  ));
                                },
                                child: Image.network(DataInterpretationPdfList[PDFindex].ImgUrl),
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: DataInterpretationPdfList.length,
                ),
              ),
              //--------------------------------------EnglishLanguagePdfList - 16
              SliverToBoxAdapter(
                child: EnglishLanguagePdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: EnglishLanguagePdfList.length > 0 ?
                        Text("English Language Comprehension Skills", style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
                              height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyPDFViewer(PdfUrl: EnglishLanguagePdfList[PDFindex].Url,
                                              PdfTitle: EnglishLanguagePdfList[PDFindex].SubTitle,
                                              context: context)
                                  ));
                                },
                                child: Image.network(EnglishLanguagePdfList[PDFindex].ImgUrl),
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: EnglishLanguagePdfList.length,
                ),
              ),
              //--------------------------------------ComputerKnowledgePdfList - 16
              SliverToBoxAdapter(
                child: ComputerKnowledgePdfList.length == 0 ? null : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: ComputerKnowledgePdfList.length > 0 ?
                        Text("Computer Knowledge", style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),) : null,
                      ),
                    ]
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
                              height: DH * 0.13,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyPDFViewer(PdfUrl: ComputerKnowledgePdfList[PDFindex].Url,
                                              PdfTitle: ComputerKnowledgePdfList[PDFindex].SubTitle,
                                              context: context)
                                  ));
                                },
                                child: Image.network(ComputerKnowledgePdfList[PDFindex].ImgUrl),
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: ComputerKnowledgePdfList.length,
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