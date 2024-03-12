import 'dart:convert';
import 'dart:io';
import 'package:widget_zoom/widget_zoom.dart';
import 'package:flutter/material.dart';

import 'package:selfstudy/module/carousel_model.dart';
import 'package:selfstudy/image_viewer/sub_group_images.dart';

class Image_View_Zoom extends StatefulWidget {
  final List <CarouselDataModel> CaroUselData;
  final double ShowFirst;
  final BuildContext context;

  const Image_View_Zoom({super.key,
    required this.CaroUselData,
    required this.ShowFirst,
    required this.context});

  @override
  State<Image_View_Zoom> createState() => CreateSList();
}
class CreateSList extends State<Image_View_Zoom>{
  ScrollController LVcontroller = ScrollController();
  List <CarouselDataModel> carouselData = [];

  @override
  void initState() {
    super.initState();
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(widget.ShowFirst);
    //carouselData.add(widget.CaroUselData);
    LVcontroller = ScrollController(
      initialScrollOffset: 2,
      keepScrollOffset: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(117, 254, 250, 51),
        title: Text("Images"),
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
                itemCount: widget.CaroUselData.length,
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
                            zoomWidget: Image.network(widget.CaroUselData[index].ImgUrl,
                              width: DW - 10, height: DH - 250, fit: BoxFit.fill,),
                          )
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 50, 10, 0),
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    Sub_G_Image_Viewer(context: context,
                                      GrpID: widget.CaroUselData[index].GroupID,
                                      SubGrpID: widget.CaroUselData[index].SubGroupID,
                                      Title: widget.CaroUselData[index].Subtitle,)
                            ));

                            // ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
                            //     const SnackBar(
                            //         content: Text("dfsdfsd>>>>>>>>>>>>>>>>>>")
                            //     )
                            // );
                          },
                          child: Icon(Icons.double_arrow, size: 55, color: Colors.blue,
                            //shadows: <Shadow>[Shadow(color: Colors.black38, blurRadius: 15.0)],
                          ),
                        ),
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
