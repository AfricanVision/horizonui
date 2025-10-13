import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../configs/Navigator.dart';
import '../../data/internal/application/NavigatorType.dart';
import '../../data/internal/application/TextType.dart';
import '../../designs/Component.dart';
import '../../utils/Colors.dart';
import '../login/Login.dart';
import 'ConnectSplash.dart';
import 'Splash.dart';
import 'ViewSplash.dart';

class SplashState extends State<Splash> implements ConnectSplash {
  ViewSplash? _model;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewSplash>.reactive(
      viewModelBuilder: () => ViewSplash(context, this),
      onViewModelReady: (viewModel) => {_model = viewModel, _initialize()},
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: colorPrimaryLight,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                  minWidth: viewportConstraints.maxWidth,
                ),

                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textWithColor(
                        "SPIRO SUPPORT",
                        5,
                        TextType.Regular,
                        colorPrimary,
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: textWithColor(
                              "SPIRO",
                              25,
                              TextType.Bold,
                              colorPrimary,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: textWithColor(
                              "Your all in one support application.",
                              10,
                              TextType.Regular,
                              colorPrimary,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: text("All rights reserved.", 10, TextType.Light),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _initialize() {
    Timer(
      const Duration(seconds: 2),
      () => SpiroNavigation().navigateToPage(
        NavigatorType.openFully,
        const Login(),
        context,
      ),
    );
  }
}
