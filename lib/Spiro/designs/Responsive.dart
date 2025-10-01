import 'package:flutter/cupertino.dart';
import '../about/internal/application/TextType.dart';
import 'Component.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  const Responsive({
    super.key,
    required this.desktop,
    required this.mobile,
    required this.tablet,
  });

  /// mobile < 650
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 650;

  /// tablet >= 650
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 650;

  ///desktop >= 1100
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (isDesktop(context)) {
        return desktop;
      } else if (isTablet(context)) {
        return tablet;
      } else if(isMobile(context)){
        return mobile;
      }else{
        return SizedBox(width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          text("NOT SUPPORTED",12, TextType.Bold)
        ],),);
      }
    });
  }
}