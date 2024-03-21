import 'dart:ffi';

class QAnsModel {
  final int id;
  final int Qid;
  final String Name;
  final String Date;
  final String Time;
  final String UserText;

  QAnsModel({
    required this.id,
    required this.Qid,
    required this.Name,
    required this.Date,
    required this.Time,
    required this.UserText,
  });

  factory QAnsModel.fromJson(Map<String, dynamic> json) {
    return QAnsModel(
      id: int.parse(json['id']),
      Qid: int.parse(json['ques_id']),
      Name: json['name'],
      Date: json['date'],
      Time: json['time'],
      UserText: json['user_text'],
    );
  }
}