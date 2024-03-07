import 'dart:ffi';

class DocGroupDataModel {
  final String Group;
  final String GroupID;
  late final String ItemNos;


  DocGroupDataModel({
    required this.Group,
    required this.GroupID,
    required this.ItemNos,
  });

  factory DocGroupDataModel.fromJson(Map<String, dynamic> json) {
    return DocGroupDataModel(
      Group: json['group_name'],
      GroupID: json['group_id'],
      ItemNos: json['group_id'],
    );
  }
}