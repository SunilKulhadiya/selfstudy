import 'dart:convert';
import 'dart:io';
import 'package:widget_zoom/widget_zoom.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:selfstudy/module/carousel_model.dart';

import '../app_config.dart';

class Sub_G_Image_Viewer extends StatefulWidget {
  final String GrpID;
  final String SubGrpID;
  final String Title ;
  final BuildContext context;

  const Sub_G_Image_Viewer({super.key,
    required this.GrpID,
    required this.SubGrpID,
    required this.Title,
    required this.context});

  @override
  State<Sub_G_Image_Viewer> createState() => CreateSList();
}
class CreateSList extends State<Sub_G_Image_Viewer> {
  ScrollController LVcontroller = ScrollController();
  List <CarouselDataModel> SubGrpImgData = [];

  @override
  void initState() {
    super.initState();
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    //carouselData.add(widget.CaroUselData);
    LVcontroller = ScrollController(
      initialScrollOffset: 2,
      keepScrollOffset: true,
    );
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    var body = {
      "ACTION": "100",
      "ROWNO": 0,
      "GROUPID": widget.GrpID,
      "SUBGRPID": widget.SubGrpID,
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
      SubGrpImgData = jsonData.map((data) => CarouselDataModel.fromJson(data)).toList();
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(117, 254, 250, 51),
        title: Text(widget.Title),
      ),
      body:Center(
        child: ListView(
          children: [
            Container(
              height: DH,
              width: DW,
              alignment: Alignment.center,
              child: ListView.builder(
                controller: LVcontroller,
                itemCount: SubGrpImgData.length,
                itemBuilder: (BuildContext context, int index) =>
                    Container(
                        width: DW - 20,
                        height: DH - 50,
                        alignment: Alignment.topCenter,
                        key: UniqueKey(),
                        child: Column(
                          children: [
                            Container(
                                key: new PageStorageKey(
                                  "keydata$index",
                                ),
                                child: WidgetZoom(
                                  heroAnimationTag: 'tag',
                                  zoomWidget: Image.network(SubGrpImgData[index].ImgUrl,
                                    width: DW - 10, height: DH - 250, fit: BoxFit.fill,),
                                )
                            ),

                          ],
                        )
                    ),
              ),
            ),
          ],
        ),

      ),
    );
  }

} //CreateSList
