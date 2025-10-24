import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../data/internal/additionaldetails/FIleSaver.dart';
import '../data/internal/application/Agents.dart';
import '../data/internal/application/BatteryHistoryRequest.dart';
import '../data/internal/application/BatteryRequest.dart';
import '../data/internal/file/ConnectFileStorage.dart';
import '../data/internal/memory/ConnectInternalMemory.dart';
import '../endpoints/ConnectComms.dart';
import 'DataManager.dart';

class AppDataManager implements DataManager {
  ConnectInternalMemory connectInternalMemory;
  ConnectComms connectComms;
  ConnectFileStorage connectFileStorage;

  AppDataManager(
    this.connectInternalMemory,
    this.connectComms,
    this.connectFileStorage,
  );

  @override
  Future<bool> sendUserRegistration(Agent userData) async {
    return await connectComms.sendAgent(userData);
  }

  @override
  Future<Uint8List?> readFile(FileSaver file) async {
    return await connectFileStorage.readFile(file);
  }

  @override
  Future<String> saveFile(FileSaver file) async {
    return await connectFileStorage.saveFile(file);
  }

  @override
  Future<bool> fileExists(FileSaver file) async {
    return await connectFileStorage.fileExists(file);
  }

  @override
  Future<Response> createBattery(BatteryRequest batteryRequest) async {
    return await connectComms.createBattery(batteryRequest);
  }

  @override
  Future<BatteryRequest> getBatteryById(String id) async {
    return await connectComms.getBatteryById(id);
  }

  @override
  Future<List<BatteryRequest>> getAllBatteries() async {
    return await connectComms.getAllBatteries();
  }

  @override
  Future<bool> updateBattery(BatteryRequest batteryRequest) async {
    return await connectComms.updateBattery(batteryRequest);
  }

  @override
  Future<bool> createBatteryHistory(
    BatteryHistoryRequest batteryHistoryRequest,
  ) async {
    return await connectComms.createBatteryHistory(batteryHistoryRequest);
  }

  @override
  Future<BatteryHistoryRequest> getBatteryHistoryById(String id) async {
    return await connectComms.getBatteryHistoryById(id);
  }

  @override
  Future<List<BatteryHistoryRequest>> getAllBatteryHistory() async {
    return await connectComms.getAllBatteryHistory();
  }

  @override
  Future<bool> updateBatteryHistory(
    BatteryHistoryRequest batteryHistoryRequest,
  ) async {
    return await connectComms.updateBatteryHistory(batteryHistoryRequest);
  }

  @override
  Future<bool> sendAgent(Agent userData) {
    // TODO: implement sendAgent
    throw UnimplementedError();
  }

  @override
  Future<Response> getStations() async {
    return await connectComms.getStations();
  }

  @override
  Future<Response> getStationTypes() async {
    return await connectComms.getStationTypes();
  }

  Future<Response> saveStations() {
    throw UnimplementedError();
  }

  @override
  Future<Response> getStatus() async {
    return await connectComms.getStatus();
  }
}
