import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:magictank/cncpage/basekey.dart';

import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';
import 'package:photo_view/photo_view.dart';

import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:video_player/video_player.dart';

import 'camerkeycanvas.dart';

class DiscoverKeyPage extends StatefulWidget {
  final Map arguments;
  const DiscoverKeyPage(
    this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  State<DiscoverKeyPage> createState() => _DiscoverKeyPageState();
}

class _DiscoverKeyPageState extends State<DiscoverKeyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userTankBar(context),
      body: DiscoverKey(widget.arguments),
    );
  }
}

class DiscoverKey extends StatefulWidget {
  final Map arguments;
  const DiscoverKey(this.arguments, {Key? key}) : super(key: key);

  @override
  State<DiscoverKey> createState() => _DiscoverKeyState();
}

const double min = pi * -2;
const double max = pi * 2;

const double minScale = 0.03;
const double defScale = 0.1;
const double maxScale = 0.6;

class _DiscoverKeyState extends State<DiscoverKey> {
  //late File _file;
  // late File _sample;
  // late File _lastCropped;

  late Uint8List imagememory;
  late PhotoViewControllerBase controller;
  late PhotoViewScaleStateController scaleStateController;
  ProgressDialog? pd;
  bool canbemove = false;
  String butstring = "固定";

  //late Map keydata;
  // int _pointers = 0;

  Offset touchoffect = const Offset(0, 0);
  double imagerotation = 0.0;
  double imagescale = 1.0;
  double imagepostx = 0.0;
  double imageposty = 0.0;
  //late Image _image;
  //dynamic _pickImageError;
  bool isVideo = false;
  int seletooth = 0; //选择的齿号
  int seleahnum = 0; //选择的齿深
  int tooth = 0; //齿数
  int toothnum = 0; //齿深数
  int calls = 0;
  int seleaxis = 0;
  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  Timer? timer;
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //   selepic();
    });

    //  keydata = Map.from(widget.arguments["keydata"]);
    //初始化一下数据 默认1号齿深
    //if (baseKey.side == 3 && baseKey.keyClass != 0) {
    //   tooth = baseKey.cuts * 2;
    //  } else {
    tooth = baseKey.cuts;
    // }
    toothnum = baseKey.toothDepth.length;

    controller = PhotoViewController(initialScale: 1)
      ..outputStateStream.listen(onController);

    scaleStateController = PhotoViewScaleStateController()
      ..outputScaleStateStream.listen(onScaleState);

    //_image
    super.initState();
  }

  void _longPress(int model) {
    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 100), (v) {
      switch (model) {
        case 0: //放大长按

          imagescale = imagescale + 0.01;
          controller.scale = imagescale;
          setState(() {});
          break;
        case 1: //缩小长按
          imagescale = imagescale - 0.01;
          controller.scale = imagescale;
          setState(() {});
          break;
        case 2: //左转长按
          imagerotation = imagerotation + 0.01;
          controller.rotation = imagerotation;
          setState(() {});
          break;
        case 3: //右转长按
          imagerotation = imagerotation - 0.01;
          controller.rotation = imagerotation;
          setState(() {});
          break;
      }
    });
  }

  _asynctooth() {
    //双边计算方法;
    print(baseKey.keyClass);
    print(baseKey.side);
    print(seleaxis);
    if (baseKey.side == 3 && baseKey.keyClass != 0) {
      if (seleaxis == 0) {
        if (baseKey.keyClass == 4) {
          baseKey.bhNum[seletooth] = baseKey.toothDepth[seleahnum];

          baseKey.bhNums[seletooth] = baseKey.toothDepthName[seleahnum];
        } else if (baseKey.keyClass == 13) {
          print(baseKey.toothDepth.length);
          if (seleahnum > 4) {
            baseKey.ahNum[seletooth] = baseKey.toothDepth[seleahnum];
          } else {
            baseKey.ahNum[seletooth] =
                baseKey.wide - baseKey.groove - baseKey.toothDepth[seleahnum];
          }
          if (seleahnum <= 4) {
            baseKey.bhNum[seletooth] = baseKey.toothDepth[seleahnum];
          } else {
            baseKey.bhNum[seletooth] =
                baseKey.wide - baseKey.groove - baseKey.toothDepth[seleahnum];
          }
        } else {
          baseKey.ahNum[seletooth] = baseKey.toothDepth[seleahnum];

          baseKey.ahNums[seletooth] = baseKey.toothDepthName[seleahnum];
        }
      } else {
        if (baseKey.keyClass == 4) {
          baseKey.ahNum[seletooth] = baseKey.toothDepth[seleahnum];

          baseKey.ahNums[seletooth] = baseKey.toothDepthName[seleahnum];
        } else {
          baseKey.bhNum[seletooth] = baseKey.toothDepth[seleahnum];
          baseKey.bhNums[seletooth] = baseKey.toothDepthName[seleahnum];
        }
      }
    } else {
      baseKey.ahNum[seletooth] = baseKey.toothDepth[seleahnum];
      baseKey.bhNum[seletooth] = baseKey.toothDepth[seleahnum];
      baseKey.ahNums[seletooth] = baseKey.toothDepthName[seleahnum];
      baseKey.bhNums[seletooth] = baseKey.toothDepthName[seleahnum];
    }
  }

  int getCurrentSeleahnum() {
    if (baseKey.side == 3 && baseKey.keyClass != 0) {
      for (var i = 0; i < toothnum; i++) {
        if (baseKey.keyClass == 4) {
          if (seleaxis == 0) {
            if (baseKey.ahNum[seletooth] == baseKey.toothDepth[i]) {
              return i;
            }
          } else {
            if (baseKey.bhNum[seletooth] == baseKey.toothDepth[i]) {
              return i;
            }
          }
        } else if (baseKey.keyClass == 13) {
          if (i > 4) {
            if (baseKey.ahNum[seletooth] == baseKey.toothDepth[i]) {
              return i;
            }
          } else {
            if (baseKey.bhNum[seletooth] == baseKey.toothDepth[i]) {
              return i;
            }
          }
        } else {
          if (seleaxis == 0) {
            if (baseKey.ahNum[seletooth] == baseKey.toothDepth[i]) {
              return i;
            }
          } else {
            if (baseKey.bhNum[seletooth] == baseKey.toothDepth[i]) {
              return i;
            }
          }
        }
      }
    } else {
      for (var i = 0; i < toothnum; i++) {
        if (baseKey.ahNum[seletooth] == baseKey.toothDepth[i]) {
          return i;
        }
      }
    }
//print"未找到");
    return 0;
  }

  void onController(PhotoViewControllerValue value) {
    // print("object");
    // setState(() {
    //   calls += 1;
    // });
    imagescale = value.scale!;
    imagerotation = value.rotation;
  }

  void onScaleState(PhotoViewScaleState scaleState) {}

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

