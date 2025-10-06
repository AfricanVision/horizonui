import 'dart:typed_data';
import '../additionaldetails/FIleSaver.dart';

abstract class ConnectFileStorage{
  Future<String> saveFile(FileSaver saver);
  Future<Uint8List?> readFile(FileSaver saver);
  Future<bool> fileExists(FileSaver path);
}