import 'package:flutter/cupertino.dart';
import 'package:notepad/notes_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'db_helper.dart';


class NoteProvider with ChangeNotifier {
  DBhelper db = DBhelper();



  late Future<List<Note>> _notes;

  Future<List<Note>> get notes => _notes;

  Future<List<Note>> getData() async {
    _notes = db.getNoteList();
    return _notes;
  }
}





