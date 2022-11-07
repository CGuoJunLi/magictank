import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/cncpage/bluecmd/cmd.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/cncpage/bluecmd/sendcmd.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/cncpage/bluecmd/share_manganger.dart';
import 'package:magictank/cncpage/mycontainer.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

class ClampState {
  static const continues = 0;
}

class OpenClampPage extends StatefulWidget {
  final Map arguments;
  const OpenClampPage(
    this.arguments, {
    Key? key,
  }) : super(key: key);
  @override
  _OpenClampPageState createState() => _OpenClampPageState();
}

class _OpenClampPageState extends State<OpenClampPage> {
  // Map keydata = {};
  List<String> title = [];
  List<String> image = [];
  String gifPath = "";
  bool dir = false;

  @override
  void initState() {
    try {
      sendCmd([cncBtSmd.openClamp, 0, baseKey.fixture]);
    } catch (e) {
      debugPrint("蓝牙未连接");
    }
    if (widget.arguments["dir"] != null) {
      dir = widget.arguments["dir"];
      // if (dir) {
      //   SystemChrome.setPreferredOrientations(
      //       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      //   //设置状态栏隐藏
      //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      //       overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      // }
    }
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    //设置状态栏隐藏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    // keydata = Map.from(widget.arguments["keydata"]);
    // getListTitle();
    // print(
    //     "id:${baseKey.keySerNum},fixtrue:${baseKey.fixture},locat:${baseKey.locat},issmart:${baseKey.issmart}");
    // initListTitle();
    super.initState();
  }

