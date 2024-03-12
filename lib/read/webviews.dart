import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViews extends StatefulWidget {
  final String WebUrl;
  final String Title;
  final BuildContext context;

  const WebViews({super.key,
    required this.WebUrl,
    required this.Title,
    required this.context});


  @override
  State<WebViews> createState() => CreateSList();
}
class CreateSList extends State<WebViews>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(widget.Title),
            backgroundColor: Color.fromRGBO(117, 254, 250, 51),
          ),
          body: WebView(
            initialUrl: widget.WebUrl,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }

} //CreateSList