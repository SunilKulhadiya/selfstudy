import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:selfstudy/module/data_module.dart';
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
  List<VideoDataModel> PdfList = [];
  List<CarouselDataModel> CaroUselData = [];
  List<GroupDataModel> GroupName = [];
  late ScrollController LVcontroller;
  late int VDResponseCode = 200;
  int StartRowNo = 0;
  var pixelRatio = window.devicePixelRatio;

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
    print("---------------------- physicalScreenSize : ${physicalScreenSize.width}");
    print("---------------------- view : ${view.physicalSize.width}");
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
    http.post(Uri.parse(AppConfig.BASE_URL+'Fetch_SelfStudy.php'),
        body: jsonBody,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json',}
    );
    if (response.statusCode == 200) {
      print("--------------------Docu list--------------CaroUselData : ${response.body}");
      List<dynamic> jsonData = json.decode(response.body);
      print("--------------------Docu list --------------------CaroUselData : ${jsonData}");
      setState(() {
        CaroUselData = jsonData.map((data) => CarouselDataModel.fromJson(data)).toList();
      });
    } else {
      CarouselDataModel CDM = new CarouselDataModel(id: 0, title: "",
          ImgUrl: AppConfig.CAROUSE_URL+'India_EtoW_NtoS_Length.jpg',
          GroupName: '', GroupID: "0", Approve: "1", Page: "0");
      CaroUselData.add(CDM);
      CDM = new CarouselDataModel(id: 0, title: "",
          ImgUrl: AppConfig.CAROUSE_URL+'ArabSagarMeMilneBaliNadiyan.jpg',
          GroupName: '', GroupID: "0", Approve: "1", Page: "0");
      CaroUselData.add(CDM);
      CDM = new CarouselDataModel(id: 0, title: "",
          ImgUrl: AppConfig.CAROUSE_URL+'ArabSagarMeMilneBaliNadiyan.jpg',
          GroupName: '', GroupID: "0", Approve: "1", Page: "0");
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
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json',}
    );
    if (response.statusCode == 200) {
      print("--------------------response  ????????????????????? : ${response.body}");
      List<dynamic> jsonData = json.decode(response.body);
      print("--------------------jsonData : ${jsonData}");
      setState(() {
        GroupName = jsonData.map((data) => GroupDataModel.fromJson(data)).toList();
      });
      VDResponseCode = 200;
    } else {
      // Handle error if needed
      VDResponseCode = 1;
    }
    //-------------------------------
    if(VDResponseCode == 200) {
        body = {
          "ACTION": "60",
          "ROWNO": StartRowNo,
          "GROUPID": "0", //widget.GroupID,
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
          print("--------------------jsonData : ${jsonData}");
          setState(() {
            PdfList =
                jsonData.map((data) => VideoDataModel.fromJson(data)).toList();
          });
          print("--------------------VDModel : ${PdfList[0].Url}");
          VDResponseCode = 1;
        } else {
          // Handle error if needed
        }
    }
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

                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Container(
                              child: Text(GroupName[index].Group,
                                style: TextStyle(fontSize: 20,
                                    fontWeight: FontWeight.bold),),
                            ),
                            Container(
                              child: Text('Null '),
                              // SliverList(
                              //   delegate: SliverChildBuilderDelegate(
                              //         (BuildContext context, int pdfindex) {
                              //       return Container(
                              //         width: 50,
                              //         height: 50,
                              //         child: Text(pdfindex as String),
                              //       );
                              //     },
                              //     childCount: PdfList.length,
                              //   ),
                              // ),

                            ),
                          ],
                        ),
                      );
                    },
                    childCount: GroupName.length,
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

} //CreateSList