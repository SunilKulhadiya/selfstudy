import 'dart:ffi';

class SubGroupDataModel {
  final String SubGrpID;
  final String SubGrpName;


  SubGroupDataModel({
    required this.SubGrpID,
    required this.SubGrpName,
  });

  factory SubGroupDataModel.fromJson(Map<String, dynamic> json) {
    return SubGroupDataModel(
      SubGrpID: json['id'],
      SubGrpName: json['sub_group'],
    );
  }
}