// lib/models/note_model.dart

import 'package:flutter/cupertino.dart';

class NoteModel {
  final String id;

  final String title;
  final String content;
  final String createdAt;
  final String? deletedAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'deletedAt': deletedAt,
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] ?? "",
      title: json['title'] ?? "",
      content:json['content'] ?? "",
      createdAt: json['createdAt'] ?? "",
      deletedAt: json['deletedAt']?? "",
    );
  }

  //copy with
  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    String? createdAt,
    String? deletedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

enum NoteBlockType {
  heading,
  subheading,
  body,
  bulletListHeading,
  bullet,
  numberedListHeading,
  numbered,
  dashedListHeading,
  dashedList,
  none
}

class NoteBlockModel {
  final NoteBlockType type;
  final String? text;

  NoteBlockModel({required this.type, required this.text});

  Map<String, dynamic> toJson() {
    return {'type': type.name, 'text': text};
  }

  factory NoteBlockModel.fromJson(Map<String, dynamic> json) {
    return NoteBlockModel(
      type: NoteBlockType.values.firstWhere((e) => e.name == json['type']),
      text: json['text'],
    );
  }
}


class EditableBlockModel {

  NoteBlockType type;

  TextEditingController controller;
  int? number = 0;

  EditableBlockModel({
    required this.type,
    required this.controller,
  });
}
