import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:magictank/appdata.dart';
import 'package:magictank/generated/l10n.dart';

class GuideMainPage extends StatefulWidget {
  const GuideMainPage({Key? key}) : super(key: key);
  @override
  State<GuideMainPage> createState() => _GuideMainPageState();
}

class _GuideMainPageState extends State<GuideMainPage> {
  int step = 0;
  String gettip() {
    switch (step) {
      case 0:
        return S.of(context).cncguide1;
      case 1:
        return S.of(context).cncguide2;
      case 2:
        return S.of(context).cncguide3;
      case 3:
        return S.of(context).cncguide4;
      case 4:
        return S.of(context).cncguide5;
      case 5:
        return S.of(context).cncguide6;
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: GestureDetector(
          onTapDown: (d) {
            step++;
            if (step > 5) {
              Navigator.pop(context, true);
              //step = 0;
            }
            setState(() {});
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      color: Colors.black38,
                      height: 183.h,
                    ),
                    Expanded(
                        child: Container(
                      width: double.maxFinite,
                      color: Colors.black38,
                    )),
                    SizedBox(
                      width: double.maxFinite,
                      height: 230.h,
                      // color: Colors.black38,
                      child: Column(children: [
                        Container(
                          width: double.maxFinite,
                          color: Colors.black38,
                          height: 14.h,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 29.w,
                              height: 50.h,
                              color: Colors.black38,
                            ),
                            step == 0
                                ? SizedBox(
                                    width: 86.w,
                                    height: 50.h,
                                    child: Image.asset(
                                      "image/share/Icon_sele.png",
                                      color: Colors.black38,
                                      fit: BoxFit.cover,
                                    ))
                                : Container(
                                    width: 86.w,
                                    height: 50.h,
                                    color: Colors.black38,
                                  ),
                            Expanded(
                                child: Container(
                              height: 50.h,
                              color: Colors.black38,
                            )),
                            Container(
                              height: 50.h,
                              color: Colors.black38,
                            ),
                            Expanded(
                                child: Container(
                              height: 50.h,
                              color: Colors.black38,
                            )),
                            step == 1
                                ? SizedBox(
                                    width: 86.w,
                                    height: 50.h,
                                    child: Image.asset(
                                      "image/share/Icon_sele.png",
                                      color: Colors.black38,
                                      fit: BoxFit.cover,
                                    ))
                                : Container(
                                    height: 50.h,
                                    color: Colors.black38,
                                  ),
                            Container(
                              width: 29.w,
                              height: 50.h,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                        Expanded(
                            child: Container(
                          color: Colors.black38,
                        )),
                        Row(
                          children: [
                            Container(
                              width: 29.w,
                              height: 50.h,
                              color: Colors.black38,
                            ),
                            step == 2
                                ? SizedBox(
                                    width: 86.w,
                                    height: 50.h,
                                    child: Image.asset(
                                      "image/share/Icon_sele.png",
                                      color: Colors.black38,
                                      fit: BoxFit.cover,
                                    ))
                                : Container(
                                    height: 50.h,
                                    color: Colors.black38,
                                  ),
                            Expanded(
                                child: Container(
                              height: 50.h,
                              color: Colors.black38,
                            )),
                            Container(
                              height: 50.h,
                              color: Colors.black38,
                            ),
                            Expanded(
                                child: Container(
                              height: 50.h,
                              color: Colors.black38,
                            )),
                            step == 3
                                ? SizedBox(
                                    width: 86.w,
                                    height: 50.h,
                                    child: Image.asset(
                                      "image/share/Icon_sele.png",
                                      color: Colors.black38,
                                      fit: BoxFit.cover,
                                    ))
                                : Container(
                                    height: 50.h,
                                    color: Colors.black38,
                                  ),
                            Container(
                              width: 29.w,
                              height: 50.h,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                        Expanded(
                            child: Container(
                          color: Colors.black38,
                        )),
                        Row(
                          children: [
                            Container(
                              width: 29.w,
                              height: 50.h,
                              color: Colors.black38,
                            ),
                            step == 4
                                ? SizedBox(
                                    width: 86.w,
                                    height: 50.h,
                                    child: Image.asset(
                                      "image/share/Icon_sele.png",
                                      color: Colors.black38,
                                      fit: BoxFit.cover,
                                    ))
                                : Container(
                                    width: 86.w,
                                    height: 50.h,
                                    color: Colors.black38,
                                  ),
                            Expanded(
                                child: Container(
                              height: 50.h,
                              color: Colors.black38,
                            )),
                            Container(
                              width: 86.w,
                              height: 50.h,
                              color: Colors.black38,
                            ),
                            Expanded(
                                child: Container(
                              height: 50.h,
                              color: Colors.black38,
                            )),
                            Container(
                              width: 86.w,
                              height: 50.h,
                              color: Colors.black38,
                            ),
                            Container(
                              width: 29.w,
                              height: 50.h,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                        Container(
                          width: double.maxFinite,
                          color: Colors.black38,
                          height: 14.h,
                        ),
                      ]),
                    ),
                    Expanded(
                        child: Container(
                      width: double.maxFinite,
                      color: Colors.black38,
                    )),
                    Container(
                      width: double.maxFinite,
                      color: Colors.black38,
                      height: 34.h,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: 48.h,
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            height: 50.h,
                            color: Colors.black38,
                          )),
                          Expanded(
                              child: Container(
                            height: 50.h,
                            color: Colors.black38,
                          )),
                          Expanded(
                              child: Container(
                            height: 50.h,
                            color: Colors.black38,
                          )),
                          Expanded(
                            child: step == 5
                                ? SizedBox(
                                    width: 86.w,
                                    height: 50.h,
                                    child: Image.asset(
                                      "image/share/Icon_sele.png",
                                      color: Colors.black38,
                                      fit: BoxFit.cover,
                                    ))
                                : Container(
                                    height: 50.h,
                                    color: Colors.black38,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  left: 10.w,
                  top: 130.h,
                  child: Container(
                    width: 340.w,
                    height: 90.h,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("image/share/guidetip.png"),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 17.w,
                          top: 19.h,
                          child: Text("${step + 1}/7",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
                              )),
                        ),
                        Positioned(
                          left: 17.w,
                          top: 56.h,
                          child: Text(gettip(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                              )),
                        ),
                      ],
                    ),
                  )),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {
                    appData.upgradeAppData({"cncguide": false});
                    Navigator.pop(context, true);
                  },
                  child: Container(
                      width: 45.w,
                      height: 25.h,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Center(
                        child: Text(
                          S.of(context).jump,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )),
                ),
              )
            ],
          )),
    );
  }
}

