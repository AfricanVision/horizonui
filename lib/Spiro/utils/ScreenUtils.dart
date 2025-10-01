import 'package:flutter/cupertino.dart';

 bool isMobile(BuildContext context) =>
MediaQuery.of(context).size.width < 650;

/// tablet >= 650
 bool isTablet(BuildContext context) =>
MediaQuery.of(context).size.width >= 650;

///desktop >= 1100
 bool isDesktop(BuildContext context) =>
MediaQuery.of(context).size.width >= 1100;

Widget display(BuildContext context, Widget mobile, Widget tablet, Widget desktop){
  if(isDesktop(context)){
    return desktop;
  }else if(isTablet(context)){
    return tablet;
  }else{
    return mobile;
  }

}