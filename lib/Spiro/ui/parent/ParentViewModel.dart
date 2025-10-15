import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/internal/application/NotificationType.dart';
import '../../data/internal/application/Severity.dart';
import '../../data/internal/application/SpiroError.dart';
import '../../data/internal/application/TextType.dart';
import '../../data/internal/file/FileStorage.dart';
import '../../data/internal/memory/InternalMemory.dart';
import '../../designs/Component.dart';
import '../../endpoints/Comms.dart';
import '../../informatics/AppDataManager.dart';
import '../../informatics/DataManager.dart';
import '../../utils/Colors.dart';

class ParentViewModel extends ChangeNotifier {
  OverlayEntry? loadingEntry;

  OverlayEntry? networkEntry;

  OverlayEntry? errorEntry;

  late DataManager dataManager;

  BuildContext context;

  OverlayState? overlayState;

  ParentViewModel(this.context) {
    overlayState = Overlay.of(context);
    dataManager = AppDataManager(
      InternalMemory(),
      Comms(InternalMemory()),
      FileStorage(),
    );
  }

  DataManager getDataManager() {
    return dataManager;
  }

  void showLoading(String loadingText) async {
    if (loadingEntry == null) {
      _hideKeyboard();
      loadingEntry = OverlayEntry(
        builder: (context) {
          return Scaffold(
            backgroundColor: colorPrimaryDark.withOpacity(0.95),
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SpinKitWaveSpinner(
                        color: colorPrimary,
                        waveColor: colorPrimary.withOpacity(0.5),
                        size: 120,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 40),
                        child: textWithColor(
                          loadingText,
                          24,
                          TextType.Regular,
                          colorPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

      overlayState?.insert(loadingEntry!);
      notifyListeners();
    }
  }

  showApplicationNotification(
    NotificationType type,
    String title,
    String description,
    bool enableDrag,
    bool barrierDismiss,
    popParam,
    VoidCallback? closeAction,
  ) async {
    Color actionColor = colorPrimary;

    double size = 100;

    Icon actionIcon = Icon(
      Icons.done_all_rounded,
      color: Colors.orange,
      size: size,
    );

    switch (type) {
      case NotificationType.success:
        actionIcon = Icon(
          Icons.done_all_rounded,
          color: colorTinted,
          size: size,
        );
        actionColor = colorTinted;
        break;
      case NotificationType.info:
        actionIcon = Icon(
          Icons.info_outline_rounded,
          color: colorPositive,
          size: size,
        );
        actionColor = colorPositive;
        break;
      case NotificationType.warning:
        actionIcon = Icon(
          Icons.warning_rounded,
          color: colorAccent,
          size: size,
        );
        actionColor = colorAccent;
        break;
      case NotificationType.error:
        actionIcon = Icon(
          Icons.error_outline,
          color: colorNegative,
          size: size,
        );
        actionColor = colorNegative;
        break;
      default:
        actionColor = colorPrimary;
        actionIcon = Icon(
          Icons.done_all_rounded,
          color: colorPrimary,
          size: size,
        );
        break;
    }

    await showModalBottomSheet(
      context: context,
      barrierColor: colorPrimaryDark.withOpacity(0.8),
      backgroundColor: colorWhite,
      elevation: 3,
      enableDrag: enableDrag,
      isDismissible: barrierDismiss,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.7,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          actionIcon,
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: textWithColor(
                              type.name.toUpperCase(),
                              28,
                              TextType.SemiBold,
                              actionColor,
                            ),
                          ),
                        ],
                      ),

                      backButtonWithActionAndIcon(
                        CupertinoIcons.clear,
                        context,
                        () {
                          if (popParam != null) {
                            Navigator.pop(context, popParam);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        textWithColor(
                          title,
                          18,
                          TextType.SemiBold,
                          colorPrimaryDark,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: textWithColor(
                            description,
                            12,
                            TextType.Regular,
                            colorPrimaryDark2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(closeAction!);
  }

  showApplicationNotificationWithAction(
    NotificationType type,
    String title,
    String description,
    String action,
    bool draggable,
    bool barrierDismiss,
    VoidCallback? positiveAction,
    VoidCallback? cancelAction,
  ) async {
    Color actionColor = colorPrimary;

    double size = 100;

    Icon actionIcon = Icon(
      Icons.done_all_rounded,
      color: Colors.orange,
      size: size,
    );

    switch (type) {
      case NotificationType.success:
        actionIcon = Icon(
          Icons.done_all_rounded,
          color: colorTinted,
          size: size,
        );
        actionColor = colorTinted;
        break;
      case NotificationType.info:
        actionIcon = Icon(
          Icons.info_outline_rounded,
          color: colorPositive,
          size: size,
        );
        actionColor = colorPositive;
        break;
      case NotificationType.warning:
        actionIcon = Icon(
          Icons.warning_rounded,
          color: colorAccent,
          size: size,
        );
        actionColor = colorAccent;
        break;
      case NotificationType.error:
        actionIcon = Icon(
          Icons.error_outline,
          color: colorNegative,
          size: size,
        );
        actionColor = colorNegative;
        break;
      default:
        actionColor = colorPrimary;
        actionIcon = Icon(
          Icons.done_all_rounded,
          color: colorPrimary,
          size: size,
        );
        break;
    }

    await showModalBottomSheet(
      context: context,
      barrierColor: colorPrimaryDark.withOpacity(0.8),
      backgroundColor: colorWhite2,
      elevation: 3,
      enableDrag: draggable,
      isDismissible: barrierDismiss,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.7,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          actionIcon,
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: textWithColor(
                              type.name.toUpperCase(),
                              28,
                              TextType.SemiBold,
                              actionColor,
                            ),
                          ),
                        ],
                      ),

                      backButtonWithActionAndIcon(
                        CupertinoIcons.clear,
                        context,
                        cancelAction,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        textWithColor(
                          title,
                          18,
                          TextType.SemiBold,
                          colorPrimaryDark,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: textWithColor(
                            description,
                            12,
                            TextType.Regular,
                            colorPrimaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: raisedButton(action, positiveAction),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void noNetwork(Function() actions) async {
    if (networkEntry == null) {
      _hideKeyboard();
      networkEntry = OverlayEntry(
        builder: (context) {
          return Scaffold(
            backgroundColor: colorPrimaryDark.withOpacity(0.95),
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.wifi_exclamationmark,
                      size: 16,
                      color: colorPrimary,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 40,
                        bottom: 40,
                        left: 40,
                        right: 40,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          textWithColor(
                            "Oops, No Internet Connections",
                            30,
                            TextType.Bold,
                            colorPrimaryLight,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: textWithColor(
                              "Kindly make sure that your wifi or cellular data are turned on and try again.",
                              14,
                              TextType.Light,
                              colorPrimaryLight,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: raisedButton("Retry", actions),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

      overlayState?.insert(networkEntry!);
      notifyListeners();
    }
  }

  Future<bool> hasNetwork(Function() actions) async {
    closeLoading();

    List<ConnectivityResult> resultList = await (Connectivity()
        .checkConnectivity());

    ConnectivityResult connectivityResult = ConnectivityResult.none;

    if (resultList.isNotEmpty) {
      connectivityResult = resultList.first;
    }

    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return true;
    } else {
      noNetwork(actions);
      return false;
    }
  }

  handleError(
    Object? error,
    Function() actions,
    Function() closeAction,
    String buttonName,
  ) {
    closeLoading();

    if (error is DioException) {
      DioException dioError = error;

      if (error.type == DioExceptionType.connectionTimeout) {
        showError(
          actions,
          closeAction,
          SpiroError(
            code: 5000.01,
            message: "An error occurred while processing you request.",
            helper: "Kindly ensure that you have a stable internet connection.",
            title: "Spiro Error",
            severity: Severity.message.name,
          ),
          buttonName,
        );
      } else if (error.type == DioExceptionType.receiveTimeout) {
        showError(
          actions,
          closeAction,
          SpiroError(
            code: 5000.02,
            message: "An error occurred while processing you request.",
            helper: "Kindly ensure that you have a stable internet connection.",
            title: "Spiro Error",
            severity: Severity.message.name,
          ),
          buttonName,
        );
      } else if (dioError.response?.statusCode == 401) {
      } else if (dioError.response?.statusCode == 403) {
        showError(
          actions,
          closeAction,
          SpiroError(
            code: 5100.00,
            message:
                "An connection error occurred while processing your request. Usually a result of your network (Wifi) security blocking outgoing / incoming request",
            helper:
                "Try using your mobile data or switching to a different network outside your current organisational limit.",
            title: "Spiro Error",
            severity: Severity.message.name,
          ),
          buttonName,
        );
      } else if (dioError.response?.statusCode == 413) {
        showError(
          actions,
          closeAction,
          getSpiroError(dioError.response?.data),
          buttonName,
        );
      } else if (dioError.response?.statusCode == 500) {
        SpiroError error = getSpiroError(dioError.response?.data);

        if (error.code == 56098.001) {
        } else if (error.code == 1000.0001 ||
            error.code == 1200.0012 ||
            error.code == 900.009 ||
            error.code == 5000.0005) {
          verifyCompanyState(error.code);
        } else if (error.code == 1559800.091001) {
        } else if (error.code == 1559800.091002) {
        } else {
          showError(actions, closeAction, error, buttonName);
        }
      } else {
        showError(
          actions,
          closeAction,
          SpiroError(
            code: 5500.02,
            message: "An error occurred while processing you request.",
            helper:
                "Kindly relaunch the application and try again and if problem persist kindly contact us.",
            title: "Spiro Error",
            severity: Severity.message.name,
          ),
          buttonName,
        );
      }
    } else if (error is Exception) {
      showError(
        actions,
        closeAction,
        SpiroError(
          code: 6000.01,
          message: "An error occurred while processing you request.",
          helper:
              "Kindly relaunch the application and try again and if problem persist kindly contact us.",
          title: "Spiro Error",
          severity: Severity.message.name,
        ),
        buttonName,
      );
    } else if (error is int) {
      showError(
        actions,
        closeAction,
        SpiroError(
          code: 6000.02,
          message: "An error occurred while processing you request.",
          helper:
              "Kindly relaunch the application/reinstall the application or retry below and if problem persist kindly contact us.",
          title: "Spiro Error",
          severity: Severity.message.name,
        ),
        buttonName,
      );
    } else {
      showError(
        actions,
        closeAction,
        SpiroError(
          code: 8700.02,
          message: "An error occurred while processing you request.",
          helper:
              "Kindly relaunch the application and try again and if problem persist kindly contact us.",
          title: "Spiro Error",
          severity: Severity.message.name,
        ),
        buttonName,
      );
    }
  }

  void verifyCompanyState(double code) {
    if (code == 1000.0001) {
    } else if (code == 1200.0012) {
      //spiroNavigation().navigateToPage(NavigatorType.makeNewMain, const CompanyOutstanding(), context);
    } else if (code == 900.009) {
      //todo code means delete something on company.
    } else if (code == 5000.0005) {
      //todo code means update something on company.
    }
  }

  closeLoading() {
    if (loadingEntry != null) {
      loadingEntry?.remove();
      loadingEntry = null;
      notifyListeners();
    }
  }

  closeNetwork() {
    if (networkEntry != null) {
      networkEntry?.remove();
      networkEntry = null;
      notifyListeners();
    }
  }

  dismissError() {
    if (errorEntry != null) {
      errorEntry?.remove();
      errorEntry = null;
      notifyListeners();
    }
  }

  void showError(
    Function() actions,
    Function() closeActions,
    SpiroError error,
    String buttonText,
  ) async {
    if (errorEntry == null) {
      _hideKeyboard();
      errorEntry = OverlayEntry(
        builder: (context) {
          return Scaffold(
            backgroundColor: colorPrimaryLight,
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewportConstraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                    minWidth: viewportConstraints.maxWidth,
                  ),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 32,
                              bottom: 16,
                            ),
                            child: text(
                              error.severity.toUpperCase(),
                              40,
                              TextType.Bold,
                            ),
                          ),

                          SizedBox(
                            width: double.infinity,
                            child: Card(
                              color: colorPrimaryLight2,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      top: 24,
                                    ),
                                    child: text(error.title, 24, TextType.Bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                      left: 16,
                                      right: 16,
                                    ),
                                    child: textWithColor(
                                      "Code: ${error.code.toString()}",
                                      10,
                                      TextType.Regular,
                                      colorAccent,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                      left: 16,
                                      right: 16,
                                    ),
                                    child: textWithColor(
                                      "Mention the code above when contacting our help desk to make it easier to assist you.",
                                      7,
                                      TextType.Regular,
                                      colorGrey2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                        top: 32,
                                        left: 16,
                                        right: 16,
                                      ),
                                      child: textWithColor(
                                        "What happened.",
                                        9,
                                        TextType.Bold,
                                        colorPrimaryDark,
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                        left: 16,
                                        right: 16,
                                      ),
                                      child: text(
                                        error.message,
                                        12,
                                        TextType.Regular,
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16,
                                      ),
                                      child: textWithColor(
                                        "What to do.",
                                        9,
                                        TextType.Bold,
                                        colorPrimaryDark,
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                        left: 16,
                                        right: 16,
                                      ),
                                      child: text(
                                        error.helper,
                                        12,
                                        TextType.Regular,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 16,
                                      bottom: 16,
                                    ),
                                    child: RotatedBox(
                                      quarterTurns: -1,
                                      child: ElevatedButton(
                                        onPressed: actions,
                                        style: ElevatedButton.styleFrom(
                                          elevation: 5,
                                          backgroundColor: colorTinted,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          padding: const EdgeInsets.only(
                                            left: 16,
                                            top: 18,
                                            bottom: 18,
                                            right: 16,
                                          ),
                                        ),

                                        child: Text(
                                          buttonText,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: colorPrimaryDark,
                                            fontSize: 14,
                                            fontFamily: getTextType(
                                              TextType.Bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: RotatedBox(
                                      quarterTurns: -1,
                                      child: ElevatedButton(
                                        onPressed: closeActions,
                                        style: ElevatedButton.styleFrom(
                                          elevation: 5,
                                          backgroundColor: colorPrimary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          padding: const EdgeInsets.only(
                                            left: 16,
                                            top: 18,
                                            bottom: 18,
                                            right: 16,
                                          ),
                                        ),

                                        child: Text(
                                          "Close",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: colorPrimaryDark,
                                            fontSize: 14,
                                            fontFamily: getTextType(
                                              TextType.Bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );

      overlayState?.insert(errorEntry!);
      notifyListeners();
    }
  }

  Future<bool> checkPermission(Permission requested) async {
    PermissionStatus status = await requested.status;

    bool state = false;

    if (!status.isGranted) {
      if (status.isPermanentlyDenied) {
        showApplicationNotificationWithAction(
          NotificationType.info,
          "Permission Required.",
          "The application requires your permission to access your camera and take photos. Click on open settings below to accept now.",
          "Open Settings.",
          false,
          false,
          () {
            Navigator.pop(context);
            openAppSettings();
          },
          () {
            Navigator.pop(context);
          },
        );
      } else {
        status = await requested.request();
      }
    } else {
      state = true;
    }

    return Future.value(state);
  }

  @override
  void dispose() {
    closeLoading();
    closeNetwork();
    dismissError();
    super.dispose();
  }

  SpiroError getSpiroError(data) {
    SpiroError error;
    try {
      error = SpiroError.fromJson(data);
    } catch (e) {
      error = SpiroError(
        code: 900,
        message: "An error occurred while processing you request.",
        helper: "Kindly ensure that your internet connection is working well.",
        title: "Spiro Error",
        severity: Severity.message.name,
      );
    }

    return error;
  }

  Future<int> imageSelectionOption() async {
    int option = -1;

    bool hasCamera = false;

    if (Platform.isAndroid || Platform.isIOS) {
      if (await checkPermission(Permission.camera)) {
        List<CameraDescription> cameras = await availableCameras();

        if (cameras.isNotEmpty) {
          hasCamera = true;
        }
      }
    }

    if (Platform.isWindows) {
      try {
        List<CameraDescription> cameras = await CameraPlatform.instance
            .availableCameras();

        if (cameras.isNotEmpty) {
          hasCamera = true;
        }
      } on CameraException catch (e) {
        hasCamera = false;
      }
    }

    if (Platform.isMacOS) {
      hasCamera = true;
    }

    await showModalBottomSheet(
      context: context,
      barrierColor: colorPrimaryDark.withOpacity(0.8),
      backgroundColor: colorPrimaryDark,
      elevation: 3,
      enableDrag: false,
      useSafeArea: true,
      showDragHandle: true,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),

      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWithColor(
                    "IMAGE SELECTION",
                    24,
                    TextType.Bold,
                    colorMilkWhite,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: textWithColor(
                      "Below are the options available to you to select an image. Click on an option to proceed.",
                      10,
                      TextType.Regular,
                      colorGrey2,
                    ),
                  ),
                ],
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: hasCamera,
                      child: SizedBox(
                        width: 180,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 1,
                            backgroundColor: colorPrimaryDark.withOpacity(0.7),
                            padding: const EdgeInsets.symmetric(
                              vertical: 32,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            option = 1;
                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  CupertinoIcons.photo_camera_solid,
                                  size: 64,
                                  color: colorPrimary,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    textWithColor(
                                      "CAPTURE",
                                      20,
                                      TextType.SemiBold,
                                      colorPrimary,
                                    ),
                                    textWithColor(
                                      "IMAGE",
                                      20,
                                      TextType.SemiBold,
                                      colorPrimary,
                                    ),
                                    textWithColor(
                                      "Click to take an image using your device camera.",
                                      8,
                                      TextType.Regular,
                                      colorPrimary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: 180,
                      margin: const EdgeInsets.only(left: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          padding: const EdgeInsets.symmetric(
                            vertical: 32,
                            horizontal: 16,
                          ),
                          backgroundColor: colorPrimaryDark.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {
                          option = 2;
                          Navigator.pop(context);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Icon(
                                CupertinoIcons.photo_fill_on_rectangle_fill,
                                size: 64,
                                color: colorTinted,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  textWithColor(
                                    "SELECT",
                                    20,
                                    TextType.SemiBold,
                                    colorTinted,
                                  ),
                                  textWithColor(
                                    "IMAGE",
                                    20,
                                    TextType.SemiBold,
                                    colorTinted,
                                  ),
                                  textWithColor(
                                    "Click to select an image from your device.",
                                    8,
                                    TextType.Regular,
                                    colorTinted,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: roundedCornerButton('CANCEL', () {
                  Navigator.pop(context);
                }),
              ),
            ],
          ),
        );
      },
    );

    return Future.value(option);
  }

  Future<FilePickerResult?> getImageFromDirectory() async {
    showLoading("Loading File Picker....");

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      compressionQuality: 0,
      /*allowedExtensions: ['jpg', 'jpeg', 'png'], removed since images are not found in ios devices when set to custom filetype and it cannot work with image file tye*/
    );

    closeLoading();

    return result;
  }
}
