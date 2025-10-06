
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import '../../about/internal/application/NavigatorType.dart';
import '../../about/internal/application/TextType.dart';
import '../../configs/Navigator.dart';
import '../../designs/Component.dart';
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
        builder: (context, viewModel, child) => WillPopScope(child: _mainBody(), onWillPop: () async {
          if (_model?.loadingEntry == null && _model?.errorEntry == null) {
            _closeApp();
          }
          return false;
        }));
  }

  _initialiseView() async {
    //_model?.setUserDetails();
  }



  _mainBody(){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: text("SPIRO SUPPORT", 24, TextType.Bold),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
            },
            itemBuilder: (BuildContext context) => [

            ],
          )
        ],
      ),

      body: Column(),

    );
  }

  void _closeApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }



}