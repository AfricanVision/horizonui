
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import '../../data/internal/application/NavigatorType.dart';
import '../../data/internal/application/TextType.dart';
import '../../configs/Navigator.dart';
import '../../designs/Component.dart';
import '../../designs/Responsive.dart';
import '../../utils/Colors.dart';
import 'ConnectHome.dart';
import 'Home.dart';
import 'ViewHome.dart';

class HomeState extends State<Home> implements ConnectHome{

  ViewHome? _model;


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewHome>.reactive(
        viewModelBuilder: () => ViewHome(context, this),
        onViewModelReady: (viewModel) => {
          _model = viewModel,
          _initialiseView()
        },
        builder: (context, viewModel, child) => PopScope(canPop: false, // Prevents auto pop
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                if (_model?.loadingEntry == null && _model?.errorEntry == null) {
                  _closeApp();
                }
              }
            },child: Scaffold(
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints viewportConstraints) {
                  return Responsive(mobile: _mobileView(viewportConstraints),desktop: _desktopView(viewportConstraints),tablet: _desktopView(viewportConstraints),);})),));
  }

  _initialiseView() async {
    //_model?.setUserDetails();
  }

  _mobileView(BoxConstraints viewportConstraints){
    return Column();
  }

  _desktopView(BoxConstraints viewportConstraints){
    return Column();
  }

  void _closeApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }



}