// lib/pages/note_details_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/NoteModel.dart';
import '../providers/note_provider.dart';
import '../widgets/note_bottom_sheet.dart';

class NoteDetailsPage extends StatelessWidget {
  final NoteModel note;
  final int index;

  const NoteDetailsPage({super.key, required this.note, required this.index});

  // OPEN UPDATE SHEET

  void openUpdateBottomSheet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteBottomSheet(note: note, index: index),
      ),
    );
  }

  // DELETE DIALOG

  Future<void> showDeleteDialog(BuildContext context) async {
    final provider = context.read<NoteProvider>();

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Note'),

          content: const Text('Are you sure you want to delete this note?'),

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

    if (shouldDelete == true) {
      await provider.deleteNote(note);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<List<NoteBlockModel>> listOfLists = [];

    String? title;
    String? heading;
    String? subHeading;
    String? body;
    int currentIndex = 0;
    if (note.blocks.isNotEmpty) {
      for (var list in note.blocks) {
        switch (list.type) {
          case NoteBlockType.heading:
            heading = list.text ?? "";
            break;
          case NoteBlockType.subheading:
            subHeading = list.text ?? "";

            break;
          case NoteBlockType.body:
            body = list.text ?? "";
            break;
          default:
            NoteBlockModel noteBlockModel = NoteBlockModel(
              type: list.type,
              text: list.text,
            );
            if (listOfLists.isEmpty) {
              // currentListType = list.type;

              listOfLists.add([noteBlockModel]);
            } else if (listOfLists[currentIndex].first.type != list.type &&
                list.type == NoteBlockType.numbered) {
              listOfLists[currentIndex].add(noteBlockModel);
            } else if (listOfLists[currentIndex].first.type != list.type &&
                list.type == NoteBlockType.dashedList) {
              listOfLists[currentIndex].add(noteBlockModel);
            } else if (listOfLists[currentIndex].first.type != list.type &&
                list.type == NoteBlockType.bullet) {
              listOfLists[currentIndex].add(noteBlockModel);
            } else if (listOfLists[currentIndex].first.type ==
                    NoteBlockType.numberedListHeading ||
                listOfLists[currentIndex].first.type ==
                    NoteBlockType.dashedListHeading ||
                listOfLists[currentIndex].first.type ==
                    NoteBlockType.bulletListHeading) {
              currentIndex++;
              listOfLists.add([noteBlockModel]);
            }

            break;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),

        actions: [
          // UPDATE
          IconButton(
            onPressed: () {
              openUpdateBottomSheet(context);
            },
            icon: const Icon(Icons.edit),
          ),

          // DELETE
          IconButton(
            onPressed: () {
              showDeleteDialog(context);
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE
            Text(
              note.title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (heading != null)
              Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    heading,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            if (subHeading != null)
              Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    subHeading,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            if (body != null)
              Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    body,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ],
              ),

            //add here
            ListView.builder(
              shrinkWrap: true,
              itemCount: listOfLists.length,
              itemBuilder: (context, index) {
                return _CustomListWidget(
                  itemIndex: index,
                  listOfLists: listOfLists,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomListWidget extends StatelessWidget {
  final int itemIndex;
  final List<List<NoteBlockModel>> listOfLists;

  const _CustomListWidget({
    super.key,
    required this.itemIndex,
    required this.listOfLists,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (listOfLists[itemIndex].first.type ==
                NoteBlockType.dashedListHeading ||
            listOfLists[itemIndex].first.type ==
                NoteBlockType.numberedListHeading ||
            listOfLists[itemIndex].first.type ==
                NoteBlockType.bulletListHeading)
          Row(
            children: [
              Expanded(
                child: Text(listOfLists[itemIndex].first.text.toString()),
              ),
            ],
          ),
        Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.listOfLists[itemIndex].length - 1,
              itemBuilder: (context, index) {
                NoteBlockType type = provider.listOfLists[itemIndex].first.type;

                List<NoteBlockModel> itemList = listOfLists[itemIndex];
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    spacing: 15,
                    children: [
                      Text(
                        itemList[index + 1].type == NoteBlockType.numbered
                            ? "${index + 1}"
                            : itemList[index + 1].type == NoteBlockType.bullet
                            ? "• "
                            : "⁃",
                      ),

                      Expanded(
                        child: Text(itemList[index + 1].text.toString()),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
