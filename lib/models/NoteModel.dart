// lib/models/note_model.dart

class NoteModel {
  final String id;

  final String title;
  final String description;
  final String createdAt;
  final String? deletedAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'deletedAt': deletedAt,
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'],
      deletedAt: json['deleteAt'],
    );
  }

  //copy with
  NoteModel copyWith({
    String? id,
    String? title,
    String? description,
    String? createdAt,
    String? deletedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
