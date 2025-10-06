import 'dart:typed_data';

import 'FileSaveTypes.dart';


class FileSaver{

  Uint8List file;
  String id;
  FileSaverTypes type;

  FileSaver(this.file, this.id, this.type);
}