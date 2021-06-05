import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_theme.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'app/app_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppTheme>(
      create: (context) => AppTheme(isDarkMode: false),
      child: Consumer<AppTheme>(
        builder: (context, appTheme, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: appTheme.getTheme,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
