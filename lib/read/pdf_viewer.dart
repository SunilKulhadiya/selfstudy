import 'dart:convert';
import 'dart:io';
//import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
//import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class MyPDFViewer extends StatefulWidget {
  final String PdfUrl;
  final String PdfTitle;
  final BuildContext context;

  const MyPDFViewer({super.key,
    required this.PdfUrl,
    required this.PdfTitle,
    required this.context});

  @override
  State<MyPDFViewer> createState() => CreateSList();
}
class CreateSList extends State<MyPDFViewer>{
  late PDFViewController _pdfViewController;
  late File Pfile;
  bool isLoading = false;
  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    var url = widget.PdfUrl;
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');

    await file.writeAsBytes(bytes, flush: true);
    print(">>>>>>>>>>>>>>>>>>>>>>filename : ${filename}");
    setState(() {
      print("*******************file : ${file}");
      Pfile = file;
    });

    print(Pfile);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    loadNetwork();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.PdfTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        child: Center(
          child: PDFView(
            filePath: Pfile.path,
          ),
        ),
      ),
    );
  }

} //CreateSList