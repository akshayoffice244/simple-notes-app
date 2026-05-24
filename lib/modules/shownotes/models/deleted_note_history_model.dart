import 'package:simple_notes_app/modules/shownotes/models/NoteModel.dart';

class DeletedNoteHistoryModel {
  final String noteId;

  final String userId;

  final String title;

  final String content;

  final String createdAt;

  final String deletedAt;

  final String permanentlyDeletedAt;

  DeletedNoteHistoryModel({
    required this.noteId,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.deletedAt,
    required this.permanentlyDeletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'noteId': noteId,
      'userId': userId,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'deletedAt': deletedAt,
      'permanentlyDeletedAt':
      permanentlyDeletedAt,
    };
  }

  factory DeletedNoteHistoryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DeletedNoteHistoryModel(
      noteId: json['noteId'],
      userId: json['userId'],
      title: json['title'],
      content: json['content'],
      createdAt: json['createdAt'],
      deletedAt: json['deletedAt'],
      permanentlyDeletedAt:
      json['permanentlyDeletedAt'],
    );
  }
}