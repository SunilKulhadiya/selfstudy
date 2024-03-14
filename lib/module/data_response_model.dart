import 'dart:ffi';

import 'package:selfstudy/module/user_data_model.dart';

class DataResponseModel {
  final String Response;
  final String Code;
  //final List<UserDataModel> Data;


  DataResponseModel({
    required this.Response,
    required this.Code,
    //required this.Data
  });

  factory DataResponseModel.fromJson(Map<String, dynamic> json) {
    //print(">>>>>>>>>>>>>>>>>>>>>>>>>DataResponseModel : ${dd}");
    return DataResponseModel(
      Response: json['response'],
      Code: json['code'],
      //Data: dd,
    );
  }
}