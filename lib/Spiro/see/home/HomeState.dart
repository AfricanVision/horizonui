
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpline/Spiro/about/external/data/VehicleMapping.dart';
import 'package:helpline/Spiro/about/internal/application/TextType.dart';
import 'package:helpline/Spiro/see/batterymapping/RegisterBatteryMapping.dart';
import 'package:helpline/Spiro/see/vehiclemapping/RegisterVehicleMapping.dart';
import 'package:helpline/Spiro/utils/Colors.dart';
import 'package:stacked/stacked.dart';

import '../../about/external/data/BatteryMapping.dart';
import '../../about/external/data/OptionUpload.dart';
import '../../about/external/data/TypeUpload.dart';
import '../../about/internal/application/NavigatorType.dart';
import '../../configs/Navigator.dart';
import '../../designs/Component.dart';
import 'ConnectHome.dart';
import 'Home.dart';
import 'ViewHome.dart';

class HomeState extends State<Home> implements ConnectHome{

  ViewHome? _model;

  List<OptionUpload> batteryItems = [];

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
              PopupMenuItem(
                onTap: () => _openStationMapping(),
                child: Text('Battery Station Mapping'),
              ),
              PopupMenuItem(
                onTap: () => _openVehicleMapping(),
                child: Text('Vehicle Mapping'),
              ),
            ],
          )
        ],
      ),

      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _setUploadItem().length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) => _setUploadItem().elementAt(index),
      ),

    );
  }

  void _closeApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  _uploadAll() async{

    if(batteryItems.isNotEmpty){

      _model?.showLoading("Uploading");

      for(OptionUpload upload in batteryItems){
        if(upload.type == TypeUpload.BatteryToStation){
         //_model?.sendBattery(upload.batteryItem!);
        }
      }

      _model?.closeLoading();


      /*if(itemBattery.isNotEmpty){
        sendFormDataList("https://www.zohoapis.in/crm/v7/functions/swap_battery_update/actions/execute?auth_type=apikey&zapikey=1003.686649845f6ca2455fd27494723607a1.2ee7d2555f302b34f682be0ba14f57d1", "arguments", itemBattery);
      }*/
    }
  }


  Future<void> sendFormDataList(String requestURL, String fieldName, List<BatteryMapping> batteries) async {
    final dio = Dio();

    try {
      // Convert list of BatteryMapping to List<Map> and then encode to JSON string
      String jsonList = jsonEncode(batteries.map((b) => b.toJson()).toList());

      FormData formData = FormData.fromMap({
        fieldName: jsonList,
      });

      final response = await dio.post(
        requestURL,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.data}');
    } catch (e) {
      print('Request failed: $e');
    }
  }
  _setUploadItem() {

    return batteryItems.map((e) => Padding(padding: const EdgeInsets.only(right: 16),
      child: _returnItem(e),)).toList();
  }

  _openStationMapping() async{

    BatteryMapping? mapping = await spiroNavigation().navigateToPageWithData(RegisterBatteryMapping(), context);

    if((mapping?.Station_ID ?? "").isNotEmpty && (mapping?.Battery_OEM_No ?? "").isNotEmpty){

      OptionUpload upload = OptionUpload();

      upload.batteryItem = mapping;

      upload.type = TypeUpload.BatteryToStation;

      batteryItems.add(upload);

      _model?.notifyListeners();
    }


  }

  _openVehicleMapping() async {

    VehicleMapping? mapping = await spiroNavigation().navigateToPageWithData(RegisterVehicleMapping(), context);

    if((mapping?.Vehicle_Reg_No ?? "").isNotEmpty){

      OptionUpload upload = OptionUpload();

      upload.vehicleItem = mapping;

      upload.type = TypeUpload.VehicleToBattery;

      batteryItems.add(upload);

      _model?.notifyListeners();
    }
  }

  _removeItem(OptionUpload? mapping) {
    batteryItems.removeWhere((value) => value == mapping);
    _model?.notifyListeners();
  }

  @override
  void setFailure(BatteryMapping batteryItem, Object? error) {
    // TODO: implement setFailure
  }

  @override
  void setItem(BatteryMapping batteryItem) {
    batteryItems.removeWhere((value) => value.batteryItem == batteryItem);

  }

  _returnItem(OptionUpload e) {

    if(e.type! == TypeUpload.VehicleToBattery){
      return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),

        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            text("VEHICLE: ${e.vehicleItem?.Vehicle_Reg_No ?? ""}", 24, TextType.Bold),

            Padding(padding: EdgeInsets.all(8),
              child:  textWithColor("BATTERY 1: ${e.vehicleItem?.battery_slot_1 ?? ""}", 14, TextType.Regular, colorPrimary),),

            Padding(padding: EdgeInsets.all(8),
              child:  textWithColor("BATTERY 2: ${e.vehicleItem?.battery_slot_2 ?? ""}", 14, TextType.Regular, colorPrimary),),

            Padding(padding: EdgeInsets.all(8),
              child: text("ACTION: ${e.type?.name ?? ""}", 12, TextType.Bold),),
            Divider(color: colorPrimary,),


          ],),
      );
    }else{

      return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        /*   decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: colorWhite,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 1.0),
              blurRadius: 2.0,
            ),
          ],
        ),*/
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            text("STATION: ${e.batteryItem?.Station_ID ?? ""}", 24, TextType.Bold),

            Padding(padding: EdgeInsets.all(8),
              child:  textWithColor("BATTERY: ${e.batteryItem?.Battery_OEM_No ?? ""}", 14, TextType.Regular, colorPrimary),),

            Padding(padding: EdgeInsets.all(8),
              child: text("ACTION: ${e.type?.name ?? ""}", 12, TextType.Bold),),
            Divider(color: colorPrimary,),


          ],),
      );
    }
  }


}