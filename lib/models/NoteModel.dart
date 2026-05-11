// lib/models/note_model.dart

class NoteModel {
  final String title;
  final String description;
  final String createdAt;

  NoteModel({
    required this.title,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt,
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'],
    );
  }

}