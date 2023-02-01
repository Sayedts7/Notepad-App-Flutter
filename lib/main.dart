import 'package:flutter/material.dart';
import 'package:notepad/home_screen.dart';
import 'package:notepad/splash_screen.dart';
import 'package:notepad/theme_change_provider.dart';
import 'package:notepad/theme_change_provider.dart';
import 'package:notepad/theme_change_provider.dart';
import 'package:notepad/theme_change_provider.dart';
import 'package:provider/provider.dart';

import 'note_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(
        create: (_)=> NoteProvider()),

    ChangeNotifierProvider(create: (_)=> ThemeChanger(),

            )


        ],
        child: Builder(builder: (BuildContext context){
          final themechanger = Provider.of<ThemeChanger>(context);
            return MaterialApp(
                  title: 'Flutter Demo',
                  themeMode: themechanger.thememode ,
                  theme: ThemeData(
                    brightness: Brightness.light,
                  primarySwatch: Colors.grey,
                  ),
                  darkTheme: ThemeData(
                    brightness: Brightness.dark
                  ),
                  home: const Splash(),
                  debugShowCheckedModeBanner: false,
                  );
                  },),);
  }
}
