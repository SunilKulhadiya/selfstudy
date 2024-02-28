import 'dart:convert';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class GoogleSearchView extends StatefulWidget {
  final String MySearch;
  final BuildContext context;


  const GoogleSearchView({super.key,
  required this.MySearch,
  required this.context});

  @override
  State<GoogleSearchView> createState() => CreateSList();
}
class CreateSList extends State<GoogleSearchView>{
  final _key = UniqueKey();
  late final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    final double Wdt = MediaQuery.of(context).size.width;
    final double Hgt = MediaQuery.of(context).size.height;

    print("??????????????????????????????????????????????????? MySearch : ${widget.MySearch}");
    return Scaffold(
      body: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
              height: Hgt-41,
              width: Wdt-2,
              color: Colors.grey,
              child: WebView(
        initialUrl: "https://www.google.com",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
      _controller = webViewController;
    },
    onPageFinished: (String s) {
      setState(() {
        //getElementsByTagName or getElementsByName
        _controller.evaluateJavascript(
            "window.addEventListener('load', function () {document.getElementsByName('q')[0].value += "+"'"+widget.MySearch+"'"+"})");
        _controller.evaluateJavascript(
            "window.addEventListener('load', function () {document.getElementsByName('btnK')[0].click})");
      },);
    }
    ),
            )

          ]
      ),
    );
  }

} //CreateSList