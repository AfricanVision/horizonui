import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import '../additionaldetails/FIleSaver.dart';
import 'ConnectFileStorage.dart';

class FileStorage implements ConnectFileStorage{

  //todo version 2 encrypt the files.

  Future<String> get _rootPath async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/Always/Receptive";
  }

  @override
  Future<String> saveFile(FileSaver saver) async {
      final gladePath = await _rootPath;
      File file = File('$gladePath/${saver.type.name}/${saver.id}.txt');
      if(file.existsSync()) {
        await file.writeAsBytes(saver.file);
      }else{
        await file.create(recursive: true);
        await file.writeAsBytes(saver.file);
      }
      return file.path;
  }

  @override
  Future<Uint8List?> readFile(FileSaver saver) async {
    try {

      final gladePath = await _rootPath;

      File file = File('$gladePath/${saver.type.name}/${saver.id}.txt');

      if(await file.exists()) {
         return await file.readAsBytes();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> fileExists(FileSaver saver) async {
    final gladePath = await _rootPath;
    return await File('$gladePath/${saver.type.name}/${saver.id}.txt').exists();
  }

}