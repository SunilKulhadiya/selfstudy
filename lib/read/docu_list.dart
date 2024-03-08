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
import 'package:selfstudy/read/webviews.dart';
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
    //print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ");
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
              // print("---->>>>>>>>>>>----------Data--for--/////////////////////////777777777777777777777777777777777777777777777");
              // print(GKPdfList[0].ImgUrl);
              // print(GKPdfList[0].ImgUrl.lastIndexOf("."));
              // print(GKPdfList[0].ImgUrl.substring(GKPdfList[0].ImgUrl.lastIndexOf(".")+1, GKPdfList[0].ImgUrl.length));
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                                width: DW - 120,
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
                                    if(GKPdfList[PDFindex].Url.substring(GKPdfList[PDFindex].Url.lastIndexOf(".")+1, GKPdfList[PDFindex].Url.length) == "pdf") {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyPDFViewer(
                                                      PdfUrl: GKPdfList[PDFindex].Url,
                                                      PdfTitle: GKPdfList[PDFindex].SubTitle,
                                                      context: context)));
                                    }else{
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                              WebViews(WebUrl: GKPdfList[PDFindex].Url,
                                                  Title: GKPdfList[PDFindex].SubTitle,
                                                  context: context)
                                      ));
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        height: DH * 0.2,
                                        padding: EdgeInsets.all(3),
                                        child: Image.network(GKPdfList[PDFindex].ImgUrl),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(3),
                                        child: Text(GKPdfList[PDFindex].SubTitle,
                                                style: TextStyle(fontSize: GKPdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                      )
                                    ],
                                  )
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
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
                                  if(HistoryPdfList[PDFindex].Url.substring(HistoryPdfList[PDFindex].Url.lastIndexOf(".")+1, HistoryPdfList[PDFindex].Url.length) == "pdf") {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: HistoryPdfList[PDFindex].Url,
                                                PdfTitle: HistoryPdfList[PDFindex].SubTitle,
                                                context: context)));
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            WebViews(WebUrl: HistoryPdfList[PDFindex].Url,
                                                Title: HistoryPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }
                                },
                                  child: Column(
                                    children: [
                                      Container(
                                        height: DH * 0.2,
                                        padding: EdgeInsets.all(3),
                                        child: Image.network(HistoryPdfList[PDFindex].ImgUrl),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(3),
                                        child: Text(HistoryPdfList[PDFindex].SubTitle,
                                          style: TextStyle(fontSize: HistoryPdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                      )
                                    ],
                                  )
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
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
                                  if(NationalMovementPdfList[PDFindex].Url.substring(NationalMovementPdfList[PDFindex].Url.lastIndexOf(".")+1, NationalMovementPdfList[PDFindex].Url.length) == "pdf") {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: NationalMovementPdfList[PDFindex].Url,
                                                PdfTitle: NationalMovementPdfList[PDFindex].SubTitle,
                                                context: context)));
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            WebViews(WebUrl: NationalMovementPdfList[PDFindex].Url,
                                                Title: NationalMovementPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: DH * 0.2,
                                      padding: EdgeInsets.all(3),
                                      child: Image.network(NationalMovementPdfList[PDFindex].ImgUrl),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      child: Text(NationalMovementPdfList[PDFindex].SubTitle,
                                        style: TextStyle(fontSize: NationalMovementPdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                    )
                                  ],
                                )
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
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
                                  if(GeographyPdfList[PDFindex].Url.substring(GeographyPdfList[PDFindex].Url.lastIndexOf(".")+1, GeographyPdfList[PDFindex].Url.length) == "pdf") {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: GeographyPdfList[PDFindex].Url,
                                                PdfTitle: GeographyPdfList[PDFindex].SubTitle,
                                                context: context)));
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            WebViews(WebUrl: GeographyPdfList[PDFindex].Url,
                                                Title: GeographyPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: DH * 0.2,
                                      padding: EdgeInsets.all(3),
                                      child: Image.network(GeographyPdfList[PDFindex].ImgUrl),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      child: Text(GeographyPdfList[PDFindex].SubTitle,
                                        style: TextStyle(fontSize: GeographyPdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                    )
                                  ],
                                )
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
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
                                  if(IndianPolityGovernancePdfList[PDFindex].Url.substring(IndianPolityGovernancePdfList[PDFindex].Url.lastIndexOf(".")+1, IndianPolityGovernancePdfList[PDFindex].Url.length) == "pdf") {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: IndianPolityGovernancePdfList[PDFindex].Url,
                                                PdfTitle: IndianPolityGovernancePdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            WebViews(WebUrl: IndianPolityGovernancePdfList[PDFindex].Url,
                                                Title: IndianPolityGovernancePdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }
                               },
                              child: Column(
                                children: [
                                  Container(
                                    height: DH * 0.2,
                                    padding: EdgeInsets.all(3),
                                    child: Image.network(IndianPolityGovernancePdfList[PDFindex].ImgUrl),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    child: Text(IndianPolityGovernancePdfList[PDFindex].SubTitle,
                                      style: TextStyle(fontSize: IndianPolityGovernancePdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                  )
                                ],
                              )
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
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
                                  if(EconomicSocialDevpPdfList[PDFindex].Url.substring(EconomicSocialDevpPdfList[PDFindex].Url.lastIndexOf(".")+1, EconomicSocialDevpPdfList[PDFindex].Url.length) == "pdf") {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: EconomicSocialDevpPdfList[PDFindex].Url,
                                                PdfTitle: EconomicSocialDevpPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            WebViews(WebUrl: EconomicSocialDevpPdfList[PDFindex].Url,
                                                Title: EconomicSocialDevpPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: DH * 0.2,
                                      padding: EdgeInsets.all(3),
                                      child: Image.network(EconomicSocialDevpPdfList[PDFindex].ImgUrl),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      child: Text(EconomicSocialDevpPdfList[PDFindex].SubTitle,
                                        style: TextStyle(fontSize: EconomicSocialDevpPdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                    )
                                  ],
                                )
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
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
                                  if(EnvironmentEcologyPdfList[PDFindex].Url.substring(EnvironmentEcologyPdfList[PDFindex].Url.lastIndexOf(".")+1, EnvironmentEcologyPdfList[PDFindex].Url.length) == "pdf") {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: EnvironmentEcologyPdfList[PDFindex].Url,
                                                PdfTitle: EnvironmentEcologyPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            WebViews(WebUrl: EnvironmentEcologyPdfList[PDFindex].Url,
                                                Title: EnvironmentEcologyPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: DH * 0.2,
                                      padding: EdgeInsets.all(3),
                                      child: Image.network(EnvironmentEcologyPdfList[PDFindex].ImgUrl),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      child: Text(EnvironmentEcologyPdfList[PDFindex].SubTitle,
                                        style: TextStyle(fontSize: EnvironmentEcologyPdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                    )
                                  ],
                                )
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
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
                                  if(ComprehensionPdfList[PDFindex].Url.substring(ComprehensionPdfList[PDFindex].Url.lastIndexOf(".")+1, ComprehensionPdfList[PDFindex].Url.length) == "pdf") {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: ComprehensionPdfList[PDFindex].Url,
                                                PdfTitle: ComprehensionPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            WebViews(WebUrl: ComprehensionPdfList[PDFindex].Url,
                                                Title: ComprehensionPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: DH * 0.2,
                                      padding: EdgeInsets.all(3),
                                      child: Image.network(ComprehensionPdfList[PDFindex].ImgUrl),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      child: Text(ComprehensionPdfList[PDFindex].SubTitle,
                                        style: TextStyle(fontSize: ComprehensionPdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                    )
                                  ],
                                )
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
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
                                  if(InterpersonalSkillsPdfList[PDFindex].Url.substring(InterpersonalSkillsPdfList[PDFindex].Url.lastIndexOf(".")+1, InterpersonalSkillsPdfList[PDFindex].Url.length) == "pdf") {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: InterpersonalSkillsPdfList[PDFindex].Url,
                                                PdfTitle: InterpersonalSkillsPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            WebViews(WebUrl: InterpersonalSkillsPdfList[PDFindex].Url,
                                                Title: InterpersonalSkillsPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: DH * 0.2,
                                      padding: EdgeInsets.all(3),
                                      child: Image.network(InterpersonalSkillsPdfList[PDFindex].ImgUrl),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      child: Text(InterpersonalSkillsPdfList[PDFindex].SubTitle,
                                        style: TextStyle(fontSize: InterpersonalSkillsPdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                    )
                                  ],
                                )
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
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
                                  if(LogicalReasoningPdfList[PDFindex].Url.substring(LogicalReasoningPdfList[PDFindex].Url.lastIndexOf(".")+1, LogicalReasoningPdfList[PDFindex].Url.length) == "pdf") {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: LogicalReasoningPdfList[PDFindex].Url,
                                                PdfTitle: LogicalReasoningPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            WebViews(WebUrl: LogicalReasoningPdfList[PDFindex].Url,
                                                Title: LogicalReasoningPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: DH * 0.2,
                                      padding: EdgeInsets.all(3),
                                      child: Image.network(LogicalReasoningPdfList[PDFindex].ImgUrl),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      child: Text(LogicalReasoningPdfList[PDFindex].SubTitle,
                                        style: TextStyle(fontSize: LogicalReasoningPdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                    )
                                  ],
                                )
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
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
                                  if(DecisionMakingPdfList[PDFindex].Url.substring(DecisionMakingPdfList[PDFindex].Url.lastIndexOf(".")+1, DecisionMakingPdfList[PDFindex].Url.length) == "pdf") {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: DecisionMakingPdfList[PDFindex].Url,
                                                PdfTitle: DecisionMakingPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            WebViews(WebUrl: DecisionMakingPdfList[PDFindex].Url,
                                                Title: DecisionMakingPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: DH * 0.2,
                                      padding: EdgeInsets.all(3),
                                      child: Image.network(DecisionMakingPdfList[PDFindex].ImgUrl),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      child: Text(DecisionMakingPdfList[PDFindex].SubTitle,
                                        style: TextStyle(fontSize: DecisionMakingPdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                    )
                                  ],
                                )
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
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
                                  if(GMentalAbilityPdfList[PDFindex].Url.substring(GMentalAbilityPdfList[PDFindex].Url.lastIndexOf(".")+1, GMentalAbilityPdfList[PDFindex].Url.length) == "pdf") {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: GMentalAbilityPdfList[PDFindex].Url,
                                                PdfTitle: GMentalAbilityPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            WebViews(WebUrl: GMentalAbilityPdfList[PDFindex].Url,
                                                Title: GMentalAbilityPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: DH * 0.2,
                                      padding: EdgeInsets.all(3),
                                      child: Image.network(GMentalAbilityPdfList[PDFindex].ImgUrl),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      child: Text(GMentalAbilityPdfList[PDFindex].SubTitle,
                                        style: TextStyle(fontSize: GMentalAbilityPdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                    )
                                  ],
                                )
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
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
                                  if(BasicNumeracyPdfList[PDFindex].Url.substring(BasicNumeracyPdfList[PDFindex].Url.lastIndexOf(".")+1, BasicNumeracyPdfList[PDFindex].Url.length) == "pdf") {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: BasicNumeracyPdfList[PDFindex].Url,
                                                PdfTitle: BasicNumeracyPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            WebViews(WebUrl: BasicNumeracyPdfList[PDFindex].Url,
                                                Title: BasicNumeracyPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: DH * 0.2,
                                      padding: EdgeInsets.all(3),
                                      child: Image.network(BasicNumeracyPdfList[PDFindex].ImgUrl),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      child: Text(BasicNumeracyPdfList[PDFindex].SubTitle,
                                        style: TextStyle(fontSize: BasicNumeracyPdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                    )
                                  ],
                                )
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
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
                                  if(DataInterpretationPdfList[PDFindex].Url.substring(DataInterpretationPdfList[PDFindex].Url.lastIndexOf(".")+1, DataInterpretationPdfList[PDFindex].Url.length) == "pdf") {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: DataInterpretationPdfList[PDFindex].Url,
                                                PdfTitle: DataInterpretationPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            WebViews(WebUrl: DataInterpretationPdfList[PDFindex].Url,
                                                Title: DataInterpretationPdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: DH * 0.2,
                                      padding: EdgeInsets.all(3),
                                      child: Image.network(DataInterpretationPdfList[PDFindex].ImgUrl),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      child: Text(DataInterpretationPdfList[PDFindex].SubTitle,
                                        style: TextStyle(fontSize: DataInterpretationPdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                    )
                                  ],
                                )
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
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
                                  if(EnglishLanguagePdfList[PDFindex].Url.substring(EnglishLanguagePdfList[PDFindex].Url.lastIndexOf(".")+1, EnglishLanguagePdfList[PDFindex].Url.length) == "pdf") {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: EnglishLanguagePdfList[PDFindex].Url,
                                                PdfTitle: EnglishLanguagePdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            WebViews(WebUrl: EnglishLanguagePdfList[PDFindex].Url,
                                                Title: EnglishLanguagePdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: DH * 0.2,
                                      padding: EdgeInsets.all(3),
                                      child: Image.network(EnglishLanguagePdfList[PDFindex].ImgUrl),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      child: Text(EnglishLanguagePdfList[PDFindex].SubTitle,
                                        style: TextStyle(fontSize: EnglishLanguagePdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                    )
                                  ],
                                )
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
                  maxCrossAxisExtent: 150.0,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.5,
                  //mainAxisExtent:
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int PDFindex) {
                    return
                      Stack(
                          children: [
                            Container(
                              width: DW - 120,
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
                                  if(ComputerKnowledgePdfList[PDFindex].Url.substring(ComputerKnowledgePdfList[PDFindex].Url.lastIndexOf(".")+1, ComputerKnowledgePdfList[PDFindex].Url.length) == "pdf") {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            MyPDFViewer(PdfUrl: ComputerKnowledgePdfList[PDFindex].Url,
                                                PdfTitle: ComputerKnowledgePdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            WebViews(WebUrl: ComputerKnowledgePdfList[PDFindex].Url,
                                                Title: ComputerKnowledgePdfList[PDFindex].SubTitle,
                                                context: context)
                                    ));
                                  }
                                },
                                  child: Column(
                                    children: [
                                      Container(
                                        height: DH * 0.2,
                                        padding: EdgeInsets.all(3),
                                        child: Image.network(ComputerKnowledgePdfList[PDFindex].ImgUrl),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(3),
                                        child: Text(ComputerKnowledgePdfList[PDFindex].SubTitle,
                                          style: TextStyle(fontSize: ComputerKnowledgePdfList[PDFindex].SubTitle.length > 30 ? 10 : 14),),
                                      )
                                    ],
                                  )
                              ),
                            ),
                          ]
                      );
                  },
                  childCount: ComputerKnowledgePdfList.length,
                ),
              ),
              //----------------------------------------



          //--------------------------------------

            ],
          ),
        ),
      ),
      ),
    );
  }

} //CreateSList