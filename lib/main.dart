import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'components/my_colors.dart';
import 'screens/main_page.dart';

void main() {
  runApp(AppAgenda());
}

class AppAgenda extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('pt'), // Hebrew
      ],
      theme: ThemeData(
        primaryColor: MyColors().blue,
        accentColor: MyColors().green,
        buttonTheme: ButtonThemeData(
          buttonColor: MyColors().blue,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: MainPage(),
    );
  }
}