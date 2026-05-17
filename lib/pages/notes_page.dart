// lib/pages/notes_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/NoteModel.dart';
import '../providers/note_provider.dart';
import '../widgets/note_bottom_sheet.dart';
import 'deleted_notes_page.dart';
import 'note_details_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
    final provider =
    context.read<NoteProvider>();

    provider.listenToNotes();

    provider.listenToDeletedNotes();
    // Future.microtask(() {
    //   context.read<NoteProvider>().loadNotes();
    // });
  }

  void openBottomSheet({dynamic note, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return NoteBottomSheet(note: note, index: index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();

    final notes = noteProvider.notes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeletedNotesPage()),
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),

      body: notes.isEmpty
          ? const Center(
              child: Text('No Notes Found', style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
              //  print("length "+note.description.length.toString());
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteDetailsPage(
                            note: note,
                            index: index,
                          ),
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.all(12),

                    title: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                     //   Text(note.description.length < 50 ? note.description : "${note.description.substring(0,50)}..."),

                        const SizedBox(height: 10),

                        Text(

                          DateFormat(
                            'dd MMM yyyy, hh:mm a',
                          ).format(DateTime.parse(note.createdAt )),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: IconButton(
                            style: IconButton.styleFrom(
                              fixedSize: Size(20, 20),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NoteBottomSheet(
                                    note: note,
                                    index: index,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, size: 20),
                          ),
                        ),

                        Expanded(
                          child: IconButton(
                            style: IconButton.styleFrom(
                              fixedSize: Size(20, 20),
                            ),
                            onPressed: () async {
                              final shouldDelete = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Note'),
                                    content: const Text(
                                      'Are you sure you want to delete this note?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: const Text('Cancel'),
                                      ),

                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              // DELETE ONLY IF USER CONFIRMS

                              if (shouldDelete == true) {
                                noteProvider.deleteNote(note);
                              }
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NoteBottomSheet(
                note: null,
                index: null,

              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
