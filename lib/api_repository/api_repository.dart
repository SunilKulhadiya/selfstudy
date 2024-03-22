import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../app_config.dart';
import '../module/data_response_model.dart';

class ApiRepository {
  late SharedPreferences prefs;
  int UserID = 0;

  Future<void> UserTokenUpdate() async {
    List<DataResponseModel> ServerRespons = [];
    int action = 32;
    prefs = await SharedPreferences.getInstance();
    UserID = (prefs.getInt('Userid') == null ? 0 : prefs.getInt('Userid'))!;
    print("-------------------->>>>>>>>>>>>>>> UserID : ${UserID} --------------------------Token");

    if(UserID == null || UserID == 0){
      action = 32;
    }else{
      action = 33;
    }

    var body = {
      "ACTION": action,
      "ROWNO": 0,
      "GROUPID": UserID,
      "DEVICETOKEN": prefs.get('DeviceToken'),
    };
    var jsonBody = json.encode(body);

    // you can replace your api link with this link
    var response = await
    http.post(Uri.parse(AppConfig.BASE_API_URL + 'Fetch_SelfStudy.php'),
        body: jsonBody,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }
    );
    print("--------------------Save server response : ${response.body} --------------------------Token");
    if (response.statusCode == 200) {
      print("--------------------Save server response : ${response.body}");
      List<dynamic> jsonData = json.decode(response.body);
        ServerRespons =
            jsonData.map((data) => DataResponseModel.fromJson(data)).toList();
      if(ServerRespons[0].Response == "Successfully Submited" && action == 32) {
        UserID = int.parse(ServerRespons[0].Code);
        prefs.setInt('Userid', UserID);
      }
      print("--------------------sub group : ${jsonData}");
    }
  }
  //---------------------------------------
  // Future<void> SaveNotification(String NN) async {
  //   prefs = await SharedPreferences.getInstance();
  //   UserID = (prefs.getInt('Userid') == null ? 0 : prefs.getInt('Userid'))!;
  //
  //   var body = {
  //     "ACTION": 34,
  //     "ROWNO": 0,
  //     "GROUPID": UserID,
  //     "DEVICETOKEN": NN,
  //   };
  //   var jsonBody = json.encode(body);
  //
  //   // you can replace your api link with this link
  //   var response = await
  //   http.post(Uri.parse(AppConfig.BASE_API_URL + 'Fetch_SelfStudy.php'),
  //       body: jsonBody,
  //       headers: {
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //       }
  //   );
  //   print("--------------------Save server response : ${response.body} --------------------------Token");
  //   if (response.statusCode == 200) {
  //     print("--------------------Save server response : ${response.body}");
  //     List<dynamic> jsonData = json.decode(response.body);
  //     }
  // }
  //------------------------
}