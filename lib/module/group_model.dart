import 'dart:ffi';

class GroupDataModel {
  final String Group;
  final String GroupID;
  final String ImgUrl;
  late final String ItemNos;


  GroupDataModel({
    required this.Group,
    required this.GroupID,
    required this.ImgUrl,
    required this.ItemNos,
  });

  factory GroupDataModel.fromJson(Map<String, dynamic> json) {
    return GroupDataModel(
      Group: json['group_name'],
      GroupID: json['group_id'],
      ImgUrl: json['img_url'],
      ItemNos: json['group_id'],
    );
  }
}