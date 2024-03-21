import 'dart:convert';
// import 'dart:html';
// import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import '../module/data_module.dart';
import 'package:selfstudy/shorts/youtub_player.dart';

import 'package:selfstudy/app_config.dart';
import '../read/pdf_viewer.dart';
import '../shorts/shorts_list.dart';
import 'package:selfstudy/home/google_search_view.dart';
import 'package:selfstudy/module/carousel_model.dart';
import 'package:selfstudy/module/ques_ans_model.dart';
import 'package:selfstudy/image_viewer/image_view_zoom.dart';
import 'package:selfstudy/home/question_answer.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => CreateHomePage();
}

class CreateHomePage extends State<Home>{
  late SharedPreferences prefs;
  String Notiff = "";
  List<CarouselDataModel> CaroUselData = [];
  List<QAnsModel> QuestionAnswer = [];
  List<VideoDataModel> ShortsData = [];
  List<VideoDataModel> DocData = [];
  final MySearchValue = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }
  Future<void> fetchProducts() async {
    var body = {
      "ACTION": "0",
      "ROWNO": 0,
      "GROUPID": "0",
      "PAGE": "0"
    };
    var jsonBody = json.encode(body);

    // you can replace your api link with this link
    var response = await
    http.post(Uri.parse(AppConfig.BASE_API_URL+'Fetch_SelfStudy.php'),
        body: jsonBody,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json',}
    );
    if (response.statusCode == 200) {
      print("--------------------Home : ${response.body}");
      List<dynamic> jsonData = json.decode(response.body);
      print("--------------------Home : ${jsonData}");
      setState(() {
        CaroUselData = jsonData.map((data) => CarouselDataModel.fromJson(data)).toList();
      });
      print("-------------------Home-VDModel : ${ShortsData}");
    } else {
      CarouselDataModel CDM = new CarouselDataModel(id: 0, title: "",
          ImgUrl: AppConfig.CAROUSE_URL+'India_EtoW_NtoS_Length.jpg',
          GroupName: '', GroupID: "0", Approve: "1", Page: "0", ImgDeco: 0,
          Subtitle: "", SubGroupID: "0", UserID: 0);
      CaroUselData.add(CDM);
      CDM = new CarouselDataModel(id: 0, title: "",
          ImgUrl: AppConfig.CAROUSE_URL+'ArabSagarMeMilneBaliNadiyan.jpg',
          GroupName: '', GroupID: "0", Approve: "1", Page: "0", ImgDeco: 0,
          Subtitle: "", SubGroupID: "0", UserID: 0);
      CaroUselData.add(CDM);
      CDM = new CarouselDataModel(id: 0, title: "",
          ImgUrl: AppConfig.CAROUSE_URL+'ArabSagarMeMilneBaliNadiyan.jpg',
          GroupName: '', GroupID: "0", Approve: "1", Page: "0", ImgDeco: 0,
          Subtitle: "", SubGroupID: "0", UserID: 0);
      CaroUselData.add(CDM);
    }
    //-------------------------------
    body = {
      "ACTION": "2",
      "ROWNO": 0,
      "GROUPID": 0,
    };
    jsonBody = json.encode(body);

    // you can replace your api link with this link
    response = await
    http.post(Uri.parse(AppConfig.BASE_API_URL+'Fetch_SelfStudy.php'),
        body: jsonBody,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json',}
    );
    if (response.statusCode == 200) {
      print("--------------------Home : ${response.body}");
      List<dynamic> jsonData = json.decode(response.body);
      print("--------------------Home : ${jsonData}");
      setState(() {
        ShortsData = jsonData.map((data) => VideoDataModel.fromJson(data)).toList();

      });
      print("-------------------Home-VDModel : ${ShortsData}");
    } else {
      // Handle error if needed
    }
    //-------------------------------Question &  Answer
    body = {
      "ACTION": "35",
      "ROWNO": 0,
      "GROUPID": 0,
    };
    jsonBody = json.encode(body);

    // you can replace your api link with this link
    response = await
    http.post(Uri.parse(AppConfig.BASE_API_URL+'Fetch_SelfStudy.php'),
        body: jsonBody,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json',}
    );
    if (response.statusCode == 200) {
      print("--------------------Home : ${response.body}");
      List<dynamic> jsonData = json.decode(response.body);
      print("--------------------Home : ${jsonData}");
      setState(() {
        QuestionAnswer = jsonData.map((data) => QAnsModel.fromJson(data)).toList();
      });
      //-------------------Ans
      print("--------------------Home QuestionAnswer[0].id : ${QuestionAnswer[0].id}");
      List<QAnsModel> TempQuestionAnswer = [];
      body = {
        "ACTION": "36",
        "ROWNO": 0,
        "GROUPID": 0,
        "QID": QuestionAnswer[0].id,
      };
      jsonBody = json.encode(body);

      // you can replace your api link with this link
      response = await
      http.post(Uri.parse(AppConfig.BASE_API_URL + 'Fetch_SelfStudy.php'),
          body: jsonBody,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          }
      );
      if (response.statusCode == 200) {
        print(
            "---->>>>>>>>>>>>>>>>>>-----Answer------------------------------------- : ${response
                .body}");
        List<dynamic> jsonData1 = json.decode(response.body);
        print(
            "---->>>>>>>>>>>>>>>>>>-----Answer------------------------------------- : ${jsonData}");
        for (var h in jsonData1) {
          QAnsModel authTitle = new QAnsModel(id: int.parse(h['id']),
              Qid: int.parse(h['ques_id']),
              Name: h['name'],
              Date: h['date'],
              Time: h['time'],
              UserText: h['user_text']);
          QuestionAnswer.add(authTitle);
          print(
              "---->>>>>>>>>>>>>>>>>>-----Answer------------------------------------- : ${QuestionAnswer
                  .length}");
        }
      } else {
        // Handle error if needed
      }
    } else {
      // Handle error if needed
    }
    //-------------------------------
    body = {
      "ACTION": "3",
      "ROWNO": 0,
      "GROUPID": 0,
    };
    jsonBody = json.encode(body);

    // you can replace your api link with this link
    response = await
    http.post(Uri.parse(AppConfig.BASE_API_URL+'Fetch_SelfStudy.php'),
        body: jsonBody,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json',}
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      print("--------------------Home : ${jsonData}");
      setState(() {
        DocData = jsonData.map((data) => VideoDataModel.fromJson(data)).toList();
      });
      print("-------------------Home-Doc : ${DocData}");
    } else {
      // Handle error if needed
    }

  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    MySearchValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double W = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;
    print("----------------------------------------W : ${W}");
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchProducts,
        child: Container(
        color: Colors.grey,
        child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          alignment: Alignment.center,
                          height: 50,
                          width: W - 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: W - 110,
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: TextField(
                                  controller: MySearchValue,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'Search.....',
                                    //suffixIcon: Icon(Icons.search),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (text) {
                                    print('First text field: $text (${text.characters.length})');
                                  },
                                ),
                              ),
                              Container(
                                width: 50,
                                  alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            GoogleSearchView(MySearch: MySearchValue.text,
                                            context: context)));
                                  },

                                  child: Icon(Icons.search, size: 40,),
                                )

                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                ),

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
                                              fit: BoxFit.fill,
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

                SliverToBoxAdapter(
                    child: QuestionAnswer.length >0 ? Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                          alignment: Alignment.bottomLeft,
                          child: Text('Question/Answer',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 8, 5, 0),
                          alignment: Alignment.bottomLeft,
                          child: QuestionAnswer.length >0 ? Text('Q.: ${ QuestionAnswer[0].UserText.substring(0, 150)}...',
                            style: TextStyle(fontSize: 16,
                              color: Colors.white),) : null,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 8, 5, 0),
                          alignment: Alignment.bottomLeft,
                          child: QuestionAnswer.length >1 ? Text('A.: ${QuestionAnswer[1].UserText.substring(0, 150)}...',
                            style: TextStyle(fontSize: 16,
                                color: Colors.black),) : null,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(W * 0.8, 8, 10, 0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      QuestionAnswerList()
                              ));
                            },
                            child: QuestionAnswer.length >0 ? Text('All...',
                              style: TextStyle(fontSize: 20,
                                  color: Colors.white),) : null,
                          )
                        ),
                      ],
                    ): null,
                ),

        SliverToBoxAdapter(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                alignment: Alignment.bottomLeft,
                child: Text('Shorts',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              ),
            ],
          )
        ),

            SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 130.0,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(
                                color: Color.fromRGBO(11, 86, 183, 50),
                                width: 3.0,
                              )
                            ),
                            margin: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: YouTubePlayer(
                              VideoUrl: ShortsData[index].Url,
                              AutoPlay: 0, PageNo: 0,
                              context: context,
                            ),
                          ),
                        ],
                      );

                          },
                    childCount: ShortsData.length,
                  ),
                ),
                SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: EdgeInsets.fromLTRB(W * 0.7, 5, 8, 0),
                              alignment: Alignment.center,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                  ShortsList(clientName: "Shorts",
                                      GroupID: 0,
                                      Action: 2,
                                      context: context)));
                                },
                              child: Padding(
                                padding: EdgeInsets.all(3),
                                child: Text('Full Screen', softWrap: true,
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: W > 400 ? 16 : 14,),),                          )
                          ),
                          ),
                        )
                      ],
                    )
                ),

                SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                          alignment: Alignment.bottomLeft,
                          child: Text('Notes',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                        ),
                      ],
                    )
                ),
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 130.0,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(5),
                            alignment: Alignment.center,
                          child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    MyPDFViewer(PdfUrl: DocData[index].Url,
                                        PdfTitle: DocData[index].title, context: context)));
                          },

                          child: Image.network(DocData[index].ImgUrl, fit: BoxFit.cover,),
                          ),
                          ),
                        ],
                      );

                    },
                    childCount: DocData.length,
                  ),
                ),

                SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          alignment: Alignment.bottomLeft,
                        ),
                      ],
                    )
                ),

              ],
            )),
      ),
      ),
    );

  }//build

//----------------------------------------------------------


}//CreateHomePage