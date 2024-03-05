import 'dart:ffi';

class CarouselDataModel {
  final int id;
  final String title;
  final String ImgUrl;
  final String GroupName;
  final String GroupID;
  final String Approve;
  final String Page;

  CarouselDataModel({
    required this.id,
    required this.title,
    required this.ImgUrl,
    required this.GroupName,
    required this.GroupID,
    required this.Approve,
    required this.Page,
  });

  factory CarouselDataModel.fromJson(Map<String, dynamic> json) {
    return CarouselDataModel(
      id: int.parse(json['id']),
      title: json['title'],
      ImgUrl: json['img_url'],
      GroupName: json['group_name'],
      GroupID: json['group_id'],
      Approve: json['approved'],
      Page: json['page'],
    );
  }
}