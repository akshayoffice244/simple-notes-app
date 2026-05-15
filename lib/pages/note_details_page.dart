// lib/pages/note_details_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../models/NoteModel.dart';
import '../providers/note_provider.dart';
import '../widgets/note_bottom_sheet.dart';

class NoteDetailsPage extends StatelessWidget {
  final NoteModel note;
  final int index;

  const NoteDetailsPage({
    super.key,
    required this.note,
    required this.index,
  });

  // OPEN UPDATE SHEET

  void openUpdateBottomSheet(
      BuildContext context,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return NoteBottomSheet(
          note: note,
          index: index,
        );
      },
    );
  }

  // DELETE DIALOG

  Future<void> showDeleteDialog(
      BuildContext context,
      ) async {
    final provider =
    context.read<NoteProvider>();

    final shouldDelete =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Note',
          ),

          content: const Text(
            'Are you sure you want to delete this note?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await provider.deleteNote(note);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),

        actions: [
          // UPDATE

          IconButton(
            onPressed: () {
              openUpdateBottomSheet(
                context,
              );
            },
            icon: const Icon(Icons.edit),
          ),

          // DELETE

          IconButton(
            onPressed: () {
              showDeleteDialog(context);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // TITLE

            Text(
              note.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // DATE

            Text(
              note.createdAt,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 24),

            // DESCRIPTION

            Text(
              "",
              style: const TextStyle(
                fontSize: 18,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}