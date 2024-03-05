import 'dart:ffi';

class GroupDataModel {
  final String Group;
  final String GroupID;

  GroupDataModel({
    required this.Group,
    required this.GroupID,
  });

  factory GroupDataModel.fromJson(Map<String, dynamic> json) {
    return GroupDataModel(
      Group: json['group_name'],
      GroupID: json['group_id'],
    );
  }
}