import 'package:flutter/material.dart';
import 'Validators.dart';


FormFieldValidator<String> textInputValidator(int option) {
  return (String? value) {

    value = value ?? "";

    if (option == 1) {
      if(value.isEmpty){
        return "This field is required.";
      }else if (value.length <= 6) {
        return "Invalid value.";
      }
    }
    if (option == 2) {
      if(value.isEmpty){
        return "This field is required.";
      }else if (value.length <= 4) {
        return "Invalid value.";
      }
    }
    if (option == 3) {
      if(value.isNotEmpty){
         if (value.length <= 6) {
           return "Invalid value.";
         }
      }
    }
    return null;
  };
}


FormFieldValidator<DateTime> dateTimeValidator(int option) {
  return (DateTime? value) {

    if(value == null){
      return "This field is required.";
    }

    return null;
  };
}


/*FormFieldValidator<PhoneNumber> phoneInputValidator(int option) {
  return (PhoneNumber? value) {

    if(option == 1) {
      if (value == null) {
        return "This field is required.";
      }else{
        if(value.nsn.isNotEmpty){
            if(!value.isValid()){
              return "Kindly enter a valid:  +${value.countryCode} (${value.isoCode.name}) mobile number.";
            }
        }else{
          return "Kindly enter a phone number.";
        }
      }
    }else if(option == 2){
      if(value != null) {
        if (value.nsn.isNotEmpty) {
          if(!value.isValid()){
            return "Kindly enter a valid:  +${value.countryCode} (${value.isoCode.name}) mobile number.";
          }
        }
      }
    }

    return null;
  };
}*/
