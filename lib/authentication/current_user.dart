import 'package:firebase_database/firebase_database.dart';
import 'package:ozindi_damyt/authentication/current_book.dart';

class CurrentUser {
  String key;
  String info;
  String dostykName;
  String dostykId;
  String phoneNumber;

  CurrentUser({this.info, this.dostykName, this.dostykId, this.phoneNumber});

  CurrentUser.fromSnapshot(dynamic values)
      : info = values["info"],
        dostykName = values["dostykName"],
        dostykId = values["dostykId"],
        phoneNumber = values["phoneNumber"];

  toJson() {
    return {
      "info": info,
      "dostykName": dostykName,
      "dostykId": dostykId,
      "phoneNumber": phoneNumber
    };
  }
}
