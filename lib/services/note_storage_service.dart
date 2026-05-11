// lib/services/note_storage_service.dart

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/NoteModel.dart';

class NoteStorageService {
  static const String notesKey = "notes";
  static const String deletedNotesKey = "deleted_notes";

  // SAVE NOTES

  static Future<void> saveNotes(List<NoteModel> notes) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> encodedNotes = notes
        .map((e) => jsonEncode(e.toJson()))
        .toList();

    await prefs.setStringList(notesKey, encodedNotes);
  }

  // LOAD NOTES

  static Future<List<NoteModel>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? storedNotes = prefs.getStringList(notesKey);

    if (storedNotes == null) {
      return [];
    }

    return storedNotes.map((e) => NoteModel.fromJson(jsonDecode(e))).toList();
  }

  // SAVE DELETED NOTES

  static Future<void> saveDeletedNotes(List<NoteModel> notes) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> encodedNotes = notes
        .map((e) => jsonEncode(e.toJson()))
        .toList();

    await prefs.setStringList(deletedNotesKey, encodedNotes);
  }

  // LOAD DELETED NOTES

  static Future<List<NoteModel>> loadDeletedNotes() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? storedNotes = prefs.getStringList(deletedNotesKey);

    if (storedNotes == null) {
      return [];
    }

    return storedNotes.map((e) => NoteModel.fromJson(jsonDecode(e))).toList();
  }
}
