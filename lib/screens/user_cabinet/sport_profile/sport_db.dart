import 'package:firebase_database/firebase_database.dart';

class SportDb {
  String key;
  String date;
  String step;
  String time;
  String type;

  SportDb({this.date, this.step, this.time,this.type});

  SportDb.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        date = snapshot.value["date"],
        step = snapshot.value["step"],
        type = snapshot.value["type"],
        time = snapshot.value["time"];

  toJson() {
    return {
      "date": date,
      "step": step,
      "type": type,
      "time": time,
    };
  }
}
