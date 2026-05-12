import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_notes_app/models/NoteModel.dart';

import '../../models/deleted_note_history_model.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String userId = "demo_user";

  //collection references
  //ref to notes collection
  CollectionReference get notesRef =>
      firestore.collection("users").doc(userId).collection("notes");

  CollectionReference get trashRef =>
      firestore.collection("users").doc(userId).collection("trash");

  CollectionReference get historyRef =>
      firestore.collection(
        "deleted_note_history",
      );

  //Add single note
  Future<void> addNote(NoteModel note) async {

    await notesRef.doc(note.id).set(note.toJson());
  }

  //get all active notes
  Stream<List<NoteModel>> getNotes() {
    return notesRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => NoteModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  //get deleted notes
  Stream<List<NoteModel>> getDeletedNotes() {
    return trashRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => NoteModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  //update note
  Future<void> updateNote(NoteModel note) async {
    await notesRef.doc(note.id).set(note.toJson());
  }

  //soft delete

  Future<void> deleteNote(NoteModel note) async {
    //add to trash
    final deleteNote = note.copyWith(deletedAt:  DateTime.now().toIso8601String());

    await trashRef.doc(deleteNote.id).set(deleteNote.toJson());

    //remove from active notes
    await notesRef.doc(note.id).delete();
  }

  //restore note
  Future<void> restoreNote(NoteModel note) async {
    final restoredNote = note.copyWith(deletedAt: null);

    //add to active notes
    await notesRef.doc(note.id).set(restoredNote.toJson());
    //remove from trash
    await trashRef.doc(note.id).delete();
  }

  Future<void> permanentlyDelete(NoteModel note) async {
    // CREATE HISTORY RECORD

    final history =
    DeletedNoteHistoryModel(
      noteId: note.id,
      userId: userId,
      title: note.title,
      description: note.description,
      createdAt: note.createdAt,
      deletedAt: note.deletedAt ?? '',
      permanentlyDeletedAt:
      DateTime.now()
          .toIso8601String(),
    );

    // STORE IN HISTORY COLLECTION

    await historyRef.add(
      history.toJson(),
    );
    //remove from trash
    await trashRef.doc(note.id).delete();
  }
}
