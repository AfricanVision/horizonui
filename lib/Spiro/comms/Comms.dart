
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:helpline/Spiro/about/external/data/BatteryMapping.dart';
import 'package:helpline/Spiro/about/external/data/VehicleMapping.dart';
import '../about/internal/memory/ConnectInternalMemory.dart';
import 'ConnectComms.dart';

class Comms implements ConnectComms {

  Dio dio = Dio();

  ConnectInternalMemory helper;

  Comms(this.helper);

  @override
  Future<Response> sendBatteryItem(BatteryMapping batteryItem) async{

  /*  FormData formData = FormData.fromMap({
      "arguments": batteryItem.toJson(),
    });

    final response = await dio.post(

      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );*/

    FormData formData = FormData.fromMap({
      "arguments": jsonEncode(batteryItem.toJson()),
    });

    final response = await dio.post(
      "https://sandbox.zohoapis.in/crm/v7/functions/swap_battery_update/actions/execute?auth_type=apikey&zapikey=1003.8ec3943cc3c38111b5131692914a876a.7f5623dd74cabb0f67edd488aeba9adb",
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        sendTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        validateStatus: (status) => true, // Accept non-200 statuses
      ),
    );

    print('Response Code: ${response.statusCode}');
    print('Response Body: ${response.data}');

    return response;

  }

  /*@override
  Future<Response> sendVehicleItem(VehicleMapping batteryItem) async{

    *//*  FormData formData = FormData.fromMap({
      "arguments": batteryItem.toJson(),
    });

    final response = await dio.post(

      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );*//*

    FormData formData = FormData.fromMap({
      "arguments": jsonEncode(batteryItem.toJson()),
    });

    final response = await dio.post(
      "https://sandbox.zohoapis.in/crm/v7/functions/vehicle_battery_update/actions/execute?auth_type=apikey&zapikey=1003.8ec3943cc3c38111b5131692914a876a.7f5623dd74cabb0f67edd488aeba9adb",
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        sendTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        validateStatus: (status) => true, // Accept non-200 statuses
      ),
    );

    print('Response Code: ${response.statusCode}');
    print('Response Body: ${response.data}');

    return response;

  }*/



}