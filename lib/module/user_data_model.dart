import 'dart:ffi';

class UserDataModel {
  final int ID;
  final String Name;
  final String Email;
  final String PassWord;
  final String ContactNo;
  final String Country;
  final String State;
  final String City;
  final String BankName;
  final String IFSCcode;
  final String HolderName;
  final String AccountNo;


  UserDataModel({
    required this.ID,
    required this.Name,
    required this.Email,
    required this.PassWord,
    required this.ContactNo,
    required this.Country,
    required this.State,
    required this.City,
    required this.BankName,
    required this.IFSCcode,
    required this.HolderName,
    required this.AccountNo,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      ID: int.parse(json['id']),
      Name: json['name'],
      Email: json['email'],
      PassWord: json['password'],
      ContactNo: json['contact_no'],
      Country: json['country'],
      State: json['state'],
      City: json['city'],
      BankName: json['bank_name'],
      IFSCcode: json['ifsc_code'],
      HolderName: json['account_holder_name'],
      AccountNo: json['account_no']
    );
  }

}