  _newfixture() {
    //新夹具
    switch (baseKey.fixture) {
      case 0: //左侧夹块
      case 4:
      case 3:
        //选择需要显示的gif
        switch (baseKey.keySerNum) {
          case 70: //hu64
          case 177:
          case 178:
          case 901:
            if (widget.arguments["side"] == 2) {
              gifPath = appData.keyImagePath + "/fixture/1_hu64b.gif";
            } else {
              gifPath = appData.keyImagePath + "/fixture/1_hu64a.gif";
            }
            break;
          case 65:
            gifPath = appData.keyImagePath + "/fixture/1_hu101.gif";
            break;
          case 158:
          case 159:
          case 242:
            if (widget.arguments["side"] == 2) {
              gifPath = appData.keyImagePath + "/fixture/1_huhu162ta2.gif";
            } else {
              gifPath = appData.keyImagePath + "/fixture/1_huhu162ta1.gif";
            }
            break;
          case 510:
            gifPath = appData.keyImagePath + "/fixture/1_huhu162tb.gif";
            break;
          case 511:
            gifPath = appData.keyImagePath + "/fixture/1_huhu162tc.gif";
            break;
          default:
            if (baseKey.locat == 1) {
              gifPath = appData.keyImagePath + "/fixture/1_0_1.gif";
            } else {
              gifPath = appData.keyImagePath + "/fixture/1_0_0.gif";
            }
            break;
        }
        //获取夹具或者显示的内容
        if (baseKey.issmart) {
          _newsmartfixture();
        } else {
          if (baseKey.isnonconductive) {
            _newnonfixture();
          } else {
            if (baseKey.locat == 0) {
              //对肩膀
              title.add(S.of(context).fixture0_0_1_1);
              title.add(S.of(context).fixture0_0_1_2);
              for (var i = 1; i < 3; i++) {
                image.add("1_0_0_$i.png");
              }
            } else {
              //对头
              switch (baseKey.keySerNum) {
                case 65:
                  title.add(S.of(context).fixture_hu101_1_1);
                  title.add(S.of(context).fixture_hu101_1_2);
                  for (var i = 1; i < 3; i++) {
                    image.add("1_hu101_$i.png");
                  }
                  break;
                case 70: //hu64
                case 177:
                case 178:
                case 901:
                  if (widget.arguments["side"] == 2) {
                    gifPath = appData.keyImagePath + "/fixture/1_hu64b.gif";
                  } else {
                    gifPath = appData.keyImagePath + "/fixture/1_hu64a.gif";
                  }
                  title.add(S.of(context).fixture_hu64_1_1);
                  title.add(S.of(context).fixture_hu64_1_2);
                  if (widget.arguments["side"] == 2) {
                    for (var i = 3; i < 5; i++) {
                      image.add("1_hu64_$i.png");
                    }
                  } else {
                    for (var i = 1; i < 3; i++) {
                      image.add("1_hu64_$i.png");
                    }
                  }
                  break;
                case 158: //hu162t
                case 159:
                case 242:
                  if (widget.arguments["side"] == 2) {
                    title.add(S.of(context).fixture_hu162ta_1_3);
                    title.add(S.of(context).fixture_hu162ta_1_4);
                    for (var i = 3; i < 5; i++) {
                      image.add("1_hu162ta_$i.png");
                    }
                  } else {
                    title.add(S.of(context).fixture_hu162ta_1_1);
                    title.add(S.of(context).fixture_hu162ta_1_2);
                    for (var i = 1; i < 3; i++) {
                      image.add("1_hu162ta_$i.png");
                    }
                  }
                  break;
                case 510: //hu162t B
                  title.add(S.of(context).fixture_hu162tb_1_1);
                  title.add(S.of(context).fixture_hu162tb_1_2);
                  title.add(S.of(context).fixture_hu162tb_1_3);
                  for (var i = 1; i < 4; i++) {
                    image.add("1_hu162tb_$i.png");
                  }
                  break;
                case 511: //hu162t C
                  title.add(S.of(context).fixture_hu162tc_1_1);
                  title.add(S.of(context).fixture_hu162tc_1_2);
                  for (var i = 1; i < 3; i++) {
                    image.add("1_hu162tc_$i.png");
                  }
                  break;
                default:
                  title.add(S.of(context).fixture0_1_1_1);
                  title.add(S.of(context).fixture0_1_1_2);
                  for (var i = 1; i < 3; i++) {
                    image.add("1_0_1_$i.png");
                  }
                  break;
              }
            }
          }
        }

        break;
      case 2: //奔驰小夹具
        //新夹具
        if (widget.arguments["side"] == 2) {
          gifPath = appData.keyImagePath + "/fixture/1_hu64b.gif";
        } else {
          gifPath = appData.keyImagePath + "/fixture/1_hu64a.gif";
        }
        title.add(S.of(context).fixture_hu64_1_1);
        title.add(S.of(context).fixture_hu64_1_2);
        if (widget.arguments["side"] == 2) {
          for (var i = 3; i < 5; i++) {
            image.add("1_hu64_$i.png");
          }
        } else {
          for (var i = 1; i < 3; i++) {
            image.add("1_hu64_$i.png");
          }
        }

        break;
      case 1: //民用钥匙  只有新夹具
        switch (baseKey.keySerNum) {
          default:
            gifPath = appData.keyImagePath + "/fixture/1_1_0.gif";
            title.add(S.of(context).fixture1_1_1);
            title.add(S.of(context).fixture1_1_2);
            title.add(S.of(context).fixture1_1_3);
            title.add(S.of(context).fixture1_1_4);
            title.add(S.of(context).fixture1_1_5);
            title.add(S.of(context).fixture1_1_6);
            title.add(S.of(context).fixture1_1_7);

            for (var i = 1; i < 8; i++) {
              image.add("1_1_0_$i.png");
            }
            break;
        }

        break;
      case 5: //右侧夹块
        //先获取GIF
        switch (baseKey.keySerNum) {
          case 785: //TOY2
            gifPath = appData.keyImagePath + "/fixture/1_toy2.gif";
            break;
          case 22: //SX9A
            gifPath = appData.keyImagePath + "/fixture/1_sx9a.gif";
            break;
          case 21: //SX9B
            gifPath = appData.keyImagePath + "/fixture/1_sx9b.gif";
            break;
          case 822: //bw9te
            gifPath = appData.keyImagePath + "/fixture/1_bw9te.gif";
            break;
          case 831:
          case 878:
            gifPath = appData.keyImagePath + "/fixture/1_tata.gif";
            break;
          case 1397:
            gifPath = appData.keyImagePath + "/fixture/1_siyu1a.gif";
            break;
          case 1398:
            gifPath = appData.keyImagePath + "/fixture/1_siyu1b.gif";
            break;
          default:
            if (baseKey.locat == 1) {
              //对头类钥匙
              switch (baseKey.keyClass) {
                case 0: //平铣双边
                  gifPath = appData.keyImagePath + "/fixture/1_50_1.gif";
                  break;
                case 1: //平铣单边
                  gifPath = appData.keyImagePath + "/fixture/1_51_1.gif";
                  break;
                default: //立铣类型
                  gifPath = appData.keyImagePath + "/fixture/1_54_1.gif";
                  break;
              }
            } else {
              //对肩膀
              switch (baseKey.keyClass) {
                case 0: //平铣双边
                  gifPath = appData.keyImagePath + "/fixture/1_50_0.gif";
                  break;
                case 1: //平铣单边
                  gifPath = appData.keyImagePath + "/fixture/1_51_0.gif";
                  break;
                default: //立铣类型
                  gifPath = appData.keyImagePath + "/fixture/1_54_0.gif";
                  break;
              }
            }
            break;
        }
        //获取说明
        if (baseKey.locat == 0) {
          //对肩膀
          switch (baseKey.keySerNum) {
            case 822:
              title.add(S.of(context).fixture8_0_1_1);
              title.add(S.of(context).fixture8_0_1_2);
              title.add(S.of(context).fixture8_0_1_3);
              for (var i = 1; i < 4; i++) {
                image.add("1_bw9te_$i.png");
              }
              break;

            default:
              title.add(S.of(context).fixture5_0_1_1);
              title.add(S.of(context).fixture5_0_1_2);
              title.add(S.of(context).fixture5_0_1_3);

              switch (baseKey.keyClass) {
                case 1:
                  for (var i = 1; i < 4; i++) {
                    image.add("1_51_0_$i.png");
                  }
                  break;
                case 0:
                  for (var i = 1; i < 4; i++) {
                    image.add("1_50_0_$i.png");
                  }
                  break;
                default:
                  for (var i = 1; i < 4; i++) {
                    image.add("1_54_0_$i.png");
                  }
                  break;
              }
              break;
          }
        } else {
          //对头
          switch (baseKey.keySerNum) {
            case 831:
              title.add(S.of(context).fixture8_0_1_1);
              title.add(S.of(context).fixture8_0_1_2);
              title.add(S.of(context).fixture8_0_1_3);
              for (var i = 1; i < 4; i++) {
                image.add("1_tata_$i.png");
              }
              break;
            case 785:
              title.add(S.of(context).fixture_toy2_1_1);
              title.add(S.of(context).fixture_toy2_1_2);
              title.add(S.of(context).fixture_toy2_1_3);
              for (var i = 1; i < 4; i++) {
                image.add("1_toy2_$i.png");
              }
              break;
            case 1397: //思域1 A面
              title.add(S.of(context).fixture_siyu1_1_1);
              title.add(S.of(context).fixture_siyu1_1_2);
              title.add(S.of(context).fixture_siyu1_1_3);

              for (var i = 1; i < 4; i++) {
                image.add("1_siyu1_$i.png");
              }
              break;

            case 1398: //思域1 B面
              title.add(S.of(context).fixture_siyu1_1_4);
              title.add(S.of(context).fixture_siyu1_1_5);
              title.add(S.of(context).fixture_siyu1_1_6);

              for (var i = 4; i < 7; i++) {
                image.add("1_siyu1_$i.png");
              }
              break;
            case 22:
              title.add(S.of(context).fixture_sx9a_1_1);
              title.add(S.of(context).fixture_sx9a_1_2);
              title.add(S.of(context).fixture_sx9a_1_3);
              title.add(S.of(context).fixture_sx9a_1_4);
              for (var i = 1; i < 5; i++) {
                image.add("1_sx9a_$i.png");
              }
              break;
            case 21: //
              title.add(S.of(context).fixture_sx9b_1_1);
              title.add(S.of(context).fixture_sx9b_1_2);
              title.add(S.of(context).fixture_sx9b_1_3);
              title.add(S.of(context).fixture_sx9b_1_4);
              for (var i = 1; i < 5; i++) {
                image.add("1_sx9b_$i.png");
              }
              break;
            default:
              switch (baseKey.keyClass) {
                case 1:
                  title.add(S.of(context).fixture5_1_1_1);
                  title.add(S.of(context).fixture5_1_1_2);
                  title.add(S.of(context).fixture5_1_1_3);

                  for (var i = 1; i < 4; i++) {
                    image.add("1_51_1_$i.png");
                  }
                  break;
                case 0:
                  title.add(S.of(context).fixture5_1_1_1);
                  title.add(S.of(context).fixture5_1_1_2);
                  title.add(S.of(context).fixture5_1_1_3);

                  for (var i = 1; i < 4; i++) {
                    image.add("1_50_1_$i.png");
                  }
                  break;
                default:
                  title.add(S.of(context).fixture5_4_1_1);
                  title.add(S.of(context).fixture5_4_1_2);
                  title.add(S.of(context).fixture5_4_1_3);

                  for (var i = 1; i < 4; i++) {
                    image.add("1_54_1_$i.png");
                  }

                  break;
              }
              break;
          }
        }

        break;
      case 6: //FO21 TBE1 旋转夹具

        gifPath = appData.keyImagePath + "/fixture/1_fo21.gif";
        title.add(S.of(context).fixture_fo21_1_1);
        title.add(S.of(context).fixture_fo21_1_2);
        title.add(S.of(context).fixture_fo21_1_3);
        title.add(S.of(context).fixture_fo21_1_4);
        title.add(S.of(context).fixture_fo21_1_5);
        title.add(S.of(context).fixture_fo21_1_6);
        title.add(S.of(context).fixture_fo21_1_7);
        title.add(S.of(context).fixture_fo21_1_8);
        title.add(S.of(context).fixture_fo21_1_9);
        title.add(S.of(context).fixture_fo21_1_10);
        title.add(S.of(context).fixture_fo21_1_11);
        for (var i = 1; i < 12; i++) {
          image.add("1_6_1_$i.png");
        }

        break;
      case 7: //左边后侧对肩膀
        //如果是非导电的
        if (baseKey.isnonconductive) {
          _newnonfixture();
        } else {
          gifPath = appData.keyImagePath + "/fixture/1_hu66.gif";
          title.add(S.of(context).fixture_hu66_1_1);
          title.add(S.of(context).fixture_hu66_1_2);
          title.add(S.of(context).fixture_hu66_1_3);
          for (var i = 1; i < 4; i++) {
            image.add("1_7_0_$i.png");
          }
        }
        break;
      case 8: //右边后侧对肩膀
        switch (baseKey.keySerNum) {
          case 822:
            gifPath = appData.keyImagePath + "/fixture/1_bw9te.gif";
            title.add(S.of(context).fixture8_0_1_1);
            title.add(S.of(context).fixture8_0_1_2);
            title.add(S.of(context).fixture8_0_1_3);

            for (var i = 1; i < 4; i++) {
              image.add("1_bw9te_$i.png");
            }
            break;
          default:
            gifPath = appData.keyImagePath + "/fixture/1_8_0.gif";
            title.add(S.of(context).fixture8_0_1_1);
            title.add(S.of(context).fixture8_0_1_2);
            title.add(S.of(context).fixture8_0_1_3);

            for (var i = 1; i < 4; i++) {
              image.add("1_8_0_$i.png");
            }
            break;
        }

        break;
      case 9: //模型加工
        break;
      case 13: //非导电
        break;
    }
  }

