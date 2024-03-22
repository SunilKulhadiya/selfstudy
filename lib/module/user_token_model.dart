import 'dart:ffi';

class UserTokenModel {
  final String UserToken;


  UserTokenModel({
    required this.UserToken,
  });

  factory UserTokenModel.fromJson(Map<String, dynamic> json) {
    return UserTokenModel(
        UserToken: json['device_token']
    );
  }

}