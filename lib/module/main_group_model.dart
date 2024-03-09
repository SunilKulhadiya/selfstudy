import 'dart:ffi';

class MainGroupDataModel {
  final String GroupID;
  final String GroupName;


  MainGroupDataModel({
    required this.GroupID,
    required this.GroupName,
  });

  factory MainGroupDataModel.fromJson(Map<String, dynamic> json) {
    return MainGroupDataModel(
      GroupID: json['group_id'],
      GroupName: json['group_name'],
    );
  }
}