import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme extends ChangeNotifier {
  ThemeData _selectedTheme;

  void swapTheme() {
    if (_selectedTheme == dark()) {
      _selectedTheme = light();
    } else {
      _selectedTheme = dark();
    }
    notifyListeners();
  }

  AppTheme({bool isDarkMode}) {
    _selectedTheme = isDarkMode ? dark() : light();
  }

  ThemeData light() {
    final textTheme = _getTextTheme(brightness: Brightness.light);

    return ThemeData(
      primaryColor: Colors.red,
      accentColor: Colors.black,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
    );
  }

  ThemeData dark() {
    final textTheme = _getTextTheme(brightness: Brightness.dark);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      accentColor: Colors.white,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
    );
  }

  ThemeData get getTheme => _selectedTheme;

  static _getTextTheme({@required Brightness brightness}) {
    final themeData = ThemeData(brightness: brightness);

    return GoogleFonts.exo2TextTheme(themeData.textTheme).copyWith(
      headline1: GoogleFonts.lato(),
      headline2: GoogleFonts.lato(),
      headline3: GoogleFonts.lato(),
      headline4: GoogleFonts.lato(),
      headline5: GoogleFonts.lato(),
      headline6: GoogleFonts.lato(),
    );
  }
}
