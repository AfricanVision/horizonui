
import 'package:flutter/services.dart';

bool sentenceCaseRegex(String value){
  return !RegExp(r'^[A-Z]').hasMatch(value);
}

bool emailRegex(String value){
  return !RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(value);
}

bool isDouble(String value){
  if(value.isEmpty) {
    return false;
  }
  return double.tryParse(value) != null;
}

bool isNumerical(String value){
  if(value.isEmpty) {
    return false;
  }
  return int.tryParse(value) != null;
}

bool passwordRegex(String value){
  return !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*_= -]).{8,12}$').hasMatch(value);
}

bool websiteRegex(String value){
  return !RegExp(
      r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?").hasMatch(value);
}

FilteringTextInputFormatter noSpaceInputFormatter(){
  return FilteringTextInputFormatter.deny(RegExp(r"\s"));
}

TextInputFormatter numbersInputFormatter(){
  return FilteringTextInputFormatter.digitsOnly;
}
TextInputFormatter upperCaseInputFormatter(){
  return FilteringTextInputFormatter.allow(RegExp(r"([A-Z])|([0-9])|(-)|(_)"));
}
