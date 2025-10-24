import 'package:dio/dio.dart';

import '../data/internal/application/Agents.dart';
import '../data/internal/application/BatteryHistoryRequest.dart';
import '../data/internal/application/BatteryRequest.dart';

abstract class ConnectComms {
  Future<bool> sendAgent(Agent userData);
  Future<Response> createBattery(BatteryRequest batteryRequest);
  Future<BatteryRequest> getBatteryById(String id);
  Future<List<BatteryRequest>> getAllBatteries();
  Future<bool> updateBattery(BatteryRequest batteryRequest);
  Future<bool> createBatteryHistory(
    BatteryHistoryRequest batteryHistoryRequest,
  );
  Future<BatteryHistoryRequest> getBatteryHistoryById(String id);
  Future<List<BatteryHistoryRequest>> getAllBatteryHistory();
  Future<bool> updateBatteryHistory(
    BatteryHistoryRequest batteryHistoryRequest,
  );
  Future<Response> getStations();

  Future<Response> saveStations();

  Future<Response> getStationTypes();

  Future<Response> getStatus();
}
