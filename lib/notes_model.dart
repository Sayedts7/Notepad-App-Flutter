import 'dart:typed_data';

class Note{
  late final int? id;
  final String? title;
  final String? time;
  final String? description;
  final String? picture;

Note({
  required this.id,
  required this.title,
  required this.time,
  required this.description,
  required this.picture,
});

  Note.fromMap(Map<dynamic, dynamic> res)
      :  id = res['id'],
        title = res ['title'],
        time = res['time'],
        description = res['description'],
        picture = res['picture'];

  Map<String, Object?>  toMap() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'description': description,
      'picture' : picture,
    };
  }

}