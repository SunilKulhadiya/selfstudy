import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:selfstudy/module/data_module.dart';
import 'package:selfstudy/read/pdf_viewer.dart';

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
  late ScrollController LVcontroller;
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
    final body = {
      "ACTION": "6",
      "ROWNO": StartRowNo,
      "GROUPID": "0", //widget.GroupID,
    };
    final jsonBody = json.encode(body);

    // you can replace your api link with this link
    final response = await
    http.post(Uri.parse('https://sewabhartidabra.in/APIs/Fetch_SelfStudy.php'),
        body: jsonBody,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json',}
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      print("--------------------jsonData : ${jsonData}");
      setState(() {
        PdfList = jsonData.map((data) => VideoDataModel.fromJson(data)).toList();
      });
      print("--------------------VDModel : ${PdfList[0].Url}");
    } else {
      // Handle error if needed
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Container(
              height: 700,
              color: Colors.grey,
              child: Container(
                child: Column(
                  children: [
            Container(
              height: 200,
              child: CarouselSlider(
                items: [
                  //1st Image of Slider
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage("https://sewabhartidabra.in/Self_Study/Geography_Maps/download6.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //2nd Image of Slider
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage("https://sewabhartidabra.in/Self_Study/Geography_Maps/download7.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //3rd Image of Slider
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage("https://sewabhartidabra.in/Self_Study/Geography_Maps/download8.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //4th Image of Slider
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage("https://sewabhartidabra.in/Self_Study/Geography_Maps/download9.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //5th Image of Slider
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage("https://sewabhartidabra.in/Self_Study/Geography_Maps/OIP.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                ],

                //Slider Container properties
                options: CarouselOptions(
                  height: 180.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
              ),
            ),


            Container(
                height: MediaQuery.of(context).size.height - 390,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  physics: new BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        cacheExtent: 1000,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        controller: LVcontroller,
                        //key: PageStorageKey(widget.position),
                        addAutomaticKeepAlives: true,
                        itemCount: PdfList.isEmpty ? 0 : PdfList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            Container(
                              width: double.infinity,
                              height: 70,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: GestureDetector(
                                onTap: () async {
                                  // if (await canLaunch('https://sewabhartidabra.in/Self_Study/GK/Compound_Interest_QA.pdf')) {
                                  // await launchUrl('https://sewabhartidabra.in/Self_Study/GK/Compound_Interest_QA.pdf' as Uri);
                                  // } else {
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //       SnackBar(content: Text('Clicked on Math Tricks!')));
                                  // }
                                  // launch('https://drive.google.com/viewerng/viewer?embedded=true&url='+'https://sewabhartidabra.in/Self_Study/GK/Compound_Interest_QA.pdf');
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyPDFViewer(PdfUrl: PdfList[index].Url,
                                              PdfTitle: PdfList[index].title, context: context)));
                                },
                                child: Card(
                                  child: SizedBox(
                                    width: 300,
                                    height: 60,
                                    child: Center(
                                      child: Text(PdfList[index].title,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                      ),
                    ],
                  ),
                )
            ),


                  ],
                ),
              ),
            )

          ]
      ),
    );
  }

} //CreateSList