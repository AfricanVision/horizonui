import 'package:flutter/material.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

//Main Color Scheme
const colorWhite = const Color(0xffffffff);
const colorPrimary = const Color(0xFFDE602E);
const colorPrimaryDark = const Color(0xFF171717);
const colorPrimaryDark2 = const Color(0xFF262525);

const colorPrimaryLight = const Color(0xFFEBEDF2);
const colorPrimaryLight2 = const Color(0xFFF0F0F0);

const colorAccent = const Color(0xFFF54327);
const colorMilkWhite = const Color(0xFFD6D5C9);
const colorWhite1 = const Color(0x99FFFFFF);
const colorWhite2 = const Color(0xFFCECDCF);

const colorPrimaryAccent = const Color(0xFFb84841);

const colorSecondary = const Color(0xFF707070);

const colorGreen = Color(0xFF00D100);

const colorPositive = const Color(0xFF366f81);
const colorNegative = const Color(0xFFC70A0D);
const colorGrey = const Color(0xFFA8A8A8);
const colorGrey2 = const Color(0xFF707070);
const colorTinted = const Color(0xFFffaf80);
const colorWarmYellow = const Color(0xFFedd612);
const colorReddish = const Color(0xFFC70A0D);
const shawnblue = const Color(0xFF2962FF);

Color getColorFromHex(String hexColor) {
  if (hexColor.isEmpty || hexColor.length <= 6) {
    hexColor = "#000000";
  }

  hexColor = hexColor.toUpperCase().replaceAll("#", "");

  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }

  try {
    return Color(int.parse(hexColor, radix: 16));
  } catch (e) {
    return colorPrimaryDark;
  }
}
