// lib/pages/note_details_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  void openUpdateBottomSheet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteBottomSheet(
          note: note,
          index: index,
        ),
      ),
    );
  }

  Future<void> showDeleteDialog(BuildContext context) async {
    final provider = context.read<NoteProvider>();

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: Text(
            "Delete Note",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
            ),
          ),

          content: Text(
            "Are you sure you want to delete this note?",
            style: GoogleFonts.inter(
              fontSize: 15,
              height: 1.5,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: Text(
                "Cancel",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              onPressed: () {
                Navigator.pop(context, true);
              },

              child: Text(
                "Delete",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
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
    List<List<NoteBlockModel>> listOfLists = [];

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
              listOfLists.add([noteBlockModel]);
            } else if (listOfLists[currentIndex].first.type !=
                list.type &&
                list.type == NoteBlockType.numbered) {
              listOfLists[currentIndex].add(noteBlockModel);
            } else if (listOfLists[currentIndex].first.type !=
                list.type &&
                list.type == NoteBlockType.dashedList) {
              listOfLists[currentIndex].add(noteBlockModel);
            } else if (listOfLists[currentIndex].first.type !=
                list.type &&
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
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF8F9FB),
        surfaceTintColor: Colors.transparent,

        titleSpacing: 20,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Note Details",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            Text(
              "View your note",
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),

            child: IconButton(
              onPressed: () {
                openUpdateBottomSheet(context);
              },

              style: IconButton.styleFrom(
                backgroundColor: Colors.blue.shade50,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              icon: Icon(
                Icons.edit_rounded,
                color: Colors.blue.shade500,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 16),

            child: IconButton(
              onPressed: () {
                showDeleteDialog(context);
              },

              style: IconButton.styleFrom(
                backgroundColor: Colors.red.shade50,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              icon: Icon(
                Icons.delete_outline_rounded,
                color: Colors.red.shade400,
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(24),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(28),

            border: Border.all(
              color: Colors.grey.shade200,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,

                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: Colors.black87,
                ),
              ),

              if (heading != null && heading.isNotEmpty) ...[
                const SizedBox(height: 28),

                Text(
                  heading,

                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],

              if (subHeading != null && subHeading.isNotEmpty) ...[
                const SizedBox(height: 20),

                Text(
                  subHeading,

                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],

              if (body != null && body.isNotEmpty) ...[
                const SizedBox(height: 24),

                Text(
                  body,

                  style: GoogleFonts.inter(
                    fontSize: 16,
                    height: 1.8,
                    color: Colors.black87,
                  ),
                ),
              ],

              if (listOfLists.isNotEmpty)
                const SizedBox(height: 28),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
    List itemList = listOfLists[itemIndex].where((item)=>item.text != null ? item.text!.isNotEmpty : false).toList();
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (listOfLists[itemIndex].first.type ==
              NoteBlockType.dashedListHeading ||
              listOfLists[itemIndex].first.type ==
                  NoteBlockType.numberedListHeading ||
              listOfLists[itemIndex].first.type ==
                  NoteBlockType.bulletListHeading)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),

              child: Text(
                listOfLists[itemIndex].first.text.toString(),

                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

          //  itemCount: listOfLists[itemIndex].length - 1,
            itemCount:itemList.length - 1,

            itemBuilder: (context, index) {
             // List<NoteBlockModel> itemList =
              //listOfLists[itemIndex];
              int count = 0;
              return Container(
                margin: const EdgeInsets.only(top: 14),

                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),

                decoration: BoxDecoration(
                  color: Colors.grey.shade50,

                  borderRadius: BorderRadius.circular(18),

                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),

                      child: Text(
                        itemList[index + 1].type ==
                            NoteBlockType.numbered
                            ? "${index + 1}."
                            : itemList[index + 1].type ==
                            NoteBlockType.bullet
                            ? "•"
                            : "—",

                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue.shade500,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Text(
                        itemList[index + 1].text.toString(),

                        style: GoogleFonts.inter(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}