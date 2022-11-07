import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/appdata.dart';

class CreateSmartListPage extends StatelessWidget {
  final Map? arguments;
  const CreateSmartListPage({Key? key, this.arguments}) : super(key: key);

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
      body: CreateSmartList(arguments: arguments),
    );
  }
}

// class ExpandStateBean {
//   //控制打开关闭状态
//   var index, isOpen;
//   ExpandStateBean(this.index, this.isOpen);
// }

class CreateSmartList extends StatefulWidget {
  final Map? arguments;
  const CreateSmartList({Key? key, this.arguments}) : super(key: key);

  @override
  State<CreateSmartList> createState() => _CreateSmartListState();
}

class _CreateSmartListState extends State<CreateSmartList> {
  List originList = [];
  // List<ExpandStateBean> expandStateList = [];
  //var arguments;
  int oldindex = 0;
  @override
  void initState() {
    //  arguments = widget.arguments;
    originList = List.from(widget.arguments!["model"]);

    debugPrint("$originList");
    super.initState();
  }

//设置展开还是关闭
  // _setCurrentIndex(int index, isExpand) {
  //   setState(() {
  //     originList[index]["state"] = !isExpand;
  //     for (var i = 0; i < originList.length; i++) {
  //       if (i != index) {
  //         originList[i]["state"] = false;
  //       }
  //     }
  //   });
  // }

  List<Widget> mainWidget() {
    List<Widget> temp = [];

    for (var i = 0; i < originList.length; i++) {
      temp.add(
        Container(
          width: double.maxFinite,
          height: 120.h,
          margin: const EdgeInsets.fromLTRB(5, 0, 10, 5),
          decoration: BoxDecoration(
              color: i % 2 == 0
                  ? const Color(0xffcddcec)
                  : const Color(0xffd2cdec),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: TextButton(
            child: Row(
              children: [
                Expanded(
                  child: Image.file(File(appData.smartDataPath +
                      "/smartpic/" +
                      originList[i]["pic"].toString() +
                      ".png")),
                  flex: 1,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Container()),
                      Row(
                        children: [
                          const Text(
                            "车型:",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            originList[i]["nameCN"],
                            maxLines: 3,
                            style: TextStyle(color: Colors.grey[700]),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "年份:",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            originList[i]["time"],
                            style: TextStyle(color: Colors.grey[700]),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "芯片类型:",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            originList[i]["Chip"],
                            style: TextStyle(color: Colors.grey[700]),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "ID:",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            originList[i]["ID"],
                            style: TextStyle(color: Colors.grey[700]),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "频率:",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            originList[i]["freq"],
                            style: TextStyle(color: Colors.grey[700]),
                          )
                        ],
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/createsmarthandle",
                  arguments: originList[i]);
            },
          ),
        ),
      );
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: double.maxFinite,
            height: 50.h,
            child: Center(
              child: Text(
                widget.arguments!["brandCN"],
                style:
                    TextStyle(fontSize: 30.sp, color: const Color(0XFF6E66AA)),
                textAlign: TextAlign.center,
              ),
            )),

        Expanded(
          child: ListView(
            children: mainWidget(),
          ),
        ),
        // ExpansionPanelList(
        //   expansionCallback: (index, bools) {
        //     _setCurrentIndex(index, bools);
        //   },
        //   children: title(),
        // ),
      ],
    );
  }
}
