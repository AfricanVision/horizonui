
import 'dart:typed_data';

import 'package:helpline/Spiro/about/external/data/BatteryMapping.dart';
import 'package:helpline/Spiro/about/external/data/VehicleMapping.dart';

import '../about/internal/additionaldetails/FIleSaver.dart';
import '../about/internal/file/ConnectFileStorage.dart';
import '../about/internal/memory/ConnectInternalMemory.dart';
import '../comms/ConnectComms.dart';
import 'DataManager.dart';

class AppDataManager implements DataManager {

  ConnectInternalMemory connectInternalMemory;

  ConnectComms connectComms;

  ConnectFileStorage connectFileStorage;

  AppDataManager(this.connectInternalMemory, this.connectComms, this.connectFileStorage);

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
  sendBatteryItem(BatteryMapping batteryItem) async {
    return await connectComms.sendBatteryItem(batteryItem);
  }

  @override
  sendVehicleItem(VehicleMapping vehicleItem) async{
    return await connectComms.sendVehicleItem(vehicleItem);
  }


}

