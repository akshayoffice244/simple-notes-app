import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes_app/pages/notes_page.dart';
import 'package:simple_notes_app/providers/note_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => NoteProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: NotesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
