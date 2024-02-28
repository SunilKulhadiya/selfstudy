import 'dart:ffi';

class VideoDataModel {
  final int id;
  final String title;
  final String SubTitle;
  final String Author;
  final String Url;
  final String ImgUrl;
  final String GroupID;
  final String Approve;

  VideoDataModel({
    required this.id,
    required this.title,
    required this.SubTitle,
    required this.Author,
    required this.Url,
    required this.ImgUrl,
    required this.GroupID,
    required this.Approve,
  });

  factory VideoDataModel.fromJson(Map<String, dynamic> json) {
    return VideoDataModel(
      id: int.parse(json['id']),
      title: json['title'],
      SubTitle: json['sub_title'],
      Author: json['author'],
      Url: json['url'],
      ImgUrl: json['img_url'],
      GroupID: json['group_id'],
      Approve: json['approved'],
    );
  }
}