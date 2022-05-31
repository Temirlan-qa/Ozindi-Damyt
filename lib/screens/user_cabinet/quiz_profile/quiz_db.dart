import 'package:firebase_database/firebase_database.dart';

class QuizDb {
  String key;
  String date;
  String step;
  String point;
  String subject;

  QuizDb({this.date, this.step, this.point, this.subject});

  QuizDb.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        date = snapshot.value["date"],
        step = snapshot.value["step"],
        subject = snapshot.value["subject"],
        point = snapshot.value["point"];

  toJson() {
    return {
      "date": date,
      "step": step,
      "subject": subject,
      "point": point,
    };
  }
}
