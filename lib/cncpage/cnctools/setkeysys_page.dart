import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/userappbar.dart';

class SetKeySysPage extends StatefulWidget {
  const SetKeySysPage({Key? key}) : super(key: key);

  @override
  State<SetKeySysPage> createState() => _SetKeySysPageState();
}

class _SetKeySysPageState extends State<SetKeySysPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: Column(
        children: [
          Text("选择当前的钥匙胚系统"),
          Container(
            width: double.maxFinite,
            height: 50.r,
            padding: EdgeInsets.only(left: 10.r, right: 10.r),
            child: Row(
              children: [
                Text("Silca"),
                Expanded(child: SizedBox()),
                Checkbox(
                    value: appData.keysyssele[0] == "true" ? true : false,
                    activeColor: const Color(0xff384c70),
                    onChanged: (value) {
                      if (value!) {
                        appData.keysyssele[0] = "true";
                        appData.keysyssele[1] = "false";
                        appData.keysyssele[2] = "false";
                        appData.keysyssele[3] = "false";
                      }
                      appData
                          .upgradeAppData({"keysyssele": appData.keysyssele});
                      Fluttertoast.showToast(msg: "已经设置为Silca");
                      setState(() {});
                    }),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 50.r,
            padding: EdgeInsets.only(left: 10.r, right: 10.r),
            child: Row(
              children: [
                Text("Keyline"),
                Expanded(child: SizedBox()),
                Checkbox(
                    value: appData.keysyssele[1] == "true" ? true : false,
                    activeColor: const Color(0xff384c70),
                    onChanged: (value) {
                      if (value!) {
                        appData.keysyssele[0] = "false";
                        appData.keysyssele[1] = "true";
                        appData.keysyssele[2] = "false";
                        appData.keysyssele[3] = "false";
                      }
                      appData
                          .upgradeAppData({"keysyssele": appData.keysyssele});
                      Fluttertoast.showToast(msg: "已经设置为Keyline");
                      setState(() {});
                    }),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 50.r,
            padding: EdgeInsets.only(left: 10.r, right: 10.r),
            child: Row(
              children: [
                Text("Ilcon"),
                Expanded(child: SizedBox()),
                Checkbox(
                    value: appData.keysyssele[2] == "true" ? true : false,
                    activeColor: const Color(0xff384c70),
                    onChanged: (value) {
                      if (value!) {
                        appData.keysyssele[0] = "false";
                        appData.keysyssele[1] = "false";
                        appData.keysyssele[2] = "true";
                        appData.keysyssele[3] = "false";
                      }
                      appData
                          .upgradeAppData({"keysyssele": appData.keysyssele});
                      Fluttertoast.showToast(msg: "已经设置为Ilcon");
                      setState(() {});
                    }),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 50.r,
            padding: EdgeInsets.only(left: 10.r, right: 10.r),
            child: Row(
              children: [
                Text("JMA"),
                Expanded(child: SizedBox()),
                Checkbox(
                    value: appData.keysyssele[3] == "true" ? true : false,
                    activeColor: const Color(0xff384c70),
                    onChanged: (value) {
                      if (value!) {
                        appData.keysyssele[0] = "false";
                        appData.keysyssele[1] = "false";
                        appData.keysyssele[2] = "false";
                        appData.keysyssele[3] = "true";
                      }
                      appData
                          .upgradeAppData({"keysyssele": appData.keysyssele});
                      Fluttertoast.showToast(msg: "已经设置为JMA");
                      setState(() {});
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
