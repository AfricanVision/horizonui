
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/internal/application/Severity.dart';
import 'Icons.dart';
import 'Images.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

String getTimeOfDayGreetings() {
  DateTime hour =  DateTime.now();
  String reply = "Good";

  if(hour.hour < 12){
    return "$reply Morning :)";
  }else if(hour.hour < 18){
    return "$reply Afternoon :)";
  }else{
    return "$reply Evening :)";
  }
}

String getErrorIcon(Severity severity) {

  switch(severity){
    case Severity.message:
      return messageIcon;
    case Severity.alert:
      return alertIcon;
    case Severity.error:
      return errorIcon;
    case Severity.warning:
      return warningIcon;
  }
}

Widget setVehicleImage(String image){

  if(image.isNotEmpty){
    return Image.memory(  base64Decode(image),fit: BoxFit.cover,);
  }

  return Image.asset(logoPng);
}




Widget setAdCompanyLogo(String image, double size) {

  if(image.isNotEmpty){
    return Image.memory(
      base64Decode(image),
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }

  return Image.asset(
    logoPng,
    width: size,
    height: size,
    fit: BoxFit.cover,
  );
}


Widget setVehicleMakeLogo(String image) {

  if(image.isNotEmpty){
    return Image.memory(
      base64Decode(image),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
    );
  }

  return  Image.asset(logoPng,
    width: double.infinity,
    height: double.infinity,
    fit: BoxFit.cover,);
}

String getMonthMnemonic(String month){
  if(month.length < 3){
    return "";
  }

  return month.substring(0,3);
}

bool isVowel(String word) {

  word = word.toLowerCase();

  if(word.startsWith("a") ||
      word.startsWith("e") ||
      word.startsWith("i") ||
      word.startsWith("o") ||
      word.startsWith("u")){
    return true;
  }

  return false;
}


String formatAmount(String? value){
  if(value == null){
    return "";
  }else if(value == "null") {
    return "";
  }else {

    if(_isNumeric(value)){
      RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      mathFunc(Match match) => '${match[1]},';
      String result = value.replaceAllMapped(reg, mathFunc);
      return result;
    }

    return value;
  }
}

bool _isNumeric(String str) {
  if(str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}

String imageToBase64(String path) {

  final bytes = File(path).readAsBytesSync();

  return base64Encode(bytes);
}

setProductImage(Uint8List? image, String company) {

  if (image != null) {
    return Image.memory(image,
      fit: BoxFit.fill,
      width: double.infinity,
      height: double.infinity,);
  }else if(company.isNotEmpty) {
      return Image.memory(base64Decode(company),
        fit: BoxFit.fill,
        width: double.infinity,
        height: double.infinity,);
  }

  return Image.asset(
    logoPng,
    fit: BoxFit.fill,
    width: double.infinity,
    height: double.infinity,
  );
}

double getHeightMinusSafeArea(Size size, EdgeInsets padding){
  double height = size
      .height;

  final bottomPadding = padding.bottom;

  final topPadding = padding.top;

  return height - (topPadding + bottomPadding);
}



String toTimeString(DateTime? date){
  if(date != null){
    return  DateFormat('hh:mm:ss').format(date);
  }

  return "";
}


String toDateString(DateTime? date, int option){

  if(date != null){
    if(option == 1){
      return  DateFormat('dd/MM/yyyy').format(date);
    }
    return  DateFormat('EEEE, d MMMM yyyy HH:mm:ss').format(date);

  }

  return "";
}


setImage(String image) {

  if (image.isNotEmpty) {
    return Image.memory(base64Decode(image),
      fit: BoxFit.fill,
      width: double.infinity,
      height: double.infinity,);
  }

  return Image.asset(
    logoPng,
    fit: BoxFit.fill,
    width: double.infinity,
    height: double.infinity,
  );
}
