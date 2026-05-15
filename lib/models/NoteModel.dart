// lib/models/note_model.dart

import 'package:flutter/cupertino.dart';

class NoteModel {
  final String id;

  final String title;
  final List<NoteBlockModel> blocks;
  final String createdAt;
  final String? deletedAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.blocks,
    required this.createdAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'blocks': blocks.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'deletedAt': deletedAt,
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      blocks: (json['blocks'] as List)
          .map((e) => NoteBlockModel.fromJson(e))
          .toList(),
      createdAt: json['createdAt'],
      deletedAt: json['deletedAt'],
    );
  }

  //copy with
  NoteModel copyWith({
    String? id,
    String? title,
    List<NoteBlockModel>? blocks,
    String? createdAt,
    String? deletedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      blocks: blocks ?? this.blocks,
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
  final String text;

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

  EditableBlockModel({
    required this.type,
    required this.controller,
  });
}
