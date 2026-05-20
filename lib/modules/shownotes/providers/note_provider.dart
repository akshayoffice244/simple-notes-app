// lib/providers/note_provider.dart

import 'package:flutter/material.dart';
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
      titleController.text = myNote.title;
      if (myNote.blocks.isNotEmpty) {
        for (var list in myNote.blocks) {
          switch (list.type) {
            case NoteBlockType.heading:
              headingController.text = list.text ?? "";
              break;
            case NoteBlockType.subheading:
              subheadingController.text = list.text ?? "";

              break;
            case NoteBlockType.body:
              bodyController.text = list.text ?? "";
              break;
            default:
              TextEditingController controller = TextEditingController(
                text: list.text,
              );
              EditableBlockModel editableBlockModel = EditableBlockModel(
                type: list.type,
                controller: controller,
              );
              if (listOfLists.isEmpty) {
                // currentListType = list.type;

                listOfLists.add([editableBlockModel]);
              } else if (listOfLists[currentIndex].first.type != list.type &&
                  list.type == NoteBlockType.numbered) {
                listOfLists[currentIndex].add(editableBlockModel);
              } else if (listOfLists[currentIndex].first.type != list.type &&
                  list.type == NoteBlockType.dashedList) {
                listOfLists[currentIndex].add(editableBlockModel);
              } else if (listOfLists[currentIndex].first.type != list.type &&
                  list.type == NoteBlockType.bullet) {
                listOfLists[currentIndex].add(editableBlockModel);
              } else if (listOfLists[currentIndex].first.type ==
                      NoteBlockType.numberedListHeading ||
                  listOfLists[currentIndex].first.type ==
                      NoteBlockType.dashedListHeading ||
                  listOfLists[currentIndex].first.type ==
                      NoteBlockType.bulletListHeading) {
                currentIndex++;
                listOfLists.add([editableBlockModel]);
              }

              break;
          }
        }
      }
      //  provider.headingController.text = myNote.blocks.;
      // provider.titleController.text = myNote.title;
    }
  }

  Future<void> createOrUpdateNote(NoteModel? note) async {
    String title = titleController.text;
    String heading = headingController.text;
    String subHeading = subheadingController.text;
    String body = bodyController.text;
    List<NoteBlockModel> noteBlocks = [];
    noteBlocks.add(NoteBlockModel(type: NoteBlockType.heading, text: heading));
    noteBlocks.add(
      NoteBlockModel(type: NoteBlockType.subheading, text: subHeading),
    );
    noteBlocks.add(NoteBlockModel(type: NoteBlockType.body, text: body));
    for (var list in listOfLists) {
      for (var item in list) {
        noteBlocks.add(
          NoteBlockModel(type: item.type, text: item.controller.text),
        );
      }
    }
    NoteModel noteModel = NoteModel(
      id: note != null
          ? note.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      title:  title,
      blocks: noteBlocks,
      createdAt: note != null
          ? note.createdAt
          : DateTime.now().toIso8601String(),
    );

    if (note != null) {
      await updateNote(noteModel);
      print("Updating note ${noteModel.id}");
    } else {
      await addNote(noteModel);
      print("create note");
    }
    notifyListeners();
  }

  void addList(NoteBlockType type) {
    listOfLists.add([
      EditableBlockModel(type: type, controller: TextEditingController()),
    ]);
    notifyListeners();
  }
  void clearListOfLists(){
    listOfLists.clear();
   // notifyListeners();
  }
  void clearController(){
    titleController.clear();
    headingController.clear();
    subheadingController.clear();
    bodyController.clear();
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
    for( var item  in listOfLists[index]){
      if(item.type !=  NoteBlockType.bulletListHeading && item.type != NoteBlockType.dashedListHeading &&item.type != NoteBlockType.numberedListHeading){
        if(listOfLists[index].first.type == NoteBlockType.bulletListHeading){
          item.type = NoteBlockType.bullet;
        }else if(listOfLists[index].first.type == NoteBlockType.dashedListHeading){
          item.type = NoteBlockType.dashedList;
        }else if(listOfLists[index].first.type == NoteBlockType.numberedListHeading){

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
