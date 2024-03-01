import 'dart:ffi';

class AuthorDataModel {
  final String Author;

  AuthorDataModel({
    required this.Author,
  });

  factory AuthorDataModel.fromJson(Map<String, dynamic> json) {
    return AuthorDataModel(
      Author: json['author'],
    );
  }
}