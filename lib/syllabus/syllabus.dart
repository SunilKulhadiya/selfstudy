import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:selfstudy/module/syllabus_model.dart';
import 'package:selfstudy/shorts/shorts_list.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:selfstudy/module/data_module.dart';
import 'package:selfstudy/read/pdf_viewer.dart';
import 'package:selfstudy/image_viewer/image_view_zoom.dart';

import '../app_config.dart';
import '../module/carousel_model.dart';
import '../module/group_model.dart';

class Syllabus extends StatefulWidget {

  const Syllabus({super.key});

  @override
  State<Syllabus> createState() => CreateSList();
}
class CreateSList extends State<Syllabus>{
  List<CarouselDataModel> CaroUselData2 = [];
  List<SyllabusDataModel> GroupName = [];

  late ScrollController LVcontroller;
  late int VDResponseCode = 200;
  int StartRowNo = 0;
  var pixelRatio = window.devicePixelRatio;

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

    print("--------Syllabus.dart---<<<<<<<<<<<<<<< AppConfig.CAROUSE_URL : ${AppConfig.CAROUSE_URL}");
    //---------------------Carousel
    var body = {
      "ACTION": "0",
      "ROWNO": 0,
      "GROUPID": 0,
      "PAGE": "3"
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
    print("-----------------------------------------------------------------------------------------------------------");
    print(">>>>>>>>>>>>>>>>>Carousel Data : ${response}");
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        CaroUselData2 = jsonData.map((data) => CarouselDataModel.fromJson(data)).toList();
        print(">>>>>>>>>>>>>>>>>Carousel Data------------------------CaroUselData----------------- : ${CaroUselData2[1].ImgUrl}");
      });
    }else {
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
      "ACTION": "8",
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
            jsonData.map((data) => SyllabusDataModel.fromJson(data)).toList();
      });
      VDResponseCode = 200;
    } else {
      // Handle error if needed
      VDResponseCode = 1;
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
                                            image: NetworkImage(AppConfig.CAROUSE_URL+fileImage.ImgUrl),
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
                              aspectRatio: 9 / 5,
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
                    maxCrossAxisExtent: 150.0,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    childAspectRatio: 0.5,
                    //mainAxisExtent:
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return
                        Stack(
                            children: [
                              Container(
                                width: DW - 90,
                                height: DH * 0.25,
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
                                              MyPDFViewer(PdfUrl: GroupName[index].Url,
                                                  PdfTitle: GroupName[index].Group,
                                                  context: context)
                                      ));
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
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