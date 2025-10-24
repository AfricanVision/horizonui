import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'Spiro/data/internal/application/TextType.dart';
import 'Spiro/designs/Component.dart';
import 'Spiro/ui/splash/Splash.dart';
import 'Spiro/utils/Colors.dart';

/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spiro App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Dashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}*/

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const AutoReceptive());
}

class AutoReceptive extends StatelessWidget {
  const AutoReceptive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //changes the system color to white on phone launch.

    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarBrightness: Brightness.light,
        ),
      );
    }

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        disabledColor: colorGrey,
        scaffoldBackgroundColor: colorPrimaryLight,
        dialogTheme: DialogThemeData(
          backgroundColor: colorPrimaryDark,
          elevation: 5,
          contentTextStyle: TextStyle(
            color: colorGrey,
            fontFamily: getTextType(TextType.Regular),
            fontSize: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          titleTextStyle: TextStyle(
            color: colorGrey,
            fontFamily: getTextType(TextType.Bold),
            fontSize: 16,
          ),
        ),
        dividerColor: colorGrey,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(colorPrimary),
        ).copyWith(error: colorReddish),
      ),
      home: const Splash(),
    );
  }
}
