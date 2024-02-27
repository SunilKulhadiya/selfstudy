import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

import '../module/data_module.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => CreateHomePage();
}

class CreateHomePage extends State<Home>{
  List<VideoDataModel> ShortsData = [];

  @override
  void initState() {
    super.initState();
    print("--------------------Home : ");
    fetchProducts();
  }
  Future<void> fetchProducts() async {
    final body = {
      "ACTION": "2",
      "ROWNO": 0,
      "GROUPID": 0,
    };
    final jsonBody = json.encode(body);

    // you can replace your api link with this link
    final response = await
    http.post(Uri.parse('https://sewabhartidabra.in/APIs/Fetch_SelfStudy_HomeData.php'),
        body: jsonBody,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json',}
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      print("--------------------Home : ${jsonData}");
      setState(() {
        ShortsData = jsonData.map((data) => VideoDataModel.fromJson(data)).toList();
      });
      print("-------------------Home-VDModel : ${ShortsData}");
    } else {
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey,
        child: SafeArea(
            child: CustomScrollView(
              slivers: [

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
                                      image: NetworkImage("https://sewabhartidabra.in/Self_Study/Geography_Maps/OIP21.jpg"),
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
                                      image: NetworkImage("https://sewabhartidabra.in/Self_Study/Geography_Maps/OIP20.jpg"),
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
                                      image: NetworkImage("https://sewabhartidabra.in/Self_Study/Geography_Maps/OIP19.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],

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

          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                alignment: Alignment.bottomLeft,

                child: Text('Shorts',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),

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
                      return Container(
                        margin: EdgeInsets.all(7),
                        alignment: Alignment.center,
                        color: Colors.blue,
                        child: Text(ShortsData[index].title),
                      );
                    },
                    childCount: ShortsData.length,
                  ),
                ),



              ],
            )),
      ),
    );




    //   Scaffold(
    //   body: Container(
    //     child: Column(
    //
    //   children: [
    //     Container(
    //       height: 200,
    //       child: Column(
    //         children: [
    //           Container(
    //             height: 200,
    //             child: CarouselSlider(
    //               items: [
    //                 //1st Image of Slider
    //                 Container(
    //                   margin: EdgeInsets.all(6.0),
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(8.0),
    //                     image: DecorationImage(
    //                       image: NetworkImage("https://sewabhartidabra.in/Self_Study/Geography_Maps/download6.jpg"),
    //                       fit: BoxFit.cover,
    //                     ),
    //                   ),
    //                 ),
    //
    //                 //2nd Image of Slider
    //                 Container(
    //                   margin: EdgeInsets.all(6.0),
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(8.0),
    //                     image: DecorationImage(
    //                       image: NetworkImage("https://sewabhartidabra.in/Self_Study/Geography_Maps/download7.jpg"),
    //                       fit: BoxFit.cover,
    //                     ),
    //                   ),
    //                 ),
    //
    //                 //3rd Image of Slider
    //                 Container(
    //                   margin: EdgeInsets.all(6.0),
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(8.0),
    //                     image: DecorationImage(
    //                       image: NetworkImage("https://sewabhartidabra.in/Self_Study/Geography_Maps/OIP21.jpg"),
    //                       fit: BoxFit.cover,
    //                     ),
    //                   ),
    //                 ),
    //
    //                 //4th Image of Slider
    //                 Container(
    //                   margin: EdgeInsets.all(6.0),
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(8.0),
    //                     image: DecorationImage(
    //                       image: NetworkImage("https://sewabhartidabra.in/Self_Study/Geography_Maps/OIP20.jpg"),
    //                       fit: BoxFit.cover,
    //                     ),
    //                   ),
    //                 ),
    //
    //                 //5th Image of Slider
    //                 Container(
    //                   margin: EdgeInsets.all(6.0),
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(8.0),
    //                     image: DecorationImage(
    //                       image: NetworkImage("https://sewabhartidabra.in/Self_Study/Geography_Maps/OIP19.jpg"),
    //                       fit: BoxFit.cover,
    //                     ),
    //                   ),
    //                 ),
    //
    //               ],
    //
    //               //Slider Container properties
    //               options: CarouselOptions(
    //                 height: 180.0,
    //                 //enlargeCenterPage: true,
    //                 autoPlay: true,
    //                 aspectRatio: 16 / 9,
    //                 autoPlayCurve: Curves.fastOutSlowIn,
    //                 enableInfiniteScroll: true,
    //                 autoPlayAnimationDuration: Duration(milliseconds: 800),
    //                 viewportFraction: 0.8,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //
    //     Container(
    //       margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
    //       alignment: Alignment.bottomLeft,
    //       child: Column(
    //         children: [
    //           // Container(
    //           //   child: Text('Latest Asked Questions',
    //           //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
    //           // ),
    //           Container(
    //             margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
    //             alignment: Alignment.bottomLeft,
    //             child: Column(
    //               children: [
    //                 Container(
    //                   alignment: Alignment.bottomLeft,
    //                   child: Text('Shorts',
    //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
    //                 ),
    //                 Container(
    //                   width: 400,
    //                   height: 700,
    //                     child: GridView.builder(
    //                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                         crossAxisCount: 3, // number of items in each row
    //                         mainAxisSpacing: 8.0, // spacing between rows
    //                         crossAxisSpacing: 8.0, // spacing between columns
    //                       ),
    //                       padding: EdgeInsets.all(8.0), // padding around the grid
    //                       itemCount: ShortsData.length, // total number of items
    //                       itemBuilder: (context, index) {
    //                         return Container(
    //                           color: Colors.blue, // color of grid items
    //                           child: Center(
    //                             child: Text(ShortsData[index].title,
    //                               style: TextStyle(fontSize: 18.0, color: Colors.white),
    //                             ),
    //                           ),
    //                         );
    //                       },
    //                     )
    //
    //                 ),
    //               ],
    //             )
    //           ),
    //           Container(
    //             alignment: Alignment.bottomLeft,
    //             child: Text('G.K.',
    //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
    //           ),
    //           Container(
    //             alignment: Alignment.bottomLeft,
    //             child: Text('Mathmetic Tricks',
    //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
    //           ),
    //           Container(
    //             alignment: Alignment.bottomLeft,
    //             child: Text('Geography',
    //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
    //           ),
    //
    //         ],
    //       ),
    //     )
    //
    //
    //   ],
    //   ),
    //   ),
    // );

  }//build

}//CreateHomePage