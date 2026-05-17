// deleted_notes_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/note_provider.dart';

class DeletedNotesPage extends StatelessWidget {
  const DeletedNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();

    final deletedNotes = provider.deletedNotes;

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
              "Recycle Bin",

              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            Text(
              "${deletedNotes.length} deleted notes",

              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),

      body: deletedNotes.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 60,
                  color: Colors.red.shade300,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                "Recycle Bin is Empty",

                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Deleted notes will appear here.\nYou can restore them anytime.",

                textAlign: TextAlign.center,

                style: GoogleFonts.inter(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          24,
        ),

        itemCount: deletedNotes.length,

        itemBuilder: (context, index) {
          final note = deletedNotes[index];

          final formattedDate = DateFormat(
            'dd MMM yyyy, hh:mm a',
          ).format(
            DateTime.parse(
              note.deletedAt ??
                  DateTime.now().toIso8601String(),
            ),
          );

          final blocks = note.blocks;

          return Container(
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

            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Container(
                  width: 52,
                  height: 52,

                  decoration: BoxDecoration(
                    color: Colors.red.shade50,

                    borderRadius:
                    BorderRadius.circular(18),
                  ),

                  child: Icon(
                    Icons.note_alt_outlined,
                    color: Colors.red.shade300,
                  ),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Text(
                        note.title,

                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,

                        style:
                        GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight:
                          FontWeight.w700,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),

                      if (blocks.isNotEmpty &&
                          blocks.first.text !=
                              null) ...[
                        const SizedBox(height: 10),

                        Text(
                          blocks.first.text
                              .toString(),

                          maxLines: 2,
                          overflow:
                          TextOverflow.ellipsis,

                          style:
                          GoogleFonts.inter(
                            fontSize: 15,
                            height: 1.5,
                            color: Colors
                                .grey.shade700,
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

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
                                  .delete_outline_rounded,
                              size: 16,
                              color: Colors
                                  .grey.shade600,
                            ),

                            const SizedBox(
                              width: 8,
                            ),

                            Text(
                              "Deleted: $formattedDate",

                              style:
                              GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight:
                                FontWeight.w500,
                                color: Colors
                                    .grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Expanded(
                            child:
                            FilledButton.icon(
                              onPressed: () async {
                                await provider
                                    .restoreNote(
                                  note,
                                );

                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(
                                  SnackBar(
                                    behavior:
                                    SnackBarBehavior
                                        .floating,

                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                        16,
                                      ),
                                    ),

                                    content: Text(
                                      "Note restored successfully!",

                                      style:
                                      GoogleFonts
                                          .inter(),
                                    ),
                                  ),
                                );
                              },

                              icon: const Icon(
                                Icons.restore_rounded,
                              ),

                              label: Text(
                                "Restore",

                                style:
                                GoogleFonts
                                    .inter(
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                ),
                              ),

                              style:
                              FilledButton
                                  .styleFrom(
                                elevation: 0,

                                backgroundColor:
                                Colors.green
                                    .shade500,

                                foregroundColor:
                                Colors.white,

                                padding:
                                const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),

                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    18,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child:
                            OutlinedButton.icon(
                              onPressed:
                                  () async {
                                final shouldDelete =
                                await showDialog<
                                    bool>(
                                  context:
                                  context,

                                  builder:
                                      (context) {
                                    return AlertDialog(
                                      shape:
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                          24,
                                        ),
                                      ),

                                      title:
                                      Text(
                                        "Delete Permanently",

                                        style:
                                        GoogleFonts.poppins(
                                          fontWeight:
                                          FontWeight.w700,
                                        ),
                                      ),

                                      content:
                                      Text(
                                        "This action cannot be undone.",

                                        style:
                                        GoogleFonts.inter(
                                          fontSize:
                                          15,
                                          height:
                                          1.5,
                                        ),
                                      ),

                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () {
                                            Navigator.pop(
                                              context,
                                              false,
                                            );
                                          },

                                          child:
                                          Text(
                                            "Cancel",

                                            style:
                                            GoogleFonts.inter(
                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                          ),
                                        ),

                                        FilledButton(
                                          style:
                                          FilledButton.styleFrom(
                                            backgroundColor:
                                            Colors.red.shade400,

                                            shape:
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                14,
                                              ),
                                            ),
                                          ),

                                          onPressed:
                                              () {
                                            Navigator.pop(
                                              context,
                                              true,
                                            );
                                          },

                                          child:
                                          Text(
                                            "Delete",

                                            style:
                                            GoogleFonts.inter(
                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (shouldDelete ==
                                    true) {
                                  provider
                                      .permanentlyDeleteNote(
                                    note,
                                  );
                                }
                              },

                              icon: const Icon(
                                Icons
                                    .delete_forever_rounded,
                              ),

                              label: Text(
                                "Delete",

                                style:
                                GoogleFonts
                                    .inter(
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                ),
                              ),

                              style:
                              OutlinedButton
                                  .styleFrom(
                                foregroundColor:
                                Colors.red
                                    .shade400,

                                side: BorderSide(
                                  color: Colors
                                      .red.shade200,
                                ),

                                padding:
                                const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),

                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}