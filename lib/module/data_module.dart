import 'dart:ffi';

class VideoDataModel {
  final int id;
  final String title;
  final String SubTitle;
  final String Author;
  final String Url;
  final String ImgUrl;
  final String GroupName;
  final String GroupID;
  final String SubGroupID;
  final String Approve;
  final int UserID;

  VideoDataModel({
    required this.id,
    required this.title,
    required this.SubTitle,
    required this.Author,
    required this.Url,
    required this.ImgUrl,
    required this.GroupName,
    required this.GroupID,
    required this.SubGroupID,
    required this.Approve,
    required this.UserID,
  });

  factory VideoDataModel.fromJson(Map<String, dynamic> json) {
    return VideoDataModel(
      id: int.parse(json['id']),
      title: json['title'],
      SubTitle: json['sub_title'],
      Author: json['author'],
      Url: json['url'],
      ImgUrl: json['img_url'],
      GroupName: json['group_name'],
      GroupID: json['group_id'],
      SubGroupID: json['sub_group_id'],
      Approve: json['approved'],
      UserID: int.parse(json['user_id']),
    );
  }
}