  _oldfixture() {
    switch (baseKey.fixture) {
      case 0: //左侧夹块
      case 4:
      case 3:
        {
          //旧夹具图片
          switch (baseKey.keySerNum) {
            case 70:
            case 177:
            case 178:
            case 901:
              if (widget.arguments["side"] == 2) {
                gifPath = appData.keyImagePath + "/fixture/1_hu64b.gif";
              } else {
                gifPath = appData.keyImagePath + "/fixture/1_hu64a.gif";
              }
              break;
            case 65:
              gifPath = appData.keyImagePath + "/fixture/1_hu101.gif";
              break;
            case 158:
            case 159:
            case 242:
              if (widget.arguments["side"] == 2) {
                gifPath = appData.keyImagePath + "/fixture/1_huhu162ta2.gif";
              } else {
                gifPath = appData.keyImagePath + "/fixture/1_huhu162ta1.gif";
              }
              break;
            case 510:
              gifPath = appData.keyImagePath + "/fixture/1_huhu162tb.gif";
              break;
            case 511:
              gifPath = appData.keyImagePath + "/fixture/1_huhu162tc.gif";
              break;
            default:
              if (baseKey.locat == 1) {
                gifPath = appData.keyImagePath + "/fixture/1_0_1.gif";
              } else {
                gifPath = appData.keyImagePath + "/fixture/1_0_0.gif";
              }
              break;
          }
          if (baseKey.issmart) {
            _oldsmartfixture();
          } else {
            if (baseKey.isnonconductive) {
              _oldnonfixture();
            } else {
              if (baseKey.locat == 0) {
                //对肩膀
                title.add(S.of(context).fixture0_0_0_1);
                title.add(S.of(context).fixture0_0_0_2);

                for (var i = 1; i < 3; i++) {
                  image.add("0_0_$i.png");
                }
              } else {
                //对头
                title.add(S.of(context).fixture0_1_0_1);
                title.add(S.of(context).fixture0_1_0_2);
                for (var i = 1; i < 3; i++) {
                  image.add("0_1_$i.png");
                }
              }
            }
          }
        }
        break;
      case 2: //奔驰小夹具
        {
          if (widget.arguments["side"] == 2) {
            gifPath = appData.keyImagePath + "/fixture/0_hu64b.gif";
          } else {
            gifPath = appData.keyImagePath + "/fixture/0_hu64a.gif";
          }
          title.add(S.of(context).fixture_hu64_0_1);
          title.add(S.of(context).fixture_hu64_0_2);
          title.add(S.of(context).fixture_hu64_0_3);
          title.add(S.of(context).fixture_hu64_0_4);

          for (var i = 1; i < 5; i++) {
            image.add("0_hu64_$i.png");
          }
        }
        break;
      case 5: //旧夹具右侧夹块
        if (baseKey.locat == 0) {
          //对肩膀
          title.add(S.of(context).fixture5_0_0_1);
          title.add(S.of(context).fixture5_0_0_2);

          switch (baseKey.keyClass) {
            case 1:
              for (var i = 1; i < 2; i++) {
                image.add("0_51_0_$i.png");
              }
              break;
            case 0:
              for (var i = 1; i < 5; i++) {
                image.add("0_50_0_$i.png");
              }
              break;
            default:
              for (var i = 1; i < 5; i++) {
                image.add("0_54_0_$i.png");
              }
              break;
          }
        } else {
          //对头
          title.add(S.of(context).fixture5_1_0_1);
          title.add(S.of(context).fixture5_1_0_2);

          switch (baseKey.keyClass) {
            case 1:
              for (var i = 1; i < 3; i++) {
                image.add("0_51_1_$i.png");
              }
              break;
            case 0:
              for (var i = 1; i < 3; i++) {
                image.add("0_50_1_$i.png");
              }
              break;
            default:
              for (var i = 1; i < 3; i++) {
                image.add("0_54_1_$i.png");
              }
              break;
          }
        }

        break;
      case 6: //FO21 TBE1 旋转夹具

        gifPath = appData.keyImagePath + "/fixture/0_fo21.gif";
        title.add(S.of(context).fixture_fo21_0_1);
        title.add(S.of(context).fixture_fo21_0_2);
        title.add(S.of(context).fixture_fo21_0_3);
        title.add(S.of(context).fixture_fo21_0_4);
        title.add(S.of(context).fixture_fo21_0_5);
        title.add(S.of(context).fixture_fo21_0_6);
        title.add(S.of(context).fixture_fo21_0_7);
        title.add(S.of(context).fixture_fo21_0_8);
        title.add(S.of(context).fixture_fo21_0_9);
        title.add(S.of(context).fixture_fo21_0_10);
        title.add(S.of(context).fixture_fo21_0_11);
        for (var i = 1; i < 12; i++) {
          image.add("0_6_1_$i.png");
        }

        break;
      case 7: //左边后侧对肩膀
        //如果是非导电的
        if (baseKey.isnonconductive) {
          _oldnonfixture();
        } else {
          gifPath = appData.keyImagePath + "/fixture/1_hu66.gif";
          title.add(S.of(context).fixture_hu66_1_1);
          title.add(S.of(context).fixture_hu66_1_2);
          title.add(S.of(context).fixture_hu66_1_3);

          for (var i = 1; i < 3; i++) {
            image.add("1_7_0_$i.png");
          }
        }
        break;
      case 8: //右边后侧对肩膀
        switch (baseKey.keySerNum) {
          case 822:
            gifPath = appData.keyImagePath + "/fixture/0_bw9te.gif";
            title.add(S.of(context).fixture8_0_0_1);
            title.add(S.of(context).fixture8_0_0_2);
            for (var i = 1; i < 3; i++) {
              image.add("0_bw9te_$i.png");
            }
            break;
          default:
            gifPath = appData.keyImagePath + "/fixture/0_8_0.gif";
            title.add(S.of(context).fixture8_0_0_1);
            title.add(S.of(context).fixture8_0_0_2);

            for (var i = 1; i < 3; i++) {
              image.add("0_8_0_$i.png");
            }
            break;
        }
        break;
      case 9: //模型加工
        break;
      case 13: //非导电
        break;
    }
  }

