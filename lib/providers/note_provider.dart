// lib/providers/note_provider.dart

import 'package:flutter/material.dart';
import 'package:simple_notes_app/providers/Repository/firestore_service.dart';

import '../models/NoteModel.dart';
import '../services/note_storage_service.dart';

class NoteProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<NoteModel> _notes = [];

  List<NoteModel> _deletedNotes = [];

  List<NoteModel> get notes => _notes;

  List<NoteModel> get deletedNotes => _deletedNotes;

  //listen active notes
  void listenToNotes() {
    _firestoreService.getNotes().listen((notes) {
      _notes = notes;
      notifyListeners();
    });
  }

  //listen to deleted notes
  void listenToDeletedNotes() {
    _firestoreService.getDeletedNotes().listen((notes) {
      _deletedNotes = notes;
      notifyListeners();
    });
  }

  // add note
  Future<void> addNote(NoteModel note) async {
    await _firestoreService.addNote(note);
  }

  //Update note
  Future<void> updateNote(NoteModel note) async {
    await _firestoreService.updateNote(note);
  }

  //delete note
  Future<void> deleteNote(NoteModel note) async{
    await _firestoreService.deleteNote(note);
  }

  //Restore note
  Future<void> restoreNote(NoteModel note) async{
    await _firestoreService.restoreNote(note);
  }
  //permanently delete note
Future<void> permanentlyDeleteNote(String id) async{
    await _firestoreService.permanentlyDelete(id);
}

  //following is code for local storage using sharedprefs

  // LOAD NOTES
  //
  // Future<void> loadNotes() async {
  //   _notes = await NoteStorageService.loadNotes();
  //
  //   _deletedNotes = await NoteStorageService.loadDeletedNotes();
  //
  //   notifyListeners();
  // }
  //
  // // ADD NOTE
  //
  // Future<void> addNote(NoteModel note) async {
  //   _notes.add(note);
  //
  //   await NoteStorageService.saveNotes(_notes);
  //
  //   notifyListeners();
  // }
  //
  // // UPDATE NOTE
  //
  // Future<void> updateNote(int index, NoteModel updatedNote) async {
  //   _notes[index] = updatedNote;
  //
  //   await NoteStorageService.saveNotes(_notes);
  //
  //   notifyListeners();
  // }
  //
  // // DELETE NOTE -> MOVE TO BIN
  //
  // Future<void> deleteNote(int index) async {
  //   final deletedNote = _notes[index];
  //
  //   // ADD TO DELETED LIST
  //   _deletedNotes.add(deletedNote);
  //
  //   // REMOVE FROM MAIN LIST
  //   _notes.removeAt(index);
  //
  //   await NoteStorageService.saveNotes(_notes);
  //
  //   await NoteStorageService.saveDeletedNotes(_deletedNotes);
  //
  //   notifyListeners();
  // }
  //
  // // RESTORE NOTE
  //
  // Future<void> restoreNote(int index) async {
  //   final restoredNote = _deletedNotes[index];
  //
  //   _notes.add(restoredNote);
  //
  //   _deletedNotes.removeAt(index);
  //
  //   await NoteStorageService.saveNotes(_notes);
  //
  //   await NoteStorageService.saveDeletedNotes(_deletedNotes);
  //
  //   notifyListeners();
  // }
  //
  // // PERMANENT DELETE
  //
  // Future<void> permanentlyDeleteNote(int index) async {
  //   _deletedNotes.removeAt(index);
  //
  //   await NoteStorageService.saveDeletedNotes(_deletedNotes);
  //
  //   notifyListeners();
  // }
}
