import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
//import 'package:scoped_model/scoped_model.dart';

//import 'cutpreview_page.dart';

class CutReadyPage extends StatefulWidget {
  final Map keydata;
  final bool highmodel;
  const CutReadyPage(this.keydata, this.highmodel, {Key? key})
      : super(key: key);

  @override
  State<CutReadyPage> createState() => _CutReadyPageState();
}

class _CutReadyPageState extends State<CutReadyPage> {
  late int cutdepth;
  bool model = false;
  int diff = 0;
  double height = 380.h;
  @override
  void initState() {
    cutdepth = widget.keydata["depth"];

    if (baseKey.issmart) {
      height = height + 50.h;
    }
    super.initState();
  }

  bool showNon() {
    if (widget.highmodel &&
        !baseKey.isnonconductive &&
        (baseKey.keyClass != 0) &&
        (baseKey.keyClass != 1) &&
        (baseKey.keyClass != 6) &&
        !baseKey.issmart) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: SizedBox(
          width: 300.r,
          height: height,
          child: Column(
            children: [
              Container(
                width: 300.r,
                height: 50.r,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(13.0),
                      topRight: Radius.circular(13.0),
                    )),
                child: Center(
                    child: Text(
                  S.of(context).cuttingkey,
                  style: TextStyle(
                    fontSize: 17.sp,
                  ),
                )),
              ),
              Container(
                width: 300.r,
                height: 30.r,
                color: const Color(0xff384c70),
                child: Center(
                  child: Text(
                    S.of(context).cutdepth,
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ),
              ),
              // Container(
              //   width: 300.r,
              //   height: 20.r,
              //   color: const Color(0xffeeeeee),
              // ),
              SizedBox(
                width: 300.r,
                height: 200.r,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "image/tank/Icon_cutdepth.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.only(right: 15.r, bottom: 9.h),
                        width: 146.r,
                        height: 20.r,
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (baseKey.keyClass == 0 ||
                                        baseKey.keyClass == 1) {
                                      Fluttertoast.showToast(
                                          msg: S.of(context).nosupoort);
                                    } else {
                                      diff = diff - 1;
                                      if (diff < -10) {
                                        diff = -10;
                                      }
                                    }
                                  });
                                },
                                child: const Text("-"),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                  ((cutdepth + diff) / 100).toString() + "mm",
                                  textAlign: TextAlign.center),
                              flex: 2,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (baseKey.keyClass == 0 ||
                                        baseKey.keyClass == 1) {
                                      Fluttertoast.showToast(
                                          msg: S.of(context).nosupoort);
                                    } else {
                                      diff++;
                                      if (diff > 10) {
                                        diff = 10;
                                      }
                                    }
                                  });
                                },
                                child: const Text("+"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //50.r
              showNon()
                  ? Container(
                      width: 300.r,
                      height: 50.r,
                      color: const Color(0xffeeeeee),
                      child: CheckboxListTile(
                          onChanged: (bool? value) {
                            model = !model;
                            if (model) {
                              showDialog(
                                  context: context,
                                  builder: (c) {
                                    return MyTextDialog(
                                        S.of(context).cutnontip);
                                  });
                            }
                            setState(() {});
                          },
                          value: model,
                          title: Text(S.of(context).nondatabase)))
                  : Container(
                      width: 300.r,
                      height: 50.r,
                      color: const Color(0xffeeeeee),
                      child: CheckboxListTile(
                          onChanged: (bool? value) {
                            if (value!) {
                              baseKey.x = 1;
                            } else {
                              baseKey.x = 0;
                            }
                            setState(() {});
                          },
                          value: baseKey.x == 1 ? true : false,
                          title: Text(S.of(context).specialkey))),
              baseKey.issmart
                  ? Container(
                      width: 300.r,
                      height: 50.r,
                      color: const Color(0xffeeeeee),
                      child: CheckboxListTile(
                          onChanged: (bool? value) {
                            setState(() {
                              if (value!) {
                                baseKey.dir = 1;
                                showDialog(
                                    context: context,
                                    builder: (c) {
                                      return MyTextDialog(
                                          S.of(context).smartkeyside2clamp);
                                    }).then((value) {
                                  if (value) {
                                    Navigator.pushNamed(context, '/openclamp',
                                        arguments: {
                                          "keydata": widget.keydata,
                                          "state": false,
                                          "side": 2
                                        });
                                  }
                                });
                              } else {
                                baseKey.dir = 0;
                              }
                            });
                          },
                          value: baseKey.dir == 1 ? true : false,
                          title: Text(
                            S.of(context).smartkeyside2,
                            style: const TextStyle(color: Colors.red),
                          )))
                  : Container(),
              //50.r
              Container(
                width: 300.r,
                height: 50.r,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(13.0),
                      bottomRight: Radius.circular(13.0),
                    )),
                child: Row(
                  children: [
                    SizedBox(
                      width: 150.r,
                      height: 41.r,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70))),
                        onPressed: () {
                          Navigator.pop(context, {"state": false});
                        },
                        child: Text(S.of(context).cancel),
                      ),
                    ),
                    SizedBox(
                      width: 150.r,
                      height: 41.r,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff384c70))),
                        onPressed: () {
                          Navigator.pop(context, {
                            "state": true,
                            "model": false,
                            "depth": (cutdepth + diff)
                          });
                        },
                        child: Text(S.of(context).continuebt),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
