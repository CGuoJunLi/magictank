import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class GetZipPage extends StatefulWidget {
  const GetZipPage({Key? key}) : super(key: key);

  @override
  State<GetZipPage> createState() => _GetZipPageState();
}

class _GetZipPageState extends State<GetZipPage> {
  late ProgressDialog pd;
  @override
  void initState() {
    pd = ProgressDialog(context: context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                // FilePickerResult? result =
                //     await FilePicker.platform.pickFiles();
                // if (result != null && result.files.isNotEmpty) {
                //   // pd.show(max: 100, msg: "解压文件中");
                //   pd.show(max: 100, msg: "解压中..请稍后...");
                //   await Future.delayed(const Duration(seconds: 5));
                //   //print(result.files.single.path!);
                //   // File file = File(result.files.single.path!);
                //   // File file2 =
                //   //     await file.copy(appData.rootPath + "/keydata.zip");
                //   // print(file2.path);
                //   // var filedata = await file.readAsBytes();
                //   // File file2 = File(appData.keyDataZipPath);
                //   // bool havefile = await file2.exists();
                //   // if (havefile) {
                //   //   await file2.delete();
                //   // }
                //   // await file2.create();
                //   // await file2.writeAsBytes(filedata);

                //   debugPrint("开始解压");

                //   await appData.geizipfile(
                //     result.files.single.path!,
                //     appData.tankRootPath + "/",
                //   );
                //   //pd.close();
                //   await appData.getAllCarName();
                //   await appData.getAllCarKeyData();
                //   await appData.getAllCivilName();
                //   await appData.getAllCivilKeyData();
                //   await appData.getAllMotorName();
                //   await appData.getAllMotorKeyData();
                //   await appData.pModelData();
                //   await appData.lModelData();
                //   await appData.getReadCodeData();
                //   imageCache.clear();
                //   imageCache.clearLiveImages();
                //   setState(() {});
                //   Fluttertoast.showToast(msg: "解压完成");
                //   pd.close();
                // }
              },
              child: const Text("解压坦克文件"))
        ],
      ),
    );
  }
}
