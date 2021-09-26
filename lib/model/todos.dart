import 'package:firebase_database/firebase_database.dart';

class Todos {
  String? _id;
  String? _title;
  String? _subtitle;

  Todos(this._id, this._title, this._subtitle);

  String? get id => _id;
  String? get title => _title;
  String? get subtitle => _subtitle;

  Todos.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _title = snapshot.value['title'];
    _subtitle = snapshot.value['subtitle'];
  }
}