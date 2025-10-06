
import 'dart:typed_data';


import '../data/internal/additionaldetails/FIleSaver.dart';
import '../data/internal/file/ConnectFileStorage.dart';
import '../data/internal/memory/ConnectInternalMemory.dart';
import '../endpoints/ConnectComms.dart';
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




}

