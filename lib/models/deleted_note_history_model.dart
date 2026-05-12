class DeletedNoteHistoryModel {
  final String noteId;

  final String userId;

  final String title;

  final String description;

  final String createdAt;

  final String deletedAt;

  final String permanentlyDeletedAt;

  DeletedNoteHistoryModel({
    required this.noteId,
    required this.userId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.deletedAt,
    required this.permanentlyDeletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'noteId': noteId,
      'userId': userId,
      'title': title,
      'description': description,
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
      description: json['description'],
      createdAt: json['createdAt'],
      deletedAt: json['deletedAt'],
      permanentlyDeletedAt:
      json['permanentlyDeletedAt'],
    );
  }
}