// deleted_notes_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/note_provider.dart';

class DeletedNotesPage extends StatelessWidget {
  const DeletedNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<NoteProvider>();

    final deletedNotes =
        provider.deletedNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycle Bin'),
      ),

      body: deletedNotes.isEmpty
          ? const Center(
        child: Text('No Deleted Notes'),
      )
          : ListView.builder(
        itemCount: deletedNotes.length,
        itemBuilder: (context, index) {
          final note =
          deletedNotes[index];

          return Card(
            child: ListTile(
              title: Text(note.title),

              subtitle: Text(
                note.description,
              ),

              trailing: Row(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  // RESTORE

                  IconButton(
                    onPressed: () {
                      provider.restoreNote(
                        note
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully restore note!")));
                    },
                    icon: const Icon(
                      Icons.restore,
                      color: Colors.green,
                    ),
                  ),

                  // PERMANENT DELETE

                  IconButton(
                    onPressed: () async {

                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete Note'),
                            content: const Text(
                              'Are you sure you want to permanently delete this note?',
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
                      if(shouldDelete == true)
                      {
                        provider
                            .permanentlyDeleteNote(
                          note.id
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}