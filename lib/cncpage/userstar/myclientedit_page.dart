import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';
import 'package:magictank/userappbar.dart';

class MyClientEdit extends StatefulWidget {
  final Map arguments;
  const MyClientEdit(this.arguments, {Key? key}) : super(key: key);

  @override
  State<MyClientEdit> createState() => _MyClientEditState();
}

class _MyClientEditState extends State<MyClientEdit> {
  Map<String, dynamic> editdata = {};

  @override
  void initState() {
    editdata = Map.from(widget.arguments);

    super.initState();
  }

  Future<void> delclient(Map<String, dynamic> data) async {
    try {
      var result = await Api.delUserClient(data);
      if (result["state"]) {
        //print("服务器删除成功");
        await appData.deleClient(data);
        //print("数据库删除成功");
      } else {
        data["state"] = 3;
        await appData.updateClient(data);
      }
    } catch (e) {
      //printe);
      data["state"] = 3;
      await appData.updateClient(data);
      ////print(e);
      debugPrint("删除失败");
    }
  }

  Future<void> updateCustomerData(Map<String, dynamic> hiskeydata) async {
    var data = {
      "timer": hiskeydata["timer"],
      "userid": hiskeydata["userid"],
      "keyid": hiskeydata["keyid"],
      "type": hiskeydata["type"],
      "bitting": hiskeydata["bitting"],
      "name": hiskeydata["name"],
      "phone": hiskeydata["phone"],
      "carnum": hiskeydata["carnum"],
      "state": 0,
    };
    try {
      var result = await Api.upUserClient(data);
      if (result["state"]) {
        data["state"] = 1;
        await appData.insertClient(data);
      } else {
        await appData.insertClient(data);
      }
    } catch (e) {
      await appData.insertClient(data);
    }
  }

  myclientchange(Map<String, dynamic> data) async {
    data.remove("keydata");
    await delclient(data);
    await updateCustomerData(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: Column(
        children: [
          SizedBox(
            height: 48.h,
            child: Center(
              child: Text(
                "修改客户资料",
                style:
                    TextStyle(fontSize: 17.sp, color: const Color(0xff384c70)),
              ),
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              Container(
                height: 40.h,
                margin: EdgeInsets.only(bottom: 6.h),
                padding: EdgeInsets.only(left: 20.w, right: 20.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    const Text("客户名称:"),
                    Expanded(
                        child: TextField(
                      controller: TextEditingController(text: editdata["name"]),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x

                        FilteringTextInputFormatter.allow(
                            RegExp(r'([1-9][0-9]{0,3})')),
                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        editdata["name"] = value;
                      },
                    )),
                  ],
                ),
              ),
              Container(
                height: 40.h,
                margin: EdgeInsets.only(bottom: 6.h),
                padding: EdgeInsets.only(left: 20.w, right: 20.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    const Text("客户手机号:"),
                    Expanded(
                        child: TextField(
                      controller:
                          TextEditingController(text: editdata["phone"]),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x

                        FilteringTextInputFormatter.allow(
                            RegExp(r'([1-9][0-9]{0,3})')),
                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        editdata["phone"] = value;
                      },
                    )),
                  ],
                ),
              ),
              Container(
                height: 40.h,
                margin: EdgeInsets.only(bottom: 6.h),
                padding: EdgeInsets.only(left: 20.w, right: 20.h),
                color: const Color(0xffdde2ea),
                child: Row(
                  children: [
                    const Text("车牌号:"),
                    Expanded(
                        child: TextField(
                      controller:
                          TextEditingController(text: editdata["carnum"]),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                        //Pattern x

                        FilteringTextInputFormatter.allow(
                            RegExp(r'([1-9][0-9]{0,3})')),
                        // WhitelistingTextInputFormatter(accountRegExp),
                      ],
                      onChanged: (value) {
                        editdata["carnum"] = value;
                      },
                    )),
                  ],
                ),
              ),
            ],
          )),
          SizedBox(
            height: 50.h,
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff384c70),
                        borderRadius: BorderRadius.circular(13.sp)),
                    width: 150.w,
                    height: 40.h,
                    child: Center(
                      child: Text(
                        S.of(context).cancel,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (editdata["name"] == "" &&
                        editdata["phone"] == "" &&
                        editdata["carnum"] == "") {
                      Fluttertoast.showToast(msg: "客户名称,客户手机号,车牌号必须存在一个");
                    } else {
                      await myclientchange(editdata);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff384c70),
                        borderRadius: BorderRadius.circular(13.sp)),
                    width: 150.w,
                    height: 40.h,
                    child: Center(
                      child: Text(
                        S.of(context).okbt,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