  _newsmartfixture() {
    switch (baseKey.fixture) {
      case 0: //左侧夹块
      case 4:
      case 3:
        //智能卡类钥匙图片
        switch (baseKey.keySerNum) {
          case 65: //HU101
            if (widget.arguments["side"] == 2) //第二面反夹
            {
              gifPath = appData.keyImagePath + "/fixture/smart/1_hu101b.gif";
              title.add(S.of(context).fixture_smart_1_1);
              title.add(S.of(context).fixture_smart_1_2);
              title.add(S.of(context).fixture_smart_1_3);
              for (var i = 1; i < 4; i++) {
                image.add("smart/1_hu101_${i + 3}.png");
              }
            } else {
              gifPath = appData.keyImagePath + "/fixture/smart/1_hu101a.gif";
              title.add(S.of(context).fixture_smart_1_hu101_1);
              title.add(S.of(context).fixture_smart_1_hu101_2);

              for (var i = 1; i < 3; i++) {
                image.add("smart/1_hu101_$i.png");
              }
            }
            break;
          case 158:
          case 159:
            if (widget.arguments["side"] == 2) //
            {
              gifPath = appData.keyImagePath + "/fixture/smart/1_hu162ta2.gif";
              title.add(S.of(context).fixture_smart_1_1);
              title.add(S.of(context).fixture_smart_1_2);
              title.add(S.of(context).fixture_smart_1_3);
              for (var i = 1; i < 4; i++) {
                image.add("smart/1_hu162ta_${i + 3}.png");
              }
            } else {
              gifPath = appData.keyImagePath + "/fixture/smart/1_hu162ta1.gif";
              title.add(S.of(context).fixture0_1_1_1);
              title.add(S.of(context).fixture0_1_1_2);

              for (var i = 1; i < 3; i++) {
                image.add("smart/1_hu162ta_$i.png");
              }
            }
            break;
          case 510:
            gifPath = appData.keyImagePath + "/fixture/smart/1_hu162tb.gif";
            title.add(S.of(context).fixture_smart_1_hu162tb_1);
            title.add(S.of(context).fixture_smart_1_hu162tb_1);
            title.add(S.of(context).fixture_smart_1_hu162tb_3);
            for (var i = 1; i < 4; i++) {
              image.add("smart/1_hu162tb_$i.png");
            }
            break;
          case 511:
            gifPath = appData.keyImagePath + "/fixture/smart/1_hu162tc.gif";
            title.add(S.of(context).fixture_smart_1_hu162tc_1);
            title.add(S.of(context).fixture_smart_1_hu162tc_2);

            for (var i = 1; i < 3; i++) {
              image.add("smart/1_hu162tc_$i.png");
            }
            break;
          default:
            if (widget.arguments["side"] == 2) //第二面反夹
            {
              gifPath = appData.keyImagePath + "/fixture/smart/1_0_1b.gif";
              title.add(S.of(context).fixture_smart_1_1);
              title.add(S.of(context).fixture_smart_1_2);
              title.add(S.of(context).fixture_smart_1_3);
              for (var i = 1; i < 4; i++) {
                image.add("smart/1_0_1_${i + 3}.png");
              }
            } else {
              gifPath = appData.keyImagePath + "/fixture/smart/1_0_1a.gif";
              title.add(S.of(context).fixture0_1_1_1);
              title.add(S.of(context).fixture0_1_1_2);

              for (var i = 1; i < 3; i++) {
                image.add("smart/1_0_1_$i.png");
              }
            }
            break;
        }
        break;
      case 1:
        switch (baseKey.keySerNum) {
          case 10260:
            gifPath = appData.keyImagePath + "/fixture/1_siyu2a.gif";
            title.add(S.of(context).fixture_siyu2_1_1);
            title.add(S.of(context).fixture_siyu2_1_2);
            title.add(S.of(context).fixture_siyu2_1_3);
            title.add(S.of(context).fixture_siyu2_1_4);
            title.add(S.of(context).fixture_siyu2_1_5);
            title.add(S.of(context).fixture_siyu2_1_6);
            title.add(S.of(context).fixture_siyu2_1_7);
            title.add(S.of(context).fixture_siyu2_1_8);
            for (var i = 1; i < 9; i++) {
              image.add("1_siyu2_$i.png");
            }
            break;
          case 10261:
            gifPath = appData.keyImagePath + "/fixture/1_siyu2b.gif";
            title.add(S.of(context).fixture_siyu2_1_9);
            title.add(S.of(context).fixture_siyu2_1_10);
            title.add(S.of(context).fixture_siyu2_1_11);
            title.add(S.of(context).fixture_siyu2_1_12);
            title.add(S.of(context).fixture_siyu2_1_13);
            title.add(S.of(context).fixture_siyu2_1_14);
            title.add(S.of(context).fixture_siyu2_1_15);
            title.add(S.of(context).fixture_siyu2_1_16);
            for (var i = 9; i < 17; i++) {
              image.add("1_siyu2_$i.png");
            }
            break;
        }
        break;
    }
  }

