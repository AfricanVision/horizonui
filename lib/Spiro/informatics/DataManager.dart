
import '../data/internal/application/Agents.dart';
import '../data/internal/file/ConnectFileStorage.dart';
import '../data/internal/memory/ConnectInternalMemory.dart';
import '../endpoints/ConnectComms.dart';
import 'package:dio/dio.dart';

abstract class DataManager implements ConnectInternalMemory, ConnectComms, ConnectFileStorage {

  Future<bool> sendAgent(Agent userData);

}