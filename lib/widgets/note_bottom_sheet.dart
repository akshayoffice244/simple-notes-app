// lib/widgets/note_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        title: Text(widget.note != null ? "Update" : "Write a note"),
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsetsGeometry.all(20),
                color: Colors.white,
                child: Column(
                  spacing: 10,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Text("Title"),
                        Expanded(
                          child: TextField(
                            controller: provider.titleController,
                            onChanged: (value) {
                              print("inside list title heading");
                            },
                            decoration: InputDecoration(
                              hintText: "Enter title",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Text("Heading"),
                        Expanded(
                          child: TextField(
                            controller: provider.headingController,
                            onChanged: (value) {
                              print("inside list title heading");
                            },
                            decoration: InputDecoration(
                              hintText: "Enter heading",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Text("sub Heading"),
                        Expanded(
                          child: TextField(
                            controller: provider.subheadingController,
                            onChanged: (value) {
                              print("inside list title heading");
                            },
                            decoration: InputDecoration(
                              hintText: "Enter sub heading",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Text("Body"),
                        Expanded(
                          child: TextField(
                            controller: provider.bodyController,
                            onChanged: (value) {
                              print("inside list title heading");
                            },
                            decoration: InputDecoration(
                              hintText: "Enter body",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
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
                        return _CustomListWidget(itemIndex: i, note: widget.note);
                      },
                    ),
                    FilledButton(
                      onPressed: () {
                        provider.addList(NoteBlockType.none);
                        print("listoflist ${provider.listOfLists.length}");
                        print("Clicked add list");
                      },
                      child: Text("Add List"),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () async {
                  await provider.createOrUpdateNote(widget.note);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:  Text( widget.note != null ? "Notes updated successfully!" : "Note added successfully!"),
                      behavior: SnackBarBehavior.floating, // Makes it float like a toast
                      duration: const Duration(seconds: 2), // Auto-dismisses
                      width: 280, // Restricts width to mimic a small toast bubble
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text("Save Note"),
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
  final NoteModel? note;
  const _CustomListWidget({super.key, required this.itemIndex,required this.note});

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
            Text("List Type"),

            DropdownMenu(
              // This single property handles stretching both the input bar AND the popup menu list
              onSelected: (value) {
                provider.setListType(value, itemIndex);
              },
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    //     color: AppColors.borderColor,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    // color: AppColors.borderColor,
                    width: 1,
                  ),
                ),
              ),
              menuStyle: MenuStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      width: 1,
                      // color: AppColors.borderColor,
                    ),
                  ),
                ),
              ),
              label: Text("Select List Type"),
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 1, label: "bullet"),
                DropdownMenuEntry(value: 2, label: "numberList"),
                DropdownMenuEntry(value: 3, label: "dashedList"),
              ],
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
            children: [
              Text("List heading:"),
              Expanded(
                child: TextField(
                  controller: provider.listOfLists[itemIndex].first.controller,
                  onChanged: (value) {

                  },
                  decoration: InputDecoration(
                    hintText: "Enter list title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
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
                NoteBlockType type = provider.listOfLists[itemIndex].first.type;
                int i = 0;
                late Widget widget;
                if (type == NoteBlockType.numberedListHeading)
                  widget = Text("${i++} ");
                else if (type == NoteBlockType.bulletListHeading)
                  widget = Text("• ");
                else
                  widget = Text("- ");
                i++;

                List<EditableBlockModel> itemList =
                    provider.listOfLists[itemIndex];
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
                        child: TextField(
                          controller: itemList[index + 1].controller,
                          onChanged: (value) {
                            print(itemList[index + 1].controller.text);
                          },
                          decoration: InputDecoration(
                            hintText: "Enter list text",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () {
                print("itemIndex ${itemIndex}");
                provider.removeCurrentList(itemIndex);
              },
              child: Text("Remove List"),
            ),
          ],
        ),
        SizedBox(height: 10),
        if (provider.listOfLists[itemIndex].first.type != NoteBlockType.none)
          Row(
            children: [
              TextButton(
                onPressed: () {
                  if (provider.listOfLists[itemIndex].first.type ==
                      NoteBlockType.numberedListHeading) {
                    provider.addItemsToList(NoteBlockType.numbered, itemIndex);
                  } else if (provider.listOfLists[itemIndex].first.type ==
                      NoteBlockType.dashedListHeading) {
                    provider.addItemsToList(
                      NoteBlockType.dashedList,
                      itemIndex,
                    );
                  } else {
                    provider.addItemsToList(NoteBlockType.bullet, itemIndex);
                  }
                  print("Item was added");
                },
                child: Text("Add List item"),
              ),
              TextButton(
                onPressed: () {
                  provider.removeListItem(itemIndex);
                },
                child: Text("Delete list item"),
              ),
            ],
          ),
      ],
    );
  }


}