class GuideSetPage extends StatefulWidget {
  const GuideSetPage({Key? key}) : super(key: key);

  @override
  State<GuideSetPage> createState() => _GuideSetPageState();
}

class _GuideSetPageState extends State<GuideSetPage> {
  int step = 0;
  String gettip() {
    switch (step) {
      case 0:
        return S.of(context).cncguide1;
      case 1:
        return S.of(context).cncguide2;
      case 2:
        return S.of(context).cncguide3;
      case 3:
        return S.of(context).cncguide4;
      case 4:
        return S.of(context).cncguide5;
      case 5:
        return S.of(context).cncguide6;
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: GestureDetector(
          onTapDown: (d) {
            Navigator.pop(context);
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      color: Colors.black38,
                      height: 220.h,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: 150.h,
                    ),
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        color: Colors.black38,
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  left: 10.w,
                  top: 130.h,
                  child: Container(
                    width: 340.w,
                    height: 90.h,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("image/share/guidetip.png"),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 17.w,
                          top: 19.h,
                          child: Text("7/7",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
                              )),
                        ),
                        Positioned(
                            left: 17.w,
                            top: 45.h,
                            child: SizedBox(
                              width: 340.w,
                              child: Text(S.of(context).cncguide7,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                  )),
                            )),
                      ],
                    ),
                  )),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Container(
                      width: 45.w,
                      height: 25.h,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Center(
                        child: Text(
                          S.of(context).jump,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )),
                ),
              )
            ],
          )),
    );
  }
}