  _oldsmartfixture() {
    switch (baseKey.fixture) {
      case 0: //左侧夹块
      case 4:
      case 3:
        {
          //智能卡类钥匙图片
          switch (baseKey.keySerNum) {
            case 65: //HU101
              if (widget.arguments["side"] == 2) //第二面反夹
              {
                gifPath = appData.keyImagePath + "/fixture/smart/1_hu101b.gif";
                title.add(S.of(context).fixture_smart_1_1);
                title.add(S.of(context).fixture_smart_1_2);
                title.add(S.of(context).fixture_smart_1_3);
                for (var i = 1; i < 4; i++) {
                  image.add("smart/1_hu101_${i + 3}.png");
                }
              } else {
                gifPath = appData.keyImagePath + "/fixture/smart/1_hu101a.gif";
                title.add(S.of(context).fixture_smart_1_1);
                title.add(S.of(context).fixture_smart_1_2);
                title.add(S.of(context).fixture_smart_1_3);
                for (var i = 1; i < 4; i++) {
                  image.add("smart/1_hu101_$i.png");
                }
              }
              break;

            case 158:
            case 159:
              if (widget.arguments["side"] == 2) //
              {
                gifPath =
                    appData.keyImagePath + "/fixture/smart/1_hu162ta2.gif";
                title.add(S.of(context).fixture_smart_1_1);
                title.add(S.of(context).fixture_smart_1_2);
                title.add(S.of(context).fixture_smart_1_3);
                for (var i = 1; i < 4; i++) {
                  image.add("smart/1_hu162ta_${i + 3}.png");
                }
              } else {
                gifPath =
                    appData.keyImagePath + "/fixture/smart/1_hu162ta1.gif";
                title.add(S.of(context).fixture_smart_1_1);
                title.add(S.of(context).fixture_smart_1_2);
                title.add(S.of(context).fixture_smart_1_3);
                for (var i = 1; i < 4; i++) {
                  image.add("smart/1_hu162ta_$i.png");
                }
              }
              break;
            case 510:
              gifPath = appData.keyImagePath + "/fixture/smart/1_hu162tb.gif";
              title.add(S.of(context).fixture_smart_1_1);
              title.add(S.of(context).fixture_smart_1_2);
              title.add(S.of(context).fixture_smart_1_3);
              for (var i = 1; i < 4; i++) {
                image.add("smart/1_hu162tb_$i.png");
              }
              break;
            case 511:
              gifPath = appData.keyImagePath + "/fixture/smart/1_hu162tc.gif";
              title.add(S.of(context).fixture_smart_1_1);
              title.add(S.of(context).fixture_smart_1_2);
              title.add(S.of(context).fixture_smart_1_3);
              for (var i = 1; i < 4; i++) {
                image.add("smart/1_hu162tc_$i.png");
              }
              break;
            default:
              if (widget.arguments["side"] == 2) //第二面反夹
              {
                gifPath = appData.keyImagePath + "/fixture/smart/1_0_1b.gif";
                title.add(S.of(context).fixture_smart_1_1);
                title.add(S.of(context).fixture_smart_1_2);
                title.add(S.of(context).fixture_smart_1_3);
                for (var i = 1; i < 4; i++) {
                  image.add("smart/1_0_1_${i + 3}.png");
                }
              } else {
                gifPath = appData.keyImagePath + "/fixture/smart/1_0_1a.gif";
                title.add(S.of(context).fixture_smart_1_1);
                title.add(S.of(context).fixture_smart_1_2);
                title.add(S.of(context).fixture_smart_1_3);
                for (var i = 1; i < 4; i++) {
                  image.add("smart/1_0_1_$i.png");
                }
              }
              break;
          }
        }

        break;
    }
  }

