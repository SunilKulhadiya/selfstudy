import 'dart:ffi';

class SubTitleDataModel {
  final String SubTitle;

  SubTitleDataModel({
    required this.SubTitle,
  });

  factory SubTitleDataModel.fromJson(Map<String, dynamic> json) {
    return SubTitleDataModel(
      SubTitle: json['sub_title'],
    );
  }
}