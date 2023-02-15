import 'package:flutter/material.dart';
import 'package:notepad/home_screen.dart';
import 'package:notepad/Utility/theme_change_provider.dart';
import 'package:notepad/splash_screen.dart';
import 'package:provider/provider.dart';

import 'Utility/note_provider.dart';
import 'notification_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); //
  // await NotificationService().requestIOSPermissions(); //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // final GlobalKey<NavigatorState> navigatorKey =
  // GlobalKey(debugLabel: "Main Navigator"); //


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
              // navigatorKey: navigatorKey,
                  title: 'Flutter Demo',
                  themeMode: themechanger.thememode ,
                  theme: ThemeData(
                    brightness: Brightness.light,
                  primarySwatch: Colors.grey
                  ),
                  darkTheme: ThemeData(
                    brightness: Brightness.dark
                  ),
                  home: const HomeScreen(),
                  debugShowCheckedModeBanner: false,
                  );
                  },),);
  }
}
