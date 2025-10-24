import 'dart:async';

import 'package:flutter/material.dart';
import 'package:horizonui/Spiro/ui/dashboard/Dashboard.dart';
import 'package:stacked/stacked.dart';

import '../../configs/Navigator.dart';
import '../../data/internal/application/NavigatorType.dart';
import '../../designs/Responsive.dart';
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
      builder: (context, viewModel, child) => PopScope(
        canPop: false, // Prevents auto pop
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            if (_model?.loadingEntry == null && _model?.errorEntry == null) {}
          }
        },
        child: Scaffold(
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
                  return Responsive(
                    mobile: _mobileView(viewportConstraints),
                    desktop: _desktopView(viewportConstraints),
                    tablet: _desktopView(viewportConstraints),
                  );
                },
          ),
        ),
      ),
    );
  }

  _mobileView(BoxConstraints viewportConstraints) {
    return Column();
  }

  _desktopView(BoxConstraints viewportConstraints) {
    return Column();
  }

  _initialize() {
    Timer(
      const Duration(seconds: 2),
      () => SpiroNavigation().navigateToPage(
        NavigatorType.openFully,
        const Dashboard(),
        context,
      ),
    );
  }
}