  _newnonfixture() {
    switch (baseKey.fixture) {
      case 0: //左侧夹块
      case 4:
      case 3:
        //如果是新夹具
        if (baseKey.locat == 0) {
          //非导电对肩
          gifPath = appData.keyImagePath + "/fixture/insulations/1_hu58.gif";
          title.add(S.of(context).fixture0_0_0_1);
          title.add(S.of(context).fixture0_0_0_2);

          switch (baseKey.keySerNum) {
            case 96:
              for (var i = 1; i < 3; i++) {
                image.add("insulations/1_hu58_$i.png");
              }
              break;
            default:
              for (var i = 1; i < 4; i++) {
                image.add("insulations/1_hu58_$i.png");
              }
              break;
          }
        } else {
          //非导电对头
          gifPath = appData.keyImagePath + "/fixture/insulations/1_0_1.gif";
          title.add(S.of(context).fixture0_1_0_1);
          title.add(S.of(context).fixture0_1_0_2);

          for (var i = 1; i < 3; i++) {
            image.add("insulations/1_0_1_$i.png");
          }
        }

        break;
      case 7:
        gifPath = appData.keyImagePath + "/fixture/insulations/1_hu66.gif";
        title.add(S.of(context).fixture_hu66_1_1);
        title.add(S.of(context).fixture_hu66_1_2);
        title.add(S.of(context).fixture_hu66_1_3);

        for (var i = 1; i < 4; i++) {
          image.add("insulations/1_hu66_$i.png");
        }
        break;
    }
  }

