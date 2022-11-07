//芯片生成处理页面
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/appdata.dart';

import 'package:sn_progress_dialog/progress_dialog.dart';

class CreateSmartHandlePage extends StatelessWidget {
  final Map? arguments;
  const CreateSmartHandlePage({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //  elevation: 0,
        backgroundColor: const Color(0XFF6E66AA),
        centerTitle: true,
        title: SizedBox(
          width: 97.r,
          height: 18.r,
          child: Image.asset(
            "image/mcclone/mcbar.png",
            scale: 2.0,
            //fit: BoxFit.cover,
          ),
        ),
      ),
      body: CreateSmartHandle(arguments: arguments),
    );
  }
}

class CreateSmartHandle extends StatefulWidget {
  final Map? arguments;
  const CreateSmartHandle({Key? key, this.arguments}) : super(key: key);

  @override
  State<CreateSmartHandle> createState() => _CreateSmartHandleState();
}

class _CreateSmartHandleState extends State<CreateSmartHandle> {
  Map chipData = {};
  Map carData = {};
  late StreamSubscription chipWriteEventFn;
  late ProgressDialog pd;
  int currenPage = 0; //记录写入的当前页
  int writestep = 0; //写入步骤记录
  Map smartnote = {"freq": "", "chip": "", "id": "", "keyname": "", "note": ""};
  @override
  void initState() {
    carData = Map.from(widget.arguments!);
    pd = ProgressDialog(context: context);
    debugPrint("$carData");
    _getnote();
    super.initState();
  }

  @override
  void dispose() {
    // chipWriteEventFn.cancel();

    super.dispose();
  }

  _getnote() async {
    File file = File(appData.smartDataPath +
        "/smartnote/" +
        carData["note"].toString().replaceAll(" ", "") +
        ".json");
    // File file = File("/image/smartdata/smart.json");
    if (file.existsSync()) {
      //var lines = await rootBundle.loadString('json/tank1.json');
      var lines = await file.readAsString();
      smartnote = json.decode(lines);
      setState(() {});
    } else {
      debugPrint("smart.json 未找到文件" +
          appData.smartDataPath +
          "/smartnote/" +
          carData["note"].toString().replaceAll(" ", "") +
          ".json");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: const Color(0XFFEEEEEE),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.all(8.h),
                  padding: EdgeInsets.all(10.h),
                  width: double.maxFinite,
                  //height: doub,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        carData["nameCN"],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30.sp),
                      ),
                      Image.file(
                        File(appData.smartDataPath +
                            "/smartpic/" +
                            carData["pic"].toString() +
                            ".png"),
                        //   fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          "频率:" + smartnote["freq"],
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Text("芯片类型:" + smartnote["chip"]),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Text("ID:" + smartnote["id"]),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Text("钥匙:" + smartnote["keyname"]),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.h),
                  padding: EdgeInsets.all(10.h),
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    color: Color(0Xffd5d2e6),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "操作说明",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20.sp, color: const Color(0XFF6E66AA)),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "注意事项:" + smartnote["note"],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            height: 40.h,
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xff6e66aa))),
                child: const Text(
                  "生成",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
