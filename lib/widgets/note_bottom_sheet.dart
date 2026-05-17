// lib/widgets/note_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes_app/core/constants/app_colors.dart';
import 'package:simple_notes_app/core/widgets/custom_textfield.dart';

import '../models/NoteModel.dart';
import '../providers/note_provider.dart';

class NoteBottomSheet extends StatefulWidget {
  const NoteBottomSheet({super.key, required this.note, required this.index});

  final NoteModel? note;
  final int? index;

  @override
  State<NoteBottomSheet> createState() => _NoteBottomSheetState();
}

class _NoteBottomSheetState extends State<NoteBottomSheet> {
  @override
  void initState() {
    // TODO: implement initState
    final provider = context.read<NoteProvider>();
    NoteModel? myNote = widget.note;

    provider.initialisation(myNote);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,

        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,

        centerTitle: false,

        titleSpacing: 20,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.note != null
                  ? "Update Note"
                  : "Write a Note",

              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: -0.4,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              widget.note != null
                  ? "Edit your existing note"
                  : "Capture your thoughts",

              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),

        leading: Padding(
          padding: const EdgeInsets.only(left: 12),

          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },

            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),

            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
            ),
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),

            child: IconButton(
              onPressed: () {},

              style: IconButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              icon: const Icon(
                Icons.more_vert_rounded,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsetsGeometry.all(20),
                  color: Colors.white,
                  child: Column(
                    spacing: 10,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          _CustomText(
                            text: "Title",
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: AppColors.textColor,
                          ),
                          Expanded(
                            child: CustomTextField(
                              controller: provider.titleController,
                              hintText: "Enter title",
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          _CustomText(
                            text: "Heading",
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                            color: AppColors.textColor,
                          ),
                        
                          Expanded(
                            child: CustomTextField(
                              controller: provider.headingController,
                              hintText: "Enter heading",
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          _CustomText(
                            text: "Sub Heading",
                            fontWeight: FontWeight.w300,
                            fontSize: 19,
                            color: AppColors.textColor,
                          ),
                          Expanded(
                            child: CustomTextField(
                              controller: provider.subheadingController,
                              hintText: "Enter sub heading",
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          _CustomText(
                            text: "Body",
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: AppColors.textColor,
                          ),
                          Expanded(
                            child: CustomTextField(
                              controller: provider.bodyController,
                              hintText: "body",
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: provider.listOfLists.length,
                        itemBuilder: (context, i) {
                          print("index ${i}");
                          return _CustomListWidget(
                            itemIndex: i,
                            note: widget.note,
                          );
                        },
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          provider.addList(NoteBlockType.none);
                        },
                        
                        icon: const Icon(
                          Icons.add_rounded,
                          size: 22,
                        ),
                        
                        label: Text(
                          "Add List",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        style: FilledButton.styleFrom(
                          elevation: 0,
                        
                          backgroundColor: Colors.blue.shade500,
                          foregroundColor: Colors.white,
                        
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 16,
                          ),
                        
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Save button
            Container(
              width: double.infinity,
        
              decoration: BoxDecoration(
                borderRadius: BorderRadiusGeometry.only(topLeft: Radius.circular(22), topRight: Radius.circular(22)),
        
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade400,
                    Colors.blue.shade600,
                  ],
                ),
        
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200,
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
        
              child: Material(
                color: Colors.transparent,
        
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
        
                  onTap: () async {
                    await provider.createOrUpdateNote(widget.note);
        
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          widget.note != null
                              ? "Notes updated successfully!"
                              : "Note added successfully!",
                        ),
        
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
        
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    );
        
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
        
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                    ),
        
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.note != null
                              ? Icons.edit_rounded
                              : Icons.save_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
        
                        const SizedBox(width: 12),
        
                        Text(
                          widget.note != null
                              ? "Update Note"
                              : "Save Note",
        
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CustomListWidget extends StatelessWidget {
  final int itemIndex;
  final NoteModel? note;

  const _CustomListWidget({
    super.key,
    required this.itemIndex,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _CustomText(
              text: "Select list type",
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: AppColors.textColor,
            ),
            Expanded(
              child: _CustomDropDownMenu(
                setListType: provider.setListType,
                itemIndex: itemIndex,
              ),
            ),
          ],
        ),
        if (provider.listOfLists[itemIndex].first.type ==
                NoteBlockType.dashedListHeading ||
            provider.listOfLists[itemIndex].first.type ==
                NoteBlockType.numberedListHeading ||
            provider.listOfLists[itemIndex].first.type ==
                NoteBlockType.bulletListHeading)
          Row(
            spacing: 10,
            children: [
              _CustomText(
                text: "List heading",
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: AppColors.textColor,
              ),
              Expanded(
                child: CustomTextField(
                  controller: provider.listOfLists[itemIndex].first.controller,
                  hintText: "Enter list title",
                ),
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


                List<EditableBlockModel> itemList =
                    provider.listOfLists[itemIndex];
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    spacing: 15,
                    children: [
                      _CustomText(
                        text: itemList[index + 1].type == NoteBlockType.numbered
                            ? "${index + 1}"
                            : itemList[index + 1].type == NoteBlockType.bullet
                            ? "• "
                            : "⁃",
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: AppColors.textColor,
                      ),

                      Expanded(
                        child: CustomTextField(
                          controller: itemList[index + 1].controller,
                          hintText: "List item",
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (provider.listOfLists[itemIndex].first.type !=
                NoteBlockType.none)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      if (provider.listOfLists[itemIndex].first.type ==
                          NoteBlockType.numberedListHeading) {
                        provider.addItemsToList(
                          NoteBlockType.numbered,
                          itemIndex,
                        );
                      } else if (provider.listOfLists[itemIndex].first.type ==
                          NoteBlockType.dashedListHeading) {
                        provider.addItemsToList(
                          NoteBlockType.dashedList,
                          itemIndex,
                        );
                      } else {
                        provider.addItemsToList(
                          NoteBlockType.bullet,
                          itemIndex,
                        );
                      }
                    },
                    icon: Icon(Icons.add, color: Colors.blueAccent,),
                    label: _CustomText(
                      text: "Add list item",
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.blueAccent,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      provider.removeListItem(itemIndex);
                    },
                    icon: Icon(Icons.remove, color: Colors.redAccent,),
                    label: _CustomText(
                      text: "Remove list item",
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {
                provider.removeCurrentList(itemIndex);
              },

              icon: Icon(
                Icons.delete_outline_rounded,
                color: Colors.red.shade400,
                size: 18,
              ),

              label: Text(
                "Remove List",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red.shade400,
                ),
              ),

              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CustomText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final Color color;

  const _CustomText({
    super.key,
    required this.text,
    required this.fontWeight,
    required this.fontSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}

class _CustomDropDownMenu extends StatelessWidget {
  final Function setListType;
  final int itemIndex;

  const _CustomDropDownMenu({
    super.key,
    required this.setListType,
    required this.itemIndex,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<int>(
      width: 220,

      textStyle: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),

      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),

        elevation: const WidgetStatePropertyAll(4),

        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 8),
        ),

        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),

        hintStyle: GoogleFonts.inter(
          fontSize: 15,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w500,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),

      trailingIcon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey.shade700,
        size: 24,
      ),

      selectedTrailingIcon: Icon(
        Icons.keyboard_arrow_up_rounded,
        color: Colors.blue.shade400,
        size: 24,
      ),

      label: Text(
        "Select List Type",
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),

      onSelected: (value) {
        setListType(value, itemIndex);
      },

      dropdownMenuEntries: [
        DropdownMenuEntry(
          value: 1,
          label: "Bullet List",
          leadingIcon: Icon(Icons.format_list_bulleted_rounded, size: 20),
        ),

        DropdownMenuEntry(
          value: 2,
          label: "Numbered List",
          leadingIcon: Icon(Icons.format_list_numbered_rounded, size: 20),
        ),

        DropdownMenuEntry(
          value: 3,
          label: "Dashed List",
          leadingIcon: Icon(Icons.remove_rounded, size: 20),
        ),
      ],
    );
  }
}
