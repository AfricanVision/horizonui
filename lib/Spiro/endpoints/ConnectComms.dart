import '../data/internal/application/BatteryHistoryRequest.dart';
import '../data/internal/application/BatteryRequest.dart';
import '../data/internal/application/UserRegistration.dart';
import 'package:dio/dio.dart';

abstract class ConnectComms{

  Future<bool> sendUserRegistration(UserRegistration userData);
  Future<bool> createBattery(BatteryRequest batteryRequest);
  Future<BatteryRequest> getBatteryById(String id);
  Future<List<BatteryRequest>> getAllBatteries();
  Future<bool> updateBattery(BatteryRequest batteryRequest);
  Future<bool> createBatteryHistory(BatteryHistoryRequest batteryHistoryRequest);
  Future<BatteryHistoryRequest> getBatteryHistoryById(String id);
  Future<List<BatteryHistoryRequest>> getAllBatteryHistory();
  Future<bool> updateBatteryHistory(BatteryHistoryRequest batteryHistoryRequest);
}