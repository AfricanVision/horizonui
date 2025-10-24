import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:horizonui/Spiro/data/models/StationsRequest.dart';

import '../data/internal/application/Agents.dart';
import '../data/internal/application/BatteryHistoryRequest.dart';
import '../data/internal/application/BatteryRequest.dart';
import '../data/internal/memory/ConnectInternalMemory.dart';
import 'CommsDirections.dart';
import 'ConnectComms.dart';

class Comms implements ConnectComms {
  final String apikey = 'admin-api-key-67890';

  Dio dio = Dio();
  ConnectInternalMemory helper;

  Comms(this.helper);

  @override
  Future<bool> sendAgent(Agent userData) async {
    try {
      final response = await dio.post(
        "$baseUrl$updateBattery",
        data: jsonEncode(userData.toJson()),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-API-KEY': apikey,
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

  @override
  Future<bool> createBattery(BatteryRequest batteryRequest) async {
    try {
      final response = await dio.post(
        "$baseUrl$updateBattery",
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
  Future<BatteryRequest> getBatteryById(String id) async {
    try {
      final response = await dio.get(
        "$baseUrl$updateBattery",
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
        "$baseUrl$updateBattery",
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => true,
        ),
      );
      return (response.data as List)
          .map((item) => BatteryRequest.fromJson(item))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateBattery(BatteryRequest batteryRequest) async {
    try {
      final response = await dio.post(
        "$baseUrl$updateBattery",
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
  Future<bool> createBatteryHistory(
    BatteryHistoryRequest batteryHistoryRequest,
  ) async {
    try {
      final response = await dio.post(
        "$baseUrl$updateBattery",
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
        "$baseUrl$updateBattery",
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
        "$baseUrl$updateBattery",
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => true,
        ),
      );
      return (response.data as List)
          .map((item) => BatteryHistoryRequest.fromJson(item))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateBatteryHistory(
    BatteryHistoryRequest batteryHistoryRequest,
  ) async {
    try {
      final response = await dio.post(
        "$baseUrl$updateBattery",
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
  Future<Response> saveStations() async {
    try {
      final response = await dio.get(
        "$baseUrl$saveStations",
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => true,
        ),
      );

      return response;
    } catch (e) {
      print("Error saving stations: $e");
      rethrow;
    }
  }

  @override
  Future<List<StationsRequest>> getStations() async {
    try {
      final response = await dio.get(
        "$baseUrl$getStationsUrl",
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) => true,
        ),
      );

      final List<dynamic> dataList = response.data;
      return dataList.map((e) => StationsRequest.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
