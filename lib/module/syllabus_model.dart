import 'dart:ffi';

class SyllabusDataModel {
  final String Group;
  final String GroupID;
  final String Url;
  final String ImgUrl;


  SyllabusDataModel({
    required this.Group,
    required this.GroupID,
    required this.Url,
    required this.ImgUrl,
  });

  factory SyllabusDataModel.fromJson(Map<String, dynamic> json) {
    return SyllabusDataModel(
      Group: json['group_name'],
      GroupID: json['group_id'],
      Url: json['url'],
      ImgUrl: json['img_url'],
    );
  }
}