  _oldnonfixture() {
    switch (baseKey.fixture) {
      case 0: //左侧夹块
      case 4:
      case 3:
        //旧夹具图片
        if (baseKey.locat == 0) {
          //非导电对肩
          gifPath = appData.keyImagePath + "/fixture/insulations/0_hu58.gif";
          title.add(S.of(context).fixture0_0_0_1);
          title.add(S.of(context).fixture0_0_0_2);

          switch (baseKey.keySerNum) {
            case 96:
              for (var i = 1; i < 3; i++) {
                image.add("insulations/1_hu58_$i.png");
              }
              break;
            default:
              for (var i = 1; i < 3; i++) {
                image.add("insulations/1_hu58_$i.png");
              }
              break;
          }
        } else {
          //非导电对头
          gifPath = appData.keyImagePath + "/fixture/insulations/0_0_1.gif";
          title.add(S.of(context).fixture0_1_0_1);
          title.add(S.of(context).fixture0_1_0_2);

          for (var i = 1; i < 3; i++) {
            image.add("insulations/0_0_1_$i.png");
          }
        }

        break;
      case 7:
        gifPath = appData.keyImagePath + "/fixture/insulations/0_hu66.gif";
        title.add(S.of(context).fixture_hu66_0_1);
        title.add(S.of(context).fixture_hu66_0_2);

        for (var i = 1; i < 4; i++) {
          image.add("insulations/0_hu66_$i.png");
        }
        break;
    }
  }

