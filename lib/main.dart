
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:local_notifier/local_notifier.dart';
import 'Spiro/about/internal/application/TextType.dart';
import 'Spiro/configs/LocalNotificationEngine.dart';
import 'Spiro/designs/Component.dart';
import 'Spiro/see/splash/Splash.dart';
import 'Spiro/utils/Colors.dart';
import 'dart:io' show Platform;
import 'package:bitsdojo_window/bitsdojo_window.dart';


void main() async{

  await dotenv.load(fileName: ".env");

  if(Platform.isWindows || Platform.isMacOS || Platform.isLinux){

    doWhenWindowReady(() {
      final win = appWindow;
      final windowDepth = Size(win.size.width.toDouble(),(win.size.height.toDouble()-50));
      win.minSize = windowDepth;
      win.size = windowDepth;
      win.alignment = Alignment.center;
      win.title = "Spiro";
      win.maximize();
      win.show();
    });
  }


  if(Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    await localNotifier.setup(
      appName: 'Spiro',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
  }

  await LocalNotificationEngine().init();

  runApp(const Spiro());

}



class Spiro extends StatelessWidget {

  const Spiro({super.key});

  @override
  Widget build(BuildContext context) {

    //changes the system color to white on phone launch.

    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarBrightness: Brightness.light,
      ));
    }


    return MaterialApp(
      builder: (context,children) {
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.6, 1.1)), child: children!);
      },
      theme: ThemeData(
          disabledColor: colorGrey,
          scaffoldBackgroundColor: colorPrimaryLight,
          splashFactory: InkRipple.splashFactory,
          bottomSheetTheme: BottomSheetThemeData(
              dragHandleColor: colorPrimaryDark
          ),
          dialogTheme: DialogTheme(
            backgroundColor: colorMilkWhite,
            elevation: 5,
            contentTextStyle: TextStyle(
              color: colorGrey,
              fontFamily: getTextType(TextType.Regular),
              fontSize: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            titleTextStyle:TextStyle(
              color: colorGrey,
              fontFamily: getTextType(TextType.Bold),
              fontSize: 16,
            ),
          ),
          dividerColor: colorGrey, colorScheme: ColorScheme.fromSwatch(primarySwatch: createMaterialColor(colorPrimary)).copyWith(error: colorPrimary)


      ),
      home: const Splash(),
    );
  }
}

