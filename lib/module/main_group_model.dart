import 'dart:ffi';

class MainGroupDataModel {
  final String ID;
  final String Group;


  MainGroupDataModel({
    required this.ID,
    required this.Group,
  });

  factory MainGroupDataModel.fromJson(Map<String, dynamic> json) {
    return MainGroupDataModel(
      Group: json['group_name'],
      ID: json['id'],
    );
  }
}