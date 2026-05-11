// lib/widgets/note_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../models/NoteModel.dart';
import '../providers/note_provider.dart';

class NoteBottomSheet extends StatelessWidget {
  final NoteModel? note;
  final int? index;

  const NoteBottomSheet({
    super.key,
    this.note,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final titleController =
    TextEditingController(text: note?.title ?? '');

    final descriptionController =
    TextEditingController(text: note?.description ?? '');

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            note == null ? 'Create Note' : 'Update Note',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // TITLE

          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // DESCRIPTION

          TextField(
            controller: descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Write your note...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final title =
                titleController.text.trim();

                final description =
                descriptionController.text.trim();

                if (title.isEmpty ||
                    description.isEmpty) {
                  return;
                }

                final noteProvider =
                context.read<NoteProvider>();

                final newNote = NoteModel(
                  title: title,
                  description: description,
                  createdAt:
                  note?.createdAt ??
                      DateTime.now().toString(),
                );

                if (index == null) {
                  await noteProvider.addNote(newNote);
                } else {
                  await noteProvider.updateNote(
                    index!,
                    newNote,
                  );
                }

                Navigator.pop(context);
              },
              child: Text(
                note == null
                    ? 'Create Note'
                    : 'Update Note',
              ),
            ),
          ),
        ],
      ),
    );
  }
}