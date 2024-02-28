import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:selfstudy/shorts/shorts_list.dart';

final List<String> entries = <String>['General Knowledge',
  'Math Tricks', 'Universal'];

class ShortsType extends StatelessWidget {

  const ShortsType({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Column(
        children: <Widget>[
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
            padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: GestureDetector(
              onTap: () {
                // ScaffoldMessenger.of(context).showSnackBar(
                // SnackBar(content: Text('Clicked on GK!')));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ShortsList(clientName: entries[1], GroupID: 1,
                            Action: 5,
                            context: context)));
              },
              child: Container(
                child: Card(
                  child: SizedBox(
                    width: 300,
                    height: 80,
                    child: Center(
                      child: Text(entries[0],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: GestureDetector(
              onTap: () {
                // ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text('Clicked on Math Tricks!')));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ShortsList(clientName: entries[1], GroupID: 2,
                            Action: 5,
                            context: context)));

              },
              child: Container(
                child: Card(
                  child: SizedBox(
                    width: 300,
                    height: 80,
                    child: Center(
                      child: Text(entries[1],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ShortsList(clientName: entries[1], GroupID: 3,
                            Action: 5,
                            context: context)));
                // ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text('Clicked on Univeersal!')));
              },
              child: Container(
                child: Card(
                  child: SizedBox(
                    width: 300,
                    height: 80,
                    child: Center(
                      child: Text(entries[2],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}