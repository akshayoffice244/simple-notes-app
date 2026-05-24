// lib/providers/note_provider.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:simple_notes_app/modules/shownotes/services/firestore_service.dart';

import '../models/NoteModel.dart';

class NoteProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<NoteModel> _notes = [];

  List<NoteModel> _deletedNotes = [];

  List<NoteModel> get notes => _notes;

  List<NoteModel> get deletedNotes => _deletedNotes;
  final List<List<EditableBlockModel>> listOfLists = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController headingController = TextEditingController();
  final TextEditingController subheadingController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  final quillController = QuillController.basic();

  bool _isHeadingActive = false;

  set isHeadingActive(bool value) {
    _isHeadingActive = value;
    notifyListeners();
  }

  bool _isSubheadingActive = false;

  bool get isHeadingActive => _isHeadingActive;

  void initialisation(NoteModel? myNote) {
    clearController();
    clearListOfLists();
    int currentIndex = 0;
    if (myNote != null) {
      //  provider.headingController.text = myNote.blocks.;
      // provider.titleController.text = myNote.title;
      quillController.document = Document.fromJson(jsonDecode(myNote.content));
    }
  }

  Future<void> createOrUpdateNote(NoteModel? note) async {
    final plainText = quillController.document.toPlainText();

    final lines = plainText.split('\n');

    final title = lines.first.trim();

    String content = jsonEncode(quillController.document.toDelta().toJson());

    NoteModel noteModel = NoteModel(
      id: note != null
          ? note.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: note != null
          ? note.createdAt
          : DateTime.now().toIso8601String(),
    );

    if (note != null) {
      await updateNote(noteModel);
    } else {
      await addNote(noteModel);
    }
    notifyListeners();
  }

  void addList(NoteBlockType type) {
    listOfLists.add([
      EditableBlockModel(type: type, controller: TextEditingController()),
    ]);
    notifyListeners();
  }

  void clearListOfLists() {
    listOfLists.clear();
    // notifyListeners();
  }

  void clearController() {
    titleController.clear();
    headingController.clear();
    subheadingController.clear();
    bodyController.clear();
    quillController.clear();
    //notifyListeners();
  }

  void addItemsToList(NoteBlockType listItemType, int index) {
    listOfLists[index].add(
      EditableBlockModel(
        type: listItemType,
        controller: TextEditingController(),
      ),
    );
    notifyListeners();
  }

  void setListType(value, index) {
    late NoteBlockType type;
    switch (value) {
      case 1:
        type = NoteBlockType.bulletListHeading;
        break;

      case 2:
        type = NoteBlockType.numberedListHeading;
        break;
      case 3:
        type = NoteBlockType.dashedListHeading;
        break;
    }
    print("List heading type: ");
    print(type);
    listOfLists[index][0] = EditableBlockModel(
      type: type,
      controller: listOfLists[index].first.controller,
    );
    for (var item in listOfLists[index]) {
      if (item.type != NoteBlockType.bulletListHeading &&
          item.type != NoteBlockType.dashedListHeading &&
          item.type != NoteBlockType.numberedListHeading) {
        if (listOfLists[index].first.type == NoteBlockType.bulletListHeading) {
          item.type = NoteBlockType.bullet;
        } else if (listOfLists[index].first.type ==
            NoteBlockType.dashedListHeading) {
          item.type = NoteBlockType.dashedList;
        } else if (listOfLists[index].first.type ==
            NoteBlockType.numberedListHeading) {
          item.type = NoteBlockType.numbered;
        }
      }
    }
    notifyListeners();
  }

  void createNote() {
    // NoteModel noteModel =NoteModel(id: DateTime.now().millisecond.toString(), title: titleController.text, blocks: blocks, createdAt: createdAt)
  }

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

  void removeListItem(int itemIndex) {
    if (listOfLists[itemIndex].length > 1) {
      listOfLists[itemIndex].removeLast();
      notifyListeners();
    }
  }

  void removeList() {
    if (listOfLists.isNotEmpty) {
      listOfLists.removeLast();
      notifyListeners();
    }
  }

  void removeCurrentList(int index) {
    if (listOfLists.isNotEmpty) {
      listOfLists.removeAt(index);
      notifyListeners();
    }
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
  Future<void> deleteNote(NoteModel note) async {
    await _firestoreService.deleteNote(note);
  }

  //Restore note
  Future<void> restoreNote(NoteModel note) async {
    await _firestoreService.restoreNote(note);
  }

  //permanently delete note
  Future<void> permanentlyDeleteNote(NoteModel note) async {
    await _firestoreService.permanentlyDelete(note);
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    headingController.dispose();
    subheadingController.dispose();
    bodyController.dispose();
    for (var list in listOfLists) {
      for (var item in list) {
        item.controller.dispose();
      }
    }
  }

  bool get isSubheadingActive {
    return _isSubheadingActive;
  }

  set isSubheadingActive(bool value) {
    _isSubheadingActive = value;
    notifyListeners();
  }
}
