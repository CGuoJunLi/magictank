import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magictank/alleventbus.dart';

import 'package:magictank/http/api.dart';
import 'package:magictank/magicsmart/bluetooth/msclonebt_mananger.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';

//import 'package:nordic_dfu/nordic_dfu.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

// class UpgradePage extends StatelessWidget {
//   const UpgradePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.chevron_left),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         centerTitle: true,
//         title: Text("TankApp"),
//       ),
//       body: Upgrade(),
//     );
//   }
// }

class SmartUpgrade extends StatefulWidget {
  final String fileurl;
  const SmartUpgrade(this.fileurl, {Key? key}) : super(key: key);
  @override
  _SmartUpgradeState createState() => _SmartUpgradeState();
}

class _SmartUpgradeState extends State<SmartUpgrade> {
  final _images = [
    {'name': 'NewMagicCloen', 'link': ''},
  ];

  late ProgressDialog pd;

  int step = 0;
  int downvalue = 0; //文件下载进度
  int sendvalue = 0; //发送给进度
  late String _localPath;
  int progressValue = 0;
  // List<_TaskInfo>? _tasks;
  // late List<_ItemHolder> _items;
  // late bool _isLoading;
  // late bool _permissionReady;
  // ReceivePort _port = ReceivePort();
  late StreamSubscription downFileevent;
  @override
  void initState() {
    _images[0]["link"] = widget.fileurl;
    debugPrint("下载连接为：" + widget.fileurl);
    debugPrint(msbtmodel.device.id.toString());
    pd = ProgressDialog(context: context);
    //_prepareSaveDir();
    // pd!.show(max: 100, msg: "下载文件中");

    // _prepareSaveDir();
    super.initState();

    downmagiclone();
  }

  Future<void> downmagiclone() async {
    await _prepareSaveDir();
    downFileevent = eventBus.on<DownFileEvent>().listen((event) {
      setState(() {
        downvalue = event.progress;
        if (downvalue == 100) {
          downFileevent.cancel();
          step = 1;
          upmclone();
        }
      });
    });
    Api.downfile(widget.fileurl, _localPath + "/mcbin.zip", 6);
    debugPrint("下载完成");
  }

  Future<void> upmclone() async {
    //开始升级进程
    // await NordicDfu.startDfu(
    //   msbtmodel.device.id.toString(),
    //   _localPath + '/mcbin.zip',
    //   fileInAsset: false,
    //   progressListener:
    //       DefaultDfuProgressListenerAdapter(onProgressChangedHandle: (
    //     deviceAddress,
    //     percent,
    //     speed,
    //     avgSpeed,
    //     currentPart,
    //     partsTotal,
    //   ) {
    //     debugPrint('deviceAddress: $deviceAddress, percent: $percent');
    //     setState(() {
    //       sendvalue = percent!;
    //       if (sendvalue == 100) {
    //         Navigator.pop(context, true);
    //       }
    //     });
    //   }),
    // );
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    debugPrint(_localPath);
  }

  Future<String?> _findLocalPath() async {
    String externalStorageDirPath;
    var directory = await getApplicationDocumentsDirectory();
    externalStorageDirPath = directory.path;
    debugPrint(externalStorageDirPath);
    return externalStorageDirPath;
  }

  @override
  void dispose() {
    downFileevent.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
          child: Container(
        // color: Colors.white,
        width: 300,
        height: 200,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8.0))),
        child: Column(
          children: [
            const Text("升级MagicClone"),
            const SizedBox(
              height: 10,
            ),
            Text("正在下载文件...进度:$downvalue%"),
            const SizedBox(
              height: 10,
            ),
            step > 0 ? Text("正在更新...进度:$sendvalue%") : Container(),
            const Expanded(
              child: Center(
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (step == 0) {
                  //只有下载的时候才能取消
                  Navigator.pop(context, false);
                }
              },
              child: const Text("取消"),
            )
          ],
        ),
      )),
    );
  }
}

// class _TaskInfo {
//   final String? name;
//   final String? link;

//   String? taskId;
//   int? progress = 0;
//   DownloadTaskStatus? status = DownloadTaskStatus.undefined;

//   _TaskInfo({this.name, this.link});
// }

// class _ItemHolder {
//   final String? name;
//   final _TaskInfo? task;
//   _ItemHolder({this.name, this.task});
// }
