import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:selfstudy/app_config.dart';
import 'package:selfstudy/module/data_module.dart';

class ApiRequest {


  static Future<VideoDataModel> ShortList_Fetch({required String url,
      required int Action, required StartRowNo, required int GroupID}) async {
    Future<VideoDataModel> VDModel = [] as Future<VideoDataModel>;

    Uri uri = Uri.parse(AppConfig.BASE_URL+url+".php");

    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> GID : ${GroupID}");
    final body = {
      "ACTION": Action,
      "ROWNO": StartRowNo,
      "GROUPID": GroupID,
    };
    final jsonBody = json.encode(body);

    // you can replace your api link with this link
    final response = await
    http.post(uri, body: jsonBody,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json',}
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      print("--------------------jsonData : ${jsonData}");

        VDModel = jsonData.map((data) => VideoDataModel.fromJson(data)) as Future<VideoDataModel>;

      print("--------------------VDModel : ${VDModel}");
    } else {
      // Handle error if needed
    }
    return VDModel;
  }



}
