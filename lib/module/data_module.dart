import 'dart:ffi';

class VideoDataModel {
  final int id;
  final String title;
  final String VUrl;
  final String Group;
  final String Approve;

  VideoDataModel({
    required this.id,
    required this.title,
    required this.VUrl,
    required this.Group,
    required this.Approve,
  });

  factory VideoDataModel.fromJson(Map<String, dynamic> json) {
    return VideoDataModel(
      id: int.parse(json['id']),
      title: json['title'],
      VUrl: json['url'],
      Group: json['group_id'],
      Approve: json['approved'],
    );
  }
}