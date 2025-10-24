
import 'dart:convert';

import 'package:dio/dio.dart';
import '../configs/Env.dart';
import '../data/internal/application/BatteryHistoryRequest.dart';
import '../data/internal/application/BatteryRequest.dart';
import '../data/internal/application/Agents.dart';
import '../data/internal/application/Pair.dart';
import '../data/internal/memory/ConnectInternalMemory.dart';
import 'CommsDirections.dart';
import 'ConnectComms.dart';

class Comms implements ConnectComms {

  final String apikey = '';


  Dio dio = Dio();
  ConnectInternalMemory helper;

  Comms(this.helper);

  @override
  Future<bool> sendAgent(Agent userData) async {
    try {

      final response = await dio.post(
        "http://localhost:8080/api/agents",
        data: jsonEncode(userData.toJson()),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-API-KEY': apikey
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => true,
        ),
      );

      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending user registration: $e');
      rethrow;
    }
  }

  /*@override
  Future<bool> createBattery(BatteryRequest batteryRequest) async {
    try {
      final response = await dio.post(
        "http://localhost:8080/spiro/horizon/battery/add",
        data: jsonEncode(batteryRequest.toJson()),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => true,
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }*/

  @override
  Future<BatteryRequest> getBatteryById(String id) async {
    try {
      final response = await dio.get(
        "$partnersRoute$getBatteryById$id",
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => true,
        ),
      );
      return BatteryRequest.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BatteryRequest>> getAllBatteries() async {
    try {
      final response = await dio.get(
        "$partnersRoute$getAllBatteries",
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => true,
        ),
      );
      return (response.data as List).map((item) => BatteryRequest.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateBattery(BatteryRequest batteryRequest) async {
    try {
      final response = await dio.post(
        "$partnersRoute$updateBattery",
        data: jsonEncode(batteryRequest.toJson()),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => true,
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> createBatteryHistory(BatteryHistoryRequest batteryHistoryRequest) async {
    try {
      final response = await dio.post(
        "$partnersRoute$createBatteryHistory",
        data: jsonEncode(batteryHistoryRequest.toJson()),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => true,
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BatteryHistoryRequest> getBatteryHistoryById(String id) async {
    try {
      final response = await dio.get(
        "$partnersRoute$getBatteryHistoryById$id",
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => true,
        ),
      );
      return BatteryHistoryRequest.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BatteryHistoryRequest>> getAllBatteryHistory() async {
    try {
      final response = await dio.get(
        "$partnersRoute$getAllBatteryHistory",
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => true,
        ),
      );
      return (response.data as List).map((item) => BatteryHistoryRequest.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateBatteryHistory(BatteryHistoryRequest batteryHistoryRequest) async {
    try {
      final response = await dio.post(
        "$partnersRoute$updateBatteryHistory",
        data: jsonEncode(batteryHistoryRequest.toJson()),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => true,
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> createBattery(BatteryRequest data) async{
    Pair navigation = await getRequestHeaders(verifyRegCredentials, "");
    dio.options.headers = navigation.value;
    return await dio.post(navigation.key, data: data);
  }

  @override
  Future<Response> getStations() async{

    Pair navigation = await getRequestHeaders(getIdentificationTypesProspects, "");
    dio.options.headers = navigation.value;

    return await dio.get(navigation.key, options: Options(
        headers: dio.options.headers
    ));
  }

  Future<Pair> getRequestHeaders(String url, String urlData) async{

    dio.options.headers = <String, dynamic>{};

    /*MeDescription data = await helper.getMyDescription();

    if(data.token.isNotEmpty && url != deviceToken){
      dio.options.headers["Authorization"] = "Bearer ${data.token}";
    }*/

    dio.options.contentType = Headers.jsonContentType;

    dio.options.responseType = ResponseType.json;

    dio.options.headers["what"] = apiKey;

    dio.options.headers["version"] = localisedAppVersion;

  /*  if(url == logoutRequest){
      dio.options.headers.remove("Authorization");
    }*/


    return Future.value(Pair(url, dio.options.headers));

  }

}