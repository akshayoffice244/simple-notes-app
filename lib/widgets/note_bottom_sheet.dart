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
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Edit note")),
        body:SafeArea(
          child: SingleChildScrollView(
            child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: provider.listOfLists.length,
                            itemBuilder: (context, i) {
                              return _CustomListWidget(itemIndex: i);
                            },
                          ),
                        ),
                      ],
                    ),
                    FilledButton(
                      onPressed: () {
                        provider.addList(NoteBlockType.none);
                      },
                      child: Text("Add List"),
                    ),
                  ],
                ),
              )
            ],
                  ),
          ),
        ),

    );
  }
}

class _CustomListWidget extends StatelessWidget {
  final int itemIndex;

  const _CustomListWidget({super.key, required this.itemIndex});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();



    return Column(
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
                  widget = Text("${i} ");
                else if (type == NoteBlockType.bulletListHeading)
                  widget = Text("0 ");
                else
                  widget = Text("- ");
                i++;
                return Row(
                  children: [
                    widget,
                    Expanded(
                      child: TextField(

                        decoration: InputDecoration(
                          hintText: "Enter list text",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        if (provider.listOfLists[itemIndex].first.type != NoteBlockType.none)
        TextButton(onPressed: () {
          if(provider.listOfLists[itemIndex].first.type == NoteBlockType.numberedListHeading) {
            provider.addItemsToList(NoteBlockType.numbered, itemIndex);
          }
          else if(provider.listOfLists[itemIndex].first.type == NoteBlockType.dashedListHeading) {
            provider.addItemsToList(NoteBlockType.dashedList, itemIndex);
          }
          else  {
            provider.addItemsToList(NoteBlockType.bullet, itemIndex);
          }
          print("Item was added");
        }, child: Text("Add List item")),
      ],
    );
  }
}
