import 'package:magictank/cncpage/bluecmd/sendcmd.dart';
import 'dart:io';

// typedef void UpBinCallback(int progress);

class Upgrade {
  String filepath;
  double _presson = 0;
  Upgrade(this.filepath);
  Future<void> sendData() async {
    File file = File(filepath);
    var temp = file.readAsBytesSync();
    for (var i = 0; i < temp.length ~/ 168; i++) {
      _presson = i / (temp.length / 168) * 100;
      sendCmd(temp.sublist(i * 168, i * 168 + 168));
    }
    sendCmd([31, 0, 0]);
    //_presson=
  }

  int currentPresson() {
    return _presson.toInt();
  }
}

void upgrade(String path) {}
void yMode(String path) {}
