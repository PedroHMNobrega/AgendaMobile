import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/tasks_page.dart';

void main() {
  runApp(appAgenda());
}

class appAgenda extends StatelessWidget {
  static Color green = Colors.green[600];
  static Color blue = Colors.blue[900];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('pt'), // Hebrew
      ],
      theme: ThemeData(
        primaryColor: blue,
        accentColor: green,
        buttonTheme: ButtonThemeData(
          buttonColor: blue,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: TasksPage(),
    );
  }
}