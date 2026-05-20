// lib/pages/notes_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/NoteModel.dart';
import '../providers/note_provider.dart';
import 'note_bottom_sheet.dart';
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

    final provider = context.read<NoteProvider>();

    provider.listenToNotes();
    provider.listenToDeletedNotes();
  }

  void openBottomSheet({
    dynamic note,
    int? index,
  }) {

    Navigator.push(context, MaterialPageRoute(builder: (context)=>  NoteBottomSheet(
      note: note,
      index: index,
    )));

  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();

    final notes = noteProvider.notes;

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
              "My Notes",

              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            Text(
              "${notes.length} notes available",

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
            padding: const EdgeInsets.only(right: 16),

            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DeletedNotesPage(),
                  ),
                );
              },

              style: IconButton.styleFrom(
                backgroundColor: Colors.red.shade50,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
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

      body: notes.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  Icons.note_alt_outlined,
                  size: 60,
                  color: Colors.blue.shade400,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                "No Notes Yet",

                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Start writing your ideas,\nthoughts and tasks.",

                textAlign: TextAlign.center,

                style: GoogleFonts.inter(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 32),

              FilledButton.icon(
                onPressed: () {
                  openBottomSheet();
                },

                icon: const Icon(
                  Icons.add_rounded,
                ),

                label: Text(
                  "Create Note",

                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                style: FilledButton.styleFrom(
                  elevation: 0,

                  backgroundColor: Colors.blue.shade500,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 18,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          20,
          8,
          20,
          100,
        ),

        itemCount: notes.length,

        itemBuilder: (context, index) {
          final note = notes[index];
          String getTitle(NoteModel note){
            
            if(note.title.isNotEmpty) {
              return note.title;
            } else{
              for(var item in note.blocks){
                if(item.text!= null && item.text!.isNotEmpty){
                  return item.text!;
                }
              }
            }
            return "";
          }

          return GestureDetector(
            onTap: () {
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

            child: Container(
              margin: const EdgeInsets.only(bottom: 18),

              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(28),

                border: Border.all(
                  color: Colors.grey.shade200,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [
                            Text(
                              getTitle(note),

                              maxLines: 2,
                              overflow:
                              TextOverflow.ellipsis,

                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight:
                                FontWeight.w700,
                                color:
                                Colors.black87,
                                height: 1.3,
                              ),
                            ),

                            const SizedBox(height: 14),

                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),

                              decoration: BoxDecoration(
                                color:
                                Colors.grey.shade100,

                                borderRadius:
                                BorderRadius.circular(
                                  14,
                                ),
                              ),

                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,

                                children: [
                                  Icon(
                                    Icons
                                        .schedule_rounded,
                                    size: 16,
                                    color: Colors
                                        .grey.shade600,
                                  ),

                                  const SizedBox(
                                    width: 8,
                                  ),

                                  Text(
                                    DateFormat(
                                      'dd MMM yyyy, hh:mm a',
                                    ).format(
                                      DateTime.parse(
                                        note.createdAt,
                                      ),
                                    ),

                                    style:
                                    GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors
                                          .grey.shade700,
                                      fontWeight:
                                      FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 14),

                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      NoteBottomSheet(
                                        note: note,
                                        index: index,
                                      ),
                                ),
                              );
                            },

                            style:
                            IconButton.styleFrom(
                              backgroundColor:
                              Colors.blue.shade50,

                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  14,
                                ),
                              ),
                            ),

                            icon: Icon(
                              Icons.edit_rounded,
                              size: 20,
                              color:
                              Colors.blue.shade500,
                            ),
                          ),

                          const SizedBox(height: 10),

                          IconButton(
                            onPressed: () async {
                              final shouldDelete =
                              await showDialog<bool>(
                                context: context,

                                builder: (context) {
                                  return AlertDialog(
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                        24,
                                      ),
                                    ),

                                    title: Text(
                                      "Delete Note",

                                      style:
                                      GoogleFonts
                                          .poppins(
                                        fontWeight:
                                        FontWeight
                                            .w700,
                                      ),
                                    ),

                                    content: Text(
                                      "Are you sure you want to delete this note?",

                                      style:
                                      GoogleFonts
                                          .inter(
                                        fontSize: 15,
                                        height: 1.5,
                                      ),
                                    ),

                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                            context,
                                            false,
                                          );
                                        },

                                        child: Text(
                                          "Cancel",

                                          style:
                                          GoogleFonts
                                              .inter(
                                            fontWeight:
                                            FontWeight
                                                .w600,
                                          ),
                                        ),
                                      ),

                                      FilledButton(
                                        style:
                                        FilledButton
                                            .styleFrom(
                                          backgroundColor:
                                          Colors.red
                                              .shade400,

                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),

                                        onPressed: () {
                                          Navigator.pop(
                                            context,
                                            true,
                                          );
                                        },

                                        child: Text(
                                          "Delete",

                                          style:
                                          GoogleFonts
                                              .inter(
                                            fontWeight:
                                            FontWeight
                                                .w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (shouldDelete ==
                                  true) {
                                noteProvider.deleteNote(
                                  note,
                                );
                              }
                            },

                            style:
                            IconButton.styleFrom(
                              backgroundColor:
                              Colors.red.shade50,

                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  14,
                                ),
                              ),
                            ),

                            icon: Icon(
                              Icons
                                  .delete_outline_rounded,
                              size: 20,
                              color:
                              Colors.red.shade400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,

        backgroundColor: Colors.blue.shade500,
        foregroundColor: Colors.white,

        onPressed: () {
          openBottomSheet();
        },

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        icon: const Icon(
          Icons.add_rounded,
        ),

        label: Text(
          "New Note",

          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}