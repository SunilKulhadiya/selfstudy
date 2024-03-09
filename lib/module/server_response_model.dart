import 'dart:ffi';

class ServerResponseModel {
  final String Response;
  final String Code;


  ServerResponseModel({
    required this.Response,
    required this.Code,
  });

  factory ServerResponseModel.fromJson(Map<String, dynamic> json) {
    return ServerResponseModel(
      Response: json['response'],
      Code: json['code'],
    );
  }
}