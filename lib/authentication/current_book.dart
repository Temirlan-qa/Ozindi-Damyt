import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class CurrentBook {
  String key;
  String author;
  String name;
  String photo;
  String readPage;
  String fullPage;

  CurrentBook({this.author, this.name, this.photo, this.readPage, this.fullPage});

  CurrentBook.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        author = snapshot.value["author"],
        name = snapshot.value["name"],
        photo = snapshot.value["photo"],
        readPage = snapshot.value["readPage"],
        fullPage = snapshot.value["fullPage"];


  CurrentBook.fromValues(dynamic values)
      : author = values["author"],
        name = values["name"],
        photo = values["photo"],
        readPage = values["readPage"],
        fullPage = values["fullPage"];

  toJson() {
    return {
      "author": author,
      "name": name,
      "photo": photo,
      "readPage": readPage,
      "fullPage": fullPage,
    };
  }

  toFinishBook() {
    String today = DateFormat('dd-MM').format(new DateTime.now());

    return {
      "author": author,
      "name": name,
      "photo": photo,
      "date": today,
    };
  }
}