  List<Widget> keyclampviewlist() {
    List<Widget> temp = [];
    //fixture 根据夹具类型显示图片
    //class  根据钥匙类型显示图片
    //id  根据钥匙ID显示图片
    title = [];
    image = [];
    int count = 0;
    gifPath = appData.keyImagePath + "/fixture/1_1_1.gif";
    if (cncVersion.fixtureType == 21) {
      _newfixture();
    } else {
      _oldfixture();
    }

    count = min(title.length, image.length);

    for (var i = 0; i < count; i++) {
      // temp.add(Container(
      //   height: 178.h,
      //   margin: EdgeInsets.only(left: 10.w, right: 10.w),
      //   decoration: BoxDecoration(
      //       color: const Color(0xff384c70),
      //       borderRadius: BorderRadius.circular(17.w)),
      //   child: Column(
      //     children: [
      //       SizedBox(
      //         height: 35.h,
      //         child: Center(
      //             child: Text(title[i],
      //                 style: TextStyle(color: Colors.white, fontSize: 12.sp))),
      //       ),
      //       Expanded(
      //           child: Container(
      //         width: double.maxFinite,
      //         decoration: BoxDecoration(
      //             color: Colors.white,
      //             borderRadius: BorderRadius.circular(17.w)),
      //         child: Image.file(
      //           File(appData.keyImagePath + "/fixture/" + image[i]),
      //         ),
      //       )),
      //     ],
      //   ),
      // ));
      temp.add(myContainer(
          double.maxFinite,
          178.h,
          35.h,
          title[i],
          appData.keyImagePath + "/fixture/" + image[i],
          EdgeInsets.only(left: 20.w, right: 20.w)));
      temp.add(SizedBox(
        height: 20.h,
      ));
    }
    return temp;
  }

  List<Widget> clampkeytype() {
    // if (copykey) {
    //   return copykeyclampviewlist();
    // }
    return keyclampviewlist();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> awitsetdir() async {
    if (dir) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userTankBar(context),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: clampkeytype(),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xff384c70))),
                  child: Text(
                    S.of(context).continuebt,
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  onPressed: () {
                    switch (widget.arguments["state"]) {
                      case 0:
                        if (widget.arguments["bitting"] != null) {
                          //print(widget.arguments["bitting"]);
//pushReplacementNamed
                          Navigator.pushReplacementNamed(context, '/keyshow',
                              arguments: {
                                "keydata": widget.arguments["keydata"],
                                "bitting": widget.arguments["bitting"],
                                "dir": dir,
                                "type": widget.arguments["type"]
                              });
                        } else {
                          Navigator.pushReplacementNamed(context, '/keyshow',
                              arguments: {
                                "keydata": widget.arguments["keydata"],
                                "dir": dir,
                                "type": widget.arguments["type"]
                              });
                        }
                        break;
                      case 1:
                        sendCmd([cncBtSmd.answer2, 0, 0]);
                        Navigator.pop(context);
                        break;
                      default:
                        Navigator.pop(context, true);
                        break;
                    }
                  },
                ),
              ),
              SizedBox(
                width: 40.w,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xff384c70))),
                  child: Text(
                    "GIF",
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/gifshow',
                        arguments: gifPath);
                  },
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
