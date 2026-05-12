// lib/models/note_model.dart

class NoteModel {
  final String id;

  final String title;
  final String description;
  final String createdAt;



  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
    };
  }

  factory NoteModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'],
    );
  }

}