//
  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  @override
  Widget build(BuildContext context) {
    return // filepath != ""?
        SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Stack(
        children: [
          //Text(filepath),
          Align(
            child: CustomPaint(
              size: const Size(double.maxFinite / 2, double.maxFinite / 2),
              foregroundPainter: CamerPainter(
                touchoffect,
                seletooth,
                seleaxis,
                seleahnum,
              ),
              child: PhotoView(
                imageProvider: FileImage(File(widget.arguments["filepath"])),
                enableRotation: false,
                controller: controller,
                enablePanAlways: true,
                disableGestures: false, //关闭手势操作
              ),
            ),
            alignment: Alignment.center,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50.r,
                  width: 50.r,
                  child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: Image.asset("image/tank/Icon_moveup.png"),
                    onPressed: () {
                      seletooth = seletooth + 1;
                      if (seletooth > tooth - 1) {
                        seletooth = 0;
                      }
                      seleahnum = getCurrentSeleahnum();
                      _asynctooth();
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  height: 50.r,
                  width: 50.r,
                  child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: Image.asset("image/tank/Icon_movedown.png"),
                    onPressed: () {
                      seletooth--;
                      if (seletooth < 0) {
                        seletooth = tooth - 1;
                      }
                      seleahnum = getCurrentSeleahnum();
                      //print(seleahnum);
                      _asynctooth();
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  height: 50.r,
                  width: 50.r,
                  child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: Image.asset("image/tank/Icon_moveleft.png"),
                    onPressed: () {
                      // if (baseKey.keyClass == 4) {
                      //   if (seleaxis == 0) {
                      //     seleahnum--;
                      //     if (seleahnum < 0) {
                      //       seleahnum = toothnum - 1;
                      //     }
                      //   } else
                      //   {
                      //     seleahnum++;
                      //     if (seleahnum > toothnum - 1) {
                      //       seleahnum = 0;
                      //     }
                      //   }
                      // } else
                      {
                        if (seleaxis == 1 || baseKey.keyClass == 13) {
                          seleahnum--;
                          if (seleahnum < 0) {
                            seleahnum = toothnum - 1;
                          }
                        } else {
                          seleahnum++;
                          if (seleahnum > toothnum - 1) {
                            seleahnum = 0;
                          }
                        }
                      }
                      _asynctooth();
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  height: 50.r,
                  width: 50.r,
                  child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: Image.asset("image/tank/Icon_moveright.png"),
                    onPressed: () {
                      // if (baseKey.keyClass == 4) {
                      //   if (seleaxis == 1) {
                      //     seleahnum++;
                      //     if (seleahnum > toothnum - 1) {
                      //       seleahnum = 0;
                      //     }
                      //   } else {
                      //     seleahnum--;
                      //     if (seleahnum < 0) {
                      //       seleahnum = toothnum - 1;
                      //     }
                      //   }
                      // } else
                      {
                        if (seleaxis == 1 || baseKey.keyClass == 13) {
                          seleahnum++;
                          if (seleahnum > toothnum - 1) {
                            seleahnum = 0;
                          }
                        } else {
                          seleahnum--;
                          if (seleahnum < 0) {
                            seleahnum = toothnum - 1;
                          }
                        }
                      }
                      _asynctooth();
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),

          Align(
            child: SizedBox(
              width: 100.w,
              height: 48.h,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xff384c70))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(S.of(context).okbt)),
            ),
            alignment: Alignment.bottomCenter,
          ),
          (baseKey.keyClass == 2 || baseKey.keyClass == 4)
              ? Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      margin: EdgeInsets.only(top: 10.h),
                      width: 180.w,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 31.r,
                            height: 31.r,
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(seleaxis == 0
                                          ? 0XFFFF8915
                                          : 0xff384c70))),
                              onPressed: () {
                                seleaxis = 0;
                                setState(() {});
                              },
                              child: Center(
                                child: Text(
                                  "A",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.sp),
                                ),
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          SizedBox(
                            width: 31.r,
                            height: 31.r,
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(seleaxis == 1
                                          ? 0XFFFF8915
                                          : 0xff384c70))),
                              onPressed: () {
                                seleaxis = 1;
                                setState(() {});
                              },
                              child: Center(
                                child: Text(
                                  "B",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.sp),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                )
              : const SizedBox(),

          Align(
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 50.r,
                  height: 50.r,
                  child: GestureDetector(
                    onPanDown: (details) {
                      imagescale = imagescale + 0.001;
                      controller.scale = imagescale;
                      setState(() {});
                    },
                    onLongPressStart: (details) {
                      // sendmotor(0);

                      _longPress(0);
                    },
                    onLongPressEnd: (details) {
                      //   timer!.cancel();
                      if (timer != null) {
                        timer!.cancel();
                      }
                    },
                    child: Image.asset("image/tank/Icon_enlarge.png"),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: 50.r,
                  height: 50.r,
                  child: GestureDetector(
                      onPanDown: (details) {
                        imagescale = imagescale - 0.001;
                        controller.scale = imagescale;
                        setState(() {});
                      },
                      onLongPressStart: (details) {
                        // sendmotor(0);
                        _longPress(1);
                      },
                      onLongPressEnd: (details) {
                        //   timer!.cancel();
                        if (timer != null) {
                          timer!.cancel();
                        }
                      },
                      child: Image.asset("image/tank/Icon_narrow.png")),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: 50.r,
                  height: 50.r,
                  child: GestureDetector(
                      onPanDown: (details) {
                        imagerotation = imagerotation + 0.01;
                        controller.rotation = imagerotation;
                        setState(() {});
                      },
                      onLongPressStart: (details) {
                        // sendmotor(0);

                        _longPress(2);
                      },
                      onLongPressEnd: (details) {
                        //   timer!.cancel();
                        if (timer != null) {
                          timer!.cancel();
                        }
                      },
                      child: Image.asset("image/tank/Icon_turnleft.png")),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  width: 50.r,
                  height: 50.r,
                  child: GestureDetector(
                      onPanDown: (details) {
                        imagerotation = imagerotation - 0.01;
                        controller.rotation = imagerotation;
                        setState(() {});
                      },
                      onLongPressStart: (details) {
                        // sendmotor(0);
                        _longPress(3);
                      },
                      onLongPressEnd: (details) {
                        //   timer!.cancel();
                        if (timer != null) {
                          timer!.cancel();
                        }
                      },
                      child: Image.asset("image/tank/Icon_turnright.png")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // : SizedBox(
    //     child: TextButton(onPressed: () {}, child: Text("请选择一张图片")),
    //   );
  }
}
