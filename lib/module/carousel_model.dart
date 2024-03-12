import 'dart:ffi';

class CarouselDataModel {
  final int id;
  final String title;
  final String Subtitle;
  final String ImgUrl;
  final String GroupName;
  final String GroupID;
  final String SubGroupID;
  final String Approve;
  final String Page;
  final int ImgDeco;

  CarouselDataModel({
    required this.id,
    required this.title,
    required this.Subtitle,
    required this.ImgUrl,
    required this.GroupName,
    required this.GroupID,
    required this.SubGroupID,
    required this.Approve,
    required this.Page,
    required this.ImgDeco,
  });

  factory CarouselDataModel.fromJson(Map<String, dynamic> json) {
    return CarouselDataModel(
      id: int.parse(json['id']),
      title: json['title'],
      Subtitle: json['sub_title'],
      ImgUrl: json['img_url'],
      GroupName: json['group_name'],
      GroupID: json['group_id'],
      SubGroupID: json['sub_group_id'],
      Approve: json['approved'],
      Page: json['page'],
      ImgDeco: int.parse(json['img_decoration']),
    );
  }
}