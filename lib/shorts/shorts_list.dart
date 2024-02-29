import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:selfstudy/shorts/video_player.dart';
import 'package:selfstudy/module/data_module.dart';
import 'package:selfstudy/shorts/youtub_player.dart';
//import 'package:selfstudy/generalTools/general_tools.dart';
//import 'package:selfstudy/repository/api_request.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

final List<String> VideoUrl = <String>[
  'https://sewabhartidabra.in/Self_Study/GK/Video/Gk2.mp4',
  'https://sewabhartidabra.in/Self_Study/GK/Video/Gk3.mp4',
  'https://sewabhartidabra.in/Self_Study/GK/Video/Gk4.mp4'];

class ShortsList extends StatefulWidget {
  final String clientName;
  final int GroupID;
  final int Action;
  final BuildContext context;

  const ShortsList({super.key,
    required this.clientName,
    required this.GroupID,
    required this.Action,
    required this.context});

  @override
  State<ShortsList> createState() => CreateSList();
}
class CreateSList extends State<ShortsList>{
  List<VideoDataModel> VDModel = [];
  List<VideoDataModel> VSubTitle = [];

  ScrollController LVcontroller = ScrollController();
  int StartRowNo = 0;
  String SelectedSbuTitle = "Select";


  @override
  void initState() {
    super.initState();
    print("-----------<<<<<<<<<<<<<<< &&&&&&&&&&&&&&&&&& >>>>>>>>>>>>>>>>>");

    LVcontroller.addListener(handleScrolling);
    print("-----------<<<<<<<<<<<<<<< &&&&&&&&&&&&&&&&&& ${LVcontroller}");
    fetchProducts();
    // setState(() {
    //   VDModel =  ApiRequest.ShortList_Fetch(url: "Fetch_SelfStudy",
    //       Action: widget.Action, StartRowNo: StartRowNo, GroupID: widget.GroupID) as List<VideoDataModel>;
    // });


  }
  void handleScrolling() {
    if (LVcontroller.position.pixels == LVcontroller.position.maxScrollExtent) {
      print("-----------<<<<<<<<<<<<<<< StartRowNo ---------------------------------");
      // setState(() {
      //   StartRowNo += 3;
      // });
      print("-----------<<<<<<<<<<<<<<< StartRowNo ${StartRowNo}");
    }
  }
  Future<void> fetchProducts() async {
    print(">>>>>>>>>>>>>>>>fetchProducts>>>>>>>>>>>>>>>>>>>>>>>>>>>>> GID : ${widget.GroupID}");
    final body = {
      "ACTION": widget.Action,
      "ROWNO": StartRowNo,
      "GROUPID": widget.GroupID,
      "SubTitle": SelectedSbuTitle
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
        VDModel = jsonData.map((data) => VideoDataModel.fromJson(data)).toList();
        //VSubTitle.add(VDModel as VideoDataModel);
      });
      print("--------------------VDModel : ${VDModel[0].Url}");
    } else {
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.clientName),
      ),
      body:Center(
          child: ListView(
            children: [
            Container(
              height: DH * 0.05,
              width: DW,
              alignment: Alignment.topCenter,
              //color: Color.fromRGBO(1, 1, 1, 50),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(177, 161, 188, 50),
                    ),
                    alignment: Alignment.centerRight,
                    width: DW * 0.4925,
                    child: CDropdownButton(context),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromRGBO(177, 161, 188, 50),
                    ),
                    margin: EdgeInsets.fromLTRB(6, 0, 0, 0),
                    alignment: Alignment.centerRight,
                    width: DW * 0.4925,
                    child: Icon(Icons.filter_alt, size: 30,),
                  ),

                ],
              ),
            ),
            Container(
                height: 777,
                width: 290,
                child: ListView.builder(
                  controller: LVcontroller,
                  itemCount: VDModel.isEmpty ? 0 : VDModel.length,
                  itemBuilder: (BuildContext context, int index) =>

                  (VDModel[index].SubTitle == SelectedSbuTitle ||
                      SelectedSbuTitle == "Select")?
                      Container(
                        width: 290,
                        height: 777,
                        alignment: Alignment.center,

                        child: Container(
                            key: new PageStorageKey(
                              "keydata$index",
                            ),

                            child: YouTubePlayer(
                              VideoUrl: VDModel[index].Url,
                              AutoPlay: 1,
                              context: context,
                            )
                        ),
                       ) : Container(
                              width: 290,
                              height: 777,
                              alignment: Alignment.center,
                            ),
                ),
              ),
            ],
          ),

      ),
    );
  }
//----------------------------------------------------------
 CDropdownButton(BuildContext context) {

  final double DW = MediaQuery.of(context).size.width;
  return DropdownMenu<String>(
  //initialSelection: list.first,

  hintText: "Sub Title",
  width: DW * 0.4925,
  inputDecorationTheme: InputDecorationTheme(
  isDense: true,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
  constraints: BoxConstraints.tight(const
  Size.fromHeight(40)),
  border: OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  ),
  ),
  onSelected: (String? value) {
  // This is called when the user selects an item.
  setState(() {
  SelectedSbuTitle = value!;
  });
  fetchProducts();

  },
  dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
  return DropdownMenuEntry<String>(value: value, label: value);
  }).toList(),

  );
  }

} //CreateSList
