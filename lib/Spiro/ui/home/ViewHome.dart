
import '../../data/internal/application/BatteryHistoryRequest.dart';
import '../../data/internal/application/BatteryRequest.dart';
import '../../data/internal/application/UserRegistration.dart';
import '../parent/ParentViewModel.dart';
import 'ConnectHome.dart';
import 'package:dio/dio.dart';

class ViewHome extends ParentViewModel {

  ConnectHome connection;

  ViewHome(super.context, this.connection);

  Future<bool> sendUserRegistration(UserRegistration userData) async {
    try {
      return await getDataManager().sendUserRegistration(userData);
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> createBattery(BatteryRequest batteryRequest) async {
    try {
      return await getDataManager().createBattery(batteryRequest);
    } catch (e) {
      rethrow;
    }
  }
  Future<BatteryRequest> getBatteryById(String id) async {
    try {
      return await getDataManager().getBatteryById(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BatteryRequest>> getAllBatteries() async {
    try {
      return await getDataManager().getAllBatteries();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateBattery(BatteryRequest batteryRequest) async {
    try {
      return await getDataManager().updateBattery(batteryRequest);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> createBatteryHistory(BatteryHistoryRequest batteryHistoryRequest) async {
    try {
      return await getDataManager().createBatteryHistory(batteryHistoryRequest);
    } catch (e) {
      rethrow;
    }
  }

  Future<BatteryHistoryRequest> getBatteryHistoryById(String id) async {
    try {
      return await getDataManager().getBatteryHistoryById(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BatteryHistoryRequest>> getAllBatteryHistory() async {
    try {
      return await getDataManager().getAllBatteryHistory();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateBatteryHistory(BatteryHistoryRequest batteryHistoryRequest) async {
    try {
      return await getDataManager().updateBatteryHistory(batteryHistoryRequest);
    } catch (e) {
      rethrow;
    }
  }
}