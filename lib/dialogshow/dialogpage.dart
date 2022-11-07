import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:magictank/main.dart';
import 'package:provider/provider.dart';
//import 'dart:async';

class MyTextDialog extends Dialog {
  final String button1;
  final String button2;
  final Color button1color;
  final Color button2color;
  final String title;
  final IconData? messageicon;
  final String massage;
  final Color iconcolor;
  final int model;
  const MyTextDialog(
    this.massage, {
    Key? key,
    this.button1 = "取消",
    this.button2 = "确定",
    this.title = "提示信息",
    this.messageicon = Icons.message,
    this.iconcolor = Colors.yellow,
    this.button1color = Colors.white,
    this.button2color = Colors.white,
    this.model = 0,
  }) : super(key: key);
  // _showTimer(context) {
  //   // var timer;
  //   Timer.periodic(const Duration(milliseconds: 3000), (t) {
  //     Navigator.pop(context);
  //     t.cancel();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: WillPopScope(
        onWillPop: () async {
          if (model == 0) {
            return true;
          } else {
            return false;
          }
        },
        child: Center(
          child: Container(
            // color: Colors.white,
            width: 300.w,
            height: 300.h,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(13.0))),
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 17.sp),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xffeeeeee),
                    child: Center(
                      child: Text(
                        massage,
                        style: TextStyle(fontSize: 17.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                          child: SizedBox(
                        height: 40.h,
                        child: OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xff384c70)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(13.0))),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          onPressed: () {
                            Navigator.pop(context, false);
                            // return false;
                          },
                          child: Text(
                            button1,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 20.w,
                      ),
                      Expanded(
                          child: SizedBox(
                        height: 40.h,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xff384c70)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(13.0))),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            button2,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MychangDialog extends StatefulWidget {
  final String button1;
  final String button2;
  final Color button1color;
  final Color button2color;
  final String title;
  final IconData messageicon;

  final Color iconcolor;
  final int model;
  final int changvalue;
  const MychangDialog(
    this.changvalue, {
    Key? key,
    this.button1 = "取消",
    this.button2 = "确定",
    this.title = "提示信息",
    this.messageicon = Icons.message,
    this.iconcolor = Colors.yellow,
    this.button1color = Colors.blue,
    this.button2color = Colors.blue,
    this.model = 0,
  }) : super(key: key);

  @override
  _MychangDialogState createState() => _MychangDialogState();
}

class _MychangDialogState extends State<MychangDialog> {
  int changeValue = 0;
  @override
  void initState() {
    changeValue = widget.changvalue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: WillPopScope(
        onWillPop: () async {
          if (widget.model == 0) {
            return true;
          } else {
            return false;
          }
        },
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
                SizedBox(
                  height: 50,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(widget.title),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.warning,
                          color: widget.iconcolor,
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          child: const Text("-"),
                          onPressed: () {
                            changeValue--;
                            setState(() {});
                          },
                        )),
                        Expanded(
                            child: Center(child: Text(changeValue.toString()))),
                        Expanded(
                            child: ElevatedButton(
                          child: const Text("+"),
                          onPressed: () {
                            changeValue++;
                            setState(() {});
                          },
                        )),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                              widget.button1color,
                            )),
                            onPressed: () {
                              Navigator.pop(context,
                                  {"value": changeValue, "state": false});
                              // return false;
                            },
                            //color: widget.button1color,
                            child: Text(widget.button1),
                          ),
                        ),
                        const VerticalDivider(),
                        Expanded(
                          child: ElevatedButton(
                            //多功能按钮
                            onPressed: () {
                              Navigator.pop(context,
                                  {"value": changeValue, "state": true});
                              // Navigator.pop(context);
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                              widget.button1color,
                            )),
                            child: Text(
                              widget.button2,
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyEgditDialog extends StatefulWidget {
  final String egidtmessage;
  final String button1;
  final String button2;
  final Color button1color;
  final Color button2color;
  final String title;
  const MyEgditDialog(
    this.egidtmessage, {
    Key? key,
    this.button1 = "取消",
    this.button2 = "确定",
    this.title = "提示信息",
    this.button1color = Colors.white,
    this.button2color = Colors.white,
  }) : super(key: key);
  @override
  _MyEgditDialogState createState() => _MyEgditDialogState();
}

class _MyEgditDialogState extends State<MyEgditDialog> {
  late String egditshow;
  @override
  void initState() {
    egditshow = widget.egidtmessage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Center(
          child: Container(
            // color: Colors.white,
            width: 300.w,
            height: 200.h,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(13.0))),
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                  child: Text(
                    widget.title,
                    style: TextStyle(fontSize: 17.sp),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xffeeeeee),
                    child: Center(
                      child: TextField(
                          maxLines: 3,
                          //  controller: TextEditingController(text: egditshow),
                          onChanged: (value) {
                            setState(() {
                              egditshow = value;
                            });
                          }),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                          child: SizedBox(
                        height: 40.h,
                        child: OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xff384c70)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(13.0))),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          onPressed: () {
                            Navigator.pop(
                                context, {"state": false, "value": egditshow});
                            // return false;
                          },
                          child: Text(
                            widget.button1,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 20.w,
                      ),
                      Expanded(
                          child: SizedBox(
                        height: 40.h,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xff384c70)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(13.0))),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          onPressed: () {
                            Navigator.pop(
                                context, {"state": true, "value": egditshow});
                          },
                          child: Text(
                            widget.button2,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MySeleDialog extends Dialog {
  final String button1;
  final String button2;
  final Color button1color;
  final Color button2color;
  final String title;
  final IconData? messageicon;
  final List<String> message;
  final Color iconcolor;
  final int model;
  const MySeleDialog(
    this.message, {
    Key? key,
    this.button1 = "取消",
    this.button2 = "确定",
    this.title = "请选择图片来源",
    this.messageicon = Icons.message,
    this.iconcolor = Colors.yellow,
    this.button1color = Colors.white,
    this.button2color = Colors.white,
    this.model = 0,
  }) : super(key: key);

  List<Widget> buttonlist(context) {
    List<Widget> temp = [];
    for (var i = 0; i < message.length; i++) {
      temp.add(
        Container(
          padding: const EdgeInsets.all(5.0),
          width: 290.w,
          height: 50.h,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xff384c70)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0))),
                padding: MaterialStateProperty.all(EdgeInsets.zero)),
            child: Text(
              message[i],
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context, i + 1);
            },
          ),
        ),
      );
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: WillPopScope(
        onWillPop: () async {
          if (model == 0) {
            return true;
          } else {
            return false;
          }
        },
        child: Center(
          child: Container(
            width: 300.w,
            height: 300.h,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                  width: 2.w,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(13.0))),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.w,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(13.0))),
                  height: 50.h,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          title,
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xffeeeeee),
                    child: ListView(
                      children: buttonlist(context),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                  child: Container(
                    padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                    width: 150.w,
                    height: 40.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0))),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff384c70))),
                      onPressed: () {
                        Navigator.pop(context, 0);
                        // return false;
                      },
                      child: Text(
                        button1,
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyProgressDialog extends StatefulWidget {
  final String button1;
  final String button2;
  final Color button1color;
  final Color button2color;
  final String title;
  final IconData? messageicon;
  final String massage;
  final Color iconcolor;
  final int model;
  final int progresssmodel;
  const MyProgressDialog(
    this.massage, {
    Key? key,
    this.button1 = "取消",
    this.button2 = "隐藏",
    this.title = "提示信息",
    this.messageicon = Icons.message,
    this.iconcolor = Colors.yellow,
    this.button1color = Colors.white,
    this.button2color = Colors.white,
    this.model = 0,
    this.progresssmodel = 0, //监听下载的钥匙数据
  }) : super(key: key);

  @override
  State<MyProgressDialog> createState() => _MyProgressDialogState();
}

class _MyProgressDialogState extends State<MyProgressDialog> {
  late StreamSubscription eventBusDf;
  int progress = 0;
  @override
  void initState() {
    // eventBusDf = eventBus.on<DownFileEvent>().listen(
    //   (DownFileEvent event) {
    //     if (event.progress == 100) {
    //       eventBusDf.cancel();
    //       Navigator.pop(context, 3);
    //     }
    //     progress = event.progress;
    //     setState(() {});
    //   },
    // );
    super.initState();
  }

  @override
  void dispose() {
    // eventBusDf.cancel();
    super.dispose();
  }

  String progressvalue() {
    switch (widget.progresssmodel) {
      case 0:
        if (context.watch<AppProvid>().appdownload == 100) {
          Navigator.pop(context);
        }
        return "${context.watch<AppProvid>().appdownload}";
      case 1:
        if (context.watch<AppProvid>().keydatadownload == 100) {
          Navigator.pop(context);
        }
        return "${context.watch<AppProvid>().keydatadownload}";
      case 2:
        if (context.watch<AppProvid>().chipdatadownload == 100) {
          Navigator.pop(context);
        }
        return "${context.watch<AppProvid>().chipdatadownload}";
      default:
        return progress.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Center(
          child: Container(
            // color: Colors.white,
            width: 300.w,
            height: 250.h,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(13.0))),
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                  child: Center(
                    child: Text(
                      widget.title,
                      style: TextStyle(fontSize: 17.sp),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xffeeeeee),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.massage,
                          style: TextStyle(fontSize: 17.sp),
                        ),
                        SizedBox(
                          width: 50.r,
                          height: 50.r,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(progressvalue()),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                    width: 50.r,
                                    height: 50.r,
                                    child: const CircularProgressIndicator()),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                          child: SizedBox(
                        height: 40.h,
                        child: OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xff384c70)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(13.0))),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          onPressed: () {
                            if (widget.model == 3) {
                              Fluttertoast.showToast(msg: "当前进程无法取消,请等待进程运行完毕");
                            } else {
                              Navigator.pop(context, 0);
                            }
                            // return false;
                          },
                          child: Text(
                            widget.button1,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                      widget.model == 0
                          ? SizedBox(
                              width: 20.w,
                            )
                          : const SizedBox(),
                      widget.model == 0
                          ? Expanded(
                              child: SizedBox(
                              height: 40.h,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xff384c70)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13.0))),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero)),
                                onPressed: () {
                                  Navigator.pop(context, 1);
                                },
                                child: Text(
                                  widget.button2,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ))
                          : const SizedBox(),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
