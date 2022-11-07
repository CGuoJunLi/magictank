import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:magictank/cncpage/basekey.dart';

class DiyKeyPreview extends CustomPainter {
  Map keydata;
  int zoom = 10; //缩放倍数
  List<int> sAhNum = [];
  List<int> sBhNum = [];
  List<int> ahNum = [];
  List<int> bhNum = [];
  List<String> ahNums = [];
  List<String> bhNums = [];
  late double _wide;
  late double _hight;
  Offset touchoffect;
  bool gesture;
  bool showmodel;
  // int cutsindeX;
  DiyKeyPreview(
    this.keydata,
    this.sAhNum,
    this.sBhNum,
    // this.ahNum,
    // this.bhNum,
    // this.ahNums,
    // this.bhNums,
    // this.cutsindeX,
    this.touchoffect,
    this.gesture,
    this.showmodel,
  );

  Paint paintline = Paint()
    ..color = Colors.blue //画笔颜色
    ..strokeCap = StrokeCap.round //画笔笔触类型
    ..isAntiAlias = true //是否启动抗锯齿
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0; //画笔的宽度
  Paint paintline2 = Paint()
    ..color = Colors.green //画笔颜色
    ..strokeCap = StrokeCap.round //画笔笔触类型
    ..isAntiAlias = true //是否启动抗锯齿
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0; //画笔的宽度
  Paint paintcut = Paint()
    ..color = Colors.green //画笔颜色
    ..strokeCap = StrokeCap.round //画笔笔触类型
    ..isAntiAlias = true //是否启动抗锯齿
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0; //画笔的宽度

  void _showtext(Canvas canvas, String string, Offset offset, double frontsize,
      Color frontcolor) {
    var textPainter = TextPainter(
      text: TextSpan(
          text: string,
          style: TextStyle(color: frontcolor, fontSize: frontsize)),
      textDirection: TextDirection.rtl,
      textWidthBasis: TextWidthBasis.longestLine,
      maxLines: 2,
    )..layout();

    textPainter.paint(canvas, offset);
  }

//绘图平铣双边 立铣外沟双边
  void drawSB0KeY(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+    H
 I   ------|
          |                             F
          -------------------------------\
          G                               \
                                           \
                                           / E
          C                               /
          -------------------------------/
          |                              D
    ------|      
    A     B
    ---------------------------
    */
    // Color frontcolor = Colors.blue;
    int tooth = sAhNum.length;
    int keYlength = sAhNum.length * 20; //钥匙长度
    // double aX = (_wide - keYlength / zoom) / 2 - 20;
    //double aY = _hight / 2 + keydata["wide"] / 2 / zoom + 20;
    // double bX = (_wide - keYlength / zoom) / 2;
    //double bY = _hight / 2 + keydata["wide"] / 2 / zoom + 20;
    double cX = (_wide - keYlength / zoom) / 2;
    double cY = _hight / 2 + keydata["wide"] / 2 / zoom;
    double eX = cX + keYlength / zoom;
    double eY = _hight / 2;
    double gX = cX;
    double gY = _hight / 2 - keydata["wide"] / 2 / zoom;
    //double hX = gX;
    //double hY = gY - 20;
    // double iX = hX - 20;n
    // double iY = hY;
    double locatx = keydata["length"] / zoom;
    locatx = eX - locatx;
    List<Offset> post = [];
    baseKey.seleside = 1;
    //List<Offset> post2 = [];
    // Rect rect;

    // length = keydata["toothSA"][tooth - 1] / zoom; //
    // double beginx = 50;
    // double beginy = 140; //代表肩膀宽度为1000丝

    post.add(Offset(cX, cY));

    for (var i = 0; i < tooth; i++) {
      post.add(Offset(cX + i * 20 / zoom - 2, eY + sAhNum[i] / zoom));
      post.add(Offset(cX + i * 20 / zoom + 2, eY + sAhNum[i] / zoom));
    }
    //  post.add(Offset(headx - keydata["wide"] / zoom / 2, beginy));
    post.add(Offset(eX, eY));
    //post.add(Offset(headx - keydata["wide"] / zoom / 2, endy));
    // for (var i = tooth - 1; i >= 0; i--) {
    //   post.add(Offset(eX - i * 20 / zoom + 2, eY - sBhNum[i] / zoom));
    //   post.add(Offset(eX - i * 20 / zoom - 2, eY - sBhNum[i] / zoom));
    // }
    for (var i = tooth - 1; i >= 0; i--) {
      post.add(Offset(cX + i * 20 / zoom - 2, eY - sBhNum[i] / zoom));
      post.add(Offset(cX + i * 20 / zoom + 2, eY - sBhNum[i] / zoom));
    }
    post.add(Offset(gX, gY));

    canvas.drawPoints(

        ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
        PointMode.polygon, //首尾相连
        //PointMode.lines, //两两相连
        //PointMode.points,//画点
        post,
        paintline..color = Colors.blueAccent);

    if (keydata["locat"] == 1) {
      //下齿
      tooth = keydata["toothSA"].length;
      //尾部齿位
      if ((touchoffect.dx - (eX - keydata["toothSA"][0] / zoom)).abs() < 20 &&
          gesture) {
        baseKey.seleindex = 1;
        if (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom) > 0) {
          keydata["toothSA"][0] = (keydata["toothSA"][0] -
                  (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom).abs())
                          .abs() *
                      zoom)
              .toInt();
        } else {
          keydata["toothSA"][0] = (keydata["toothSA"][0] +
                  (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom).abs())
                          .abs() *
                      zoom)
              .toInt();
        }
        // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
        if (keydata["locat"] == 1) {
          if (keydata["toothSA"][0] <= keydata["toothSA"][tooth - 1]) {
            keydata["toothSA"][0] = keydata["toothSA"][tooth - 1] + 100;
          }
        }
      }
      //头部齿位
      if ((touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom)).abs() <
              20 &&
          gesture) {
        baseKey.seleindex = tooth;
        if (touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom) > 0) {
          keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] -
                  (touchoffect.dx -
                              (eX - keydata["toothSA"][tooth - 1] / zoom).abs())
                          .abs() *
                      zoom)
              .toInt();
        } else {
          keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] +
                  (touchoffect.dx -
                              (eX - keydata["toothSA"][tooth - 1] / zoom).abs())
                          .abs() *
                      zoom)
              .toInt();
        }
        //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
        if (keydata["locat"] == 1) {
          if (keydata["toothSA"][tooth - 1] >= keydata["toothSA"][0]) {
            keydata["toothSA"][tooth - 1] = keydata["toothSA"][0] - 100;
          }
        }
      }
      for (var i = 0; i < tooth; i++) {
        if (i == 0 || i == tooth - 1) {
          paintcut.color = Colors.red;
          if (((touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom))
                      .abs() <
                  20) ||
              baseKey.seleindex == tooth) {
            // //print("触发2:$i");
            if (i == tooth - 1) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
          if (((touchoffect.dx - (eX - keydata["toothSA"][0] / zoom)).abs() <
                  20) ||
              baseKey.seleindex == 1) {
            ////print("触发:$i");
            if (i == 0) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
        } else {
          paintcut.color = Colors.blue;
        }
        canvas.drawLine(Offset(eX - keydata["toothSA"][i] / zoom, cY + 5),
            Offset(eX - keydata["toothSA"][i] / zoom, gY - 5), paintcut);
      }
    } else {
      //对肩膀
      paintcut.color = const Color(0XFF6E66AA);
      canvas.drawLine(
          Offset(locatx, cY + 20), Offset(locatx, gY - 20), paintcut);

      //下齿
      tooth = keydata["toothSA"].length;
      //尾部齿位
      if ((touchoffect.dx - (locatx + keydata["toothSA"][0] / zoom)).abs() <
              20 &&
          gesture) {
        baseKey.seleindex = 1;
        if (touchoffect.dx - (locatx + keydata["toothSA"][0] / zoom) > 0) {
          keydata["toothSA"][0] = (keydata["toothSA"][0] +
                  (touchoffect.dx -
                              (locatx + keydata["toothSA"][0] / zoom).abs())
                          .abs() *
                      zoom)
              .toInt();
        } else {
          keydata["toothSA"][0] = (keydata["toothSA"][0] -
                  (touchoffect.dx -
                              (locatx + keydata["toothSA"][0] / zoom).abs())
                          .abs() *
                      zoom)
              .toInt();
        }
        // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;

        if (keydata["toothSA"][0] >= keydata["toothSA"][tooth - 1]) {
          keydata["toothSA"][0] = keydata["toothSA"][tooth - 1] - 100;
        }
      }
      //头部齿位
      if ((touchoffect.dx - (locatx + keydata["toothSA"][tooth - 1] / zoom))
                  .abs() <
              20 &&
          gesture) {
        baseKey.seleindex = tooth;
        if (touchoffect.dx - (locatx + keydata["toothSA"][tooth - 1] / zoom) <
            0) {
          keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] -
                  (touchoffect.dx -
                              (locatx + keydata["toothSA"][tooth - 1] / zoom)
                                  .abs())
                          .abs() *
                      zoom)
              .toInt();
        } else {
          keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] +
                  (touchoffect.dx -
                              (locatx + keydata["toothSA"][tooth - 1] / zoom)
                                  .abs())
                          .abs() *
                      zoom)
              .toInt();
        }
        //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
        if (keydata["locat"] == 1) {
          if (keydata["toothSA"][tooth - 1] >= keydata["toothSA"][0]) {
            keydata["toothSA"][tooth - 1] = keydata["toothSA"][0] - 100;
          }
        }
      }

      for (var i = 0; i < tooth; i++) {
        if (i == 0 || i == tooth - 1) {
          paintcut.color = Colors.red;
          if (((touchoffect.dx -
                          (locatx + keydata["toothSA"][tooth - 1] / zoom))
                      .abs() <
                  20) ||
              baseKey.seleindex == tooth) {
            // //print("触发2:$i");
            if (i == tooth - 1) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
          if (((touchoffect.dx - (locatx + keydata["toothSA"][0] / zoom))
                      .abs() <
                  20) ||
              baseKey.seleindex == 1) {
            ////print("触发:$i");
            if (i == 0) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
        } else {
          paintcut.color = Colors.blue;
        }
        canvas.drawLine(Offset(locatx + keydata["toothSA"][i] / zoom, cY + 5),
            Offset(locatx + keydata["toothSA"][i] / zoom, gY - 5), paintcut);
      }
    }
  }

//立铣外沟双边
  void drawSB4KeY(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+    H
 I   ------|
          |                             F
          -------------------------------\
          G                               \
                                           \
                                           / E
          C                               /
          -------------------------------/
          |                              D
    ------|      
    A     B
    ---------------------------
    */
    // Color frontcolor = Colors.blue;
    int tooth = sAhNum.length;
    int keYlength = sAhNum.length * 20; //钥匙长度
    double aX = (_wide - keYlength / zoom) / 2 - 20;
    double aY = _hight / 2 + keydata["wide"] / 2 / zoom + 20;
    double bX = (_wide - keYlength / zoom) / 2;
    double bY = _hight / 2 + keydata["wide"] / 2 / zoom + 20;
    double cX = (_wide - keYlength / zoom) / 2;
    double cY = _hight / 2 + keydata["wide"] / 2 / zoom;
    double eX = cX + keYlength / zoom;
    double eY = _hight / 2;
    double gX = cX;
    double gY = _hight / 2 - keydata["wide"] / 2 / zoom;
    double hX = gX;
    double hY = gY - 20;
    double iX = hX - 20;
    double iY = hY;
    double locatx = keydata["length"] / zoom;
    locatx = eX - locatx;
    List<Offset> post = [];
    //List<Offset> post2 = [];
    // Rect rect;
    if (keydata["locat"] == 0) {
      // length = keydata["toothSA"][tooth - 1] / zoom; //
      // double beginx = 50;
      // double beginy = 140; //代表肩膀宽度为1000丝
      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀
      post.add(Offset(aX, aY));
      post.add(Offset(bX, bY));
      post.add(Offset(cX, cY));

      for (var i = 0; i < tooth; i++) {
        post.add(Offset(cX + i * 20 / zoom - 2, eY + sAhNum[i] / zoom));
        post.add(Offset(cX + i * 20 / zoom + 2, eY + sAhNum[i] / zoom));
      }
      //  post.add(Offset(headx - keydata["wide"] / zoom / 2, beginy));
      post.add(Offset(eX, eY));
      //post.add(Offset(headx - keydata["wide"] / zoom / 2, endy));
      int j = 0;
      for (var i = tooth - 1; i >= 0; i--) {
        post.add(Offset(eX - j * 20 / zoom + 2, eY - sBhNum[i] / zoom));
        post.add(Offset(eX - j * 20 / zoom - 2, eY - sBhNum[i] / zoom));
        j++;
      }

      post.add(Offset(gX, gY));
      post.add(Offset(hX, hY));
      post.add(Offset(iX, iY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = Colors.blueAccent);
    } else {
      // length = keydata["toothSA"][tooth - 1] / zoom; //
      // double beginx = 50;
      // double beginy = 140; //代表肩膀宽度为1000丝

      post.add(Offset(cX, cY));

      for (var i = 0; i < tooth; i++) {
        post.add(Offset(cX + i * 20 / zoom - 2, eY + sAhNum[i] / zoom));
        post.add(Offset(cX + i * 20 / zoom + 2, eY + sAhNum[i] / zoom));
      }
      //  post.add(Offset(headx - keydata["wide"] / zoom / 2, beginy));
      post.add(Offset(eX, eY));
      //post.add(Offset(headx - keydata["wide"] / zoom / 2, endy));
      // for (var i = tooth - 1; i >= 0; i--) {
      //   post.add(Offset(eX - i * 20 / zoom + 2, eY - sBhNum[i] / zoom));
      //   post.add(Offset(eX - i * 20 / zoom - 2, eY - sBhNum[i] / zoom));
      // }
      for (var i = tooth - 1; i >= 0; i--) {
        post.add(Offset(cX + i * 20 / zoom - 2, eY - sBhNum[i] / zoom));
        post.add(Offset(cX + i * 20 / zoom + 2, eY - sBhNum[i] / zoom));
      }
      post.add(Offset(gX, gY));

      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = Colors.blueAccent);
    }
    tooth = keydata["toothSA"].length;
    if (keydata["locat"] == 1) {
      if ((touchoffect.dx - (eX - keydata["toothSA"][0] / zoom)).abs() < 20 &&
          gesture) {
        baseKey.seleindex = 1;
        if (touchoffect.dy > eY) {
          baseKey.seleside = 1;
          if (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom) > 0) {
            keydata["toothSA"][0] = (keydata["toothSA"][0] -
                    (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][0] = (keydata["toothSA"][0] +
                    (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
          if (keydata["toothSA"][0] <= keydata["toothSA"][tooth - 1]) {
            keydata["toothSA"][0] = keydata["toothSA"][tooth - 1] + 100;
          }
        } else {
          baseKey.seleside = 0;
          if (touchoffect.dx - (eX - keydata["toothSB"][0] / zoom) > 0) {
            keydata["toothSB"][0] = (keydata["toothSB"][0] -
                    (touchoffect.dx - (eX - keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][0] = (keydata["toothSB"][0] +
                    (touchoffect.dx - (eX - keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
          if (keydata["toothSB"][0] <= keydata["toothSB"][tooth - 1]) {
            keydata["toothSB"][0] = keydata["toothSB"][tooth - 1] + 100;
          }
        }
      }
      if ((touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom)).abs() <
              20 &&
          gesture) {
        baseKey.seleindex = tooth;
        if (touchoffect.dy > eY) {
          baseKey.seleside = 1;
          if (touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom) >
              0) {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] -
                    (touchoffect.dx -
                                (eX - keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] +
                    (touchoffect.dx -
                                (eX - keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
          if (keydata["toothSA"][tooth - 1] >= keydata["toothSA"][0]) {
            keydata["toothSA"][tooth - 1] = keydata["toothSA"][0] - 100;
          }
        } else {
          baseKey.seleside = 0;
          if (touchoffect.dx - (eX - keydata["toothSB"][tooth - 1] / zoom) >
              0) {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] -
                    (touchoffect.dx -
                                (eX - keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] +
                    (touchoffect.dx -
                                (eX - keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
          if (keydata["toothSB"][tooth - 1] >= keydata["toothSB"][0]) {
            keydata["toothSB"][tooth - 1] = keydata["toothSB"][0] - 100;
          }
        }
      }

      /// //print("baseKey.seleside:${baseKey.seleside}");

      for (var i = 0; i < tooth; i++) {
        if (i == 0 || i == tooth - 1) {
          paintcut.color = Colors.red;
          if (((touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom))
                      .abs() <
                  20) ||
              baseKey.seleindex == tooth) {
            // //print("触发2:$i");
            if (i == tooth - 1 && baseKey.seleside == 1) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
          if (((touchoffect.dx - (eX - keydata["toothSA"][0] / zoom)).abs() <
                  20) ||
              baseKey.seleindex == 1) {
            ////print("触发:$i");
            if (i == 0 && baseKey.seleside == 1) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
        } else {
          paintcut.color = Colors.blue;
        }
        canvas.drawLine(Offset(eX - keydata["toothSA"][i] / zoom, cY + 5),
            Offset(eX - keydata["toothSA"][i] / zoom, eY + 10), paintcut);
      }

      for (var i = 0; i < tooth; i++) {
        if (i == 0 || i == tooth - 1) {
          paintcut.color = Colors.red;
          if (((touchoffect.dx - (eX - keydata["toothSB"][tooth - 1] / zoom))
                      .abs() <
                  20) ||
              baseKey.seleindex == tooth) {
            // //print("触发2:$i");
            if (i == tooth - 1 && baseKey.seleside == 0) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
          if (((touchoffect.dx - (eX - keydata["toothSB"][0] / zoom)).abs() <
                  20) ||
              baseKey.seleindex == 1) {
            ////print("触发:$i");
            if (i == 0 && baseKey.seleside == 0) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
        } else {
          paintcut.color = Colors.blue;
        }
        canvas.drawLine(Offset(eX - keydata["toothSB"][i] / zoom, eY - 10),
            Offset(eX - keydata["toothSB"][i] / zoom, gY - 5), paintcut);
      }
    } else {
      //对肩膀
      paintcut.color = const Color(0XFF6E66AA);
      canvas.drawLine(
          Offset(locatx, cY + 20), Offset(locatx, gY - 20), paintcut);

      if ((touchoffect.dx - (locatx + keydata["toothSA"][0] / zoom)).abs() <
              20 &&
          gesture) {
        baseKey.seleindex = 1;
        if (touchoffect.dy > eY) {
          baseKey.seleside = 1;
          if (touchoffect.dx - (locatx + keydata["toothSA"][0] / zoom) > 0) {
            keydata["toothSA"][0] = (keydata["toothSA"][0] +
                    (touchoffect.dx -
                                (locatx + keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][0] = (keydata["toothSA"][0] -
                    (touchoffect.dx -
                                (locatx + keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
          if (keydata["toothSA"][0] >= keydata["toothSA"][tooth - 1]) {
            keydata["toothSA"][0] = keydata["toothSA"][tooth - 1] - 100;
          }
        } else {
          baseKey.seleside = 0;
          if (touchoffect.dx - (locatx + keydata["toothSB"][0] / zoom) > 0) {
            keydata["toothSB"][0] = (keydata["toothSB"][0] +
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][0] = (keydata["toothSB"][0] -
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
          if (keydata["toothSB"][0] >= keydata["toothSB"][tooth - 1]) {
            keydata["toothSB"][0] = keydata["toothSB"][tooth - 1] - 100;
          }
        }
      }
      if ((touchoffect.dx - (locatx + keydata["toothSA"][tooth - 1] / zoom))
                  .abs() <
              20 &&
          gesture) {
        baseKey.seleindex = tooth;
        if (touchoffect.dy > eY) {
          baseKey.seleside = 1;
          if (touchoffect.dx - (locatx + keydata["toothSA"][tooth - 1] / zoom) >
              0) {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] +
                    (touchoffect.dx -
                                (locatx + keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] -
                    (touchoffect.dx -
                                (locatx + keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
          if (keydata["toothSA"][tooth - 1] <= keydata["toothSA"][0]) {
            keydata["toothSA"][tooth - 1] = keydata["toothSA"][0] + 100;
          }
        } else {
          baseKey.seleside = 0;
          if (touchoffect.dx - (locatx + keydata["toothSB"][tooth - 1] / zoom) >
              0) {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] +
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] -
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
          if (keydata["toothSB"][tooth - 1] <= keydata["toothSB"][0]) {
            keydata["toothSB"][tooth - 1] = keydata["toothSB"][0] + 100;
          }
        }
      }
      // //print("baseKey.seleside:${baseKey.seleside}");

      for (var i = 0; i < tooth; i++) {
        if (i == 0 || i == tooth - 1) {
          paintcut.color = Colors.red;
          if (((touchoffect.dx -
                          (locatx + keydata["toothSA"][tooth - 1] / zoom))
                      .abs() <
                  20) ||
              baseKey.seleindex == tooth) {
            // //print("触发2:$i");
            if (i == tooth - 1 && baseKey.seleside == 1) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
          if (((touchoffect.dx - (locatx + keydata["toothSA"][0] / zoom))
                      .abs() <
                  20) ||
              baseKey.seleindex == 1) {
            ////print("触发:$i");
            if (i == 0 && baseKey.seleside == 1) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
        } else {
          paintcut.color = Colors.blue;
        }
        canvas.drawLine(Offset(locatx + keydata["toothSA"][i] / zoom, cY + 5),
            Offset(locatx + keydata["toothSA"][i] / zoom, eY + 10), paintcut);
      }

      for (var i = 0; i < tooth; i++) {
        if (i == 0 || i == tooth - 1) {
          paintcut.color = Colors.red;
          if (((touchoffect.dx -
                          (locatx + keydata["toothSB"][tooth - 1] / zoom))
                      .abs() <
                  20) ||
              baseKey.seleindex == tooth) {
            // //print("触发2:$i");
            if (i == tooth - 1 && baseKey.seleside == 0) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
          if (((touchoffect.dx - (locatx + keydata["toothSB"][0] / zoom))
                      .abs() <
                  20) ||
              baseKey.seleindex == 1) {
            ////print("触发:$i");
            if (i == 0 && baseKey.seleside == 0) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
        } else {
          paintcut.color = Colors.blue;
        }
        canvas.drawLine(Offset(locatx + keydata["toothSB"][i] / zoom, eY - 10),
            Offset(locatx + keydata["toothSB"][i] / zoom, gY - 5), paintcut);
      }
    }
  }

//绘图平铣单边 立铣外沟单边
  void drawSB3KeY(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+    H
 I   ------|
          |                             F
          -------------------------------\
          G                               \
                                           \
                                           / E
          C                               /
          -------------------------------/
          |                              D
    ------|      
    A     B
    ---------------------------
    */
    // Color frontcolor = Colors.blue;
    int tooth;
    int keYlength; //钥匙长度
    //double aX;
    // double aY;
    //double bX;
    //double bY;
    double cX;
    double cY;
    double eX;
    // double eY;
    double gX;
    double gY;
    //double hX;
    // double hY;
    // double iX;
    // double iY;
    double locatx;
    // //print("keydata[wide]:${keydata["wide"]}");

    if (keydata["side"] == 0) {
      tooth = sAhNum.length;
      keYlength = sAhNum.length * 20; //钥匙长度
      //  aX = (_wide - keYlength / zoom) / 2 - 20;
      //  aY = _hight / 2 + keydata["wide"] / 2 / zoom + 20;
      // bX = (_wide - keYlength / zoom) / 2;
      // bY = _hight / 2 + keydata["wide"] / 2 / zoom + 20;
      cX = (_wide - keYlength / zoom) / 2;
      cY = _hight / 2 + keydata["wide"] / 2 / zoom;
      eX = cX + keYlength / zoom;
      //  eY = _hight / 2;
      gX = cX;
      gY = _hight / 2 - keydata["wide"] / 2 / zoom;
      // hX = gX;
      //  hY = gY - 20;
      //  iX = hX - 20;
      //  iY = hY;
      locatx = keydata["length"] / zoom;
      locatx = eX - locatx;
    } else {
      tooth = sBhNum.length;
      keYlength = sBhNum.length * 20; //钥匙长度
      // aX = (_wide - keYlength / zoom) / 2 - 20;
      // aY = _hight / 2 + keydata["wide"] / 2 / zoom + 20;
      //bX = (_wide - keYlength / zoom) / 2;
      // bY = _hight / 2 + keydata["wide"] / 2 / zoom + 20;
      cX = (_wide - keYlength / zoom) / 2;
      cY = _hight / 2 + keydata["wide"] / 2 / zoom;
      eX = cX + keYlength / zoom;
      // eY = _hight / 2;
      gX = cX;
      gY = _hight / 2 - keydata["wide"] / 2 / zoom;
      // hX = gX;
      //hY = gY - 20;
      //  iX = hX - 20;
      // iY = hY;
      locatx = keydata["length"] / zoom;
      locatx = eX - locatx;
    }
    List<Offset> post = [];
    //List<Offset> post2 = [];
    // Rect rect;
    ////print("tooth$tooth");
    // //print("keYlength$keYlength");

    // length = keydata["toothSA"][tooth - 1] / zoom; //
    // double beginx = 50;
    // double beginy = 140; //代表肩膀宽度为1000丝
    if (keydata["side"] == 0) {
      // post.add(Offset(cX, cY));
      baseKey.seleside = 0;
      for (var i = 0; i < tooth; i++) {
        post.add(Offset(cX + i * 20 / zoom - 2, gY + sAhNum[i] / zoom));
        post.add(Offset(cX + i * 20 / zoom + 2, gY + sAhNum[i] / zoom));
      }
      post.add(Offset(gX, gY));
    } else {
      baseKey.seleside = 1;
      for (var i = 0; i < tooth; i++) {
        post.add(Offset(cX + i * 20 / zoom - 2, cY - sBhNum[i] / zoom));
        post.add(Offset(cX + i * 20 / zoom + 2, cY - sBhNum[i] / zoom));
      }
      post.add(Offset(cX, cY));
    }
    canvas.drawPoints(

        ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
        PointMode.polygon, //首尾相连
        //PointMode.lines, //两两相连
        //PointMode.points,//画点
        post,
        paintline..color = Colors.blueAccent);
    if (keydata["locat"] == 1) {
      if (keydata["side"] == 1) {
        //下齿
        baseKey.seleside = 1;
        tooth = keydata["toothSA"].length;
        //尾部齿位
        if ((touchoffect.dx - (eX - keydata["toothSA"][0] / zoom)).abs() < 20 &&
            gesture) {
          baseKey.seleindex = 1;
          if (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom) > 0) {
            keydata["toothSA"][0] = (keydata["toothSA"][0] -
                    (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][0] = (keydata["toothSA"][0] +
                    (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
          if (keydata["locat"] == 1) {
            if (keydata["toothSA"][0] <= keydata["toothSA"][tooth - 1]) {
              keydata["toothSA"][0] = keydata["toothSA"][tooth - 1] + 100;
            }
          }
        }
        //头部齿位
        if ((touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom))
                    .abs() <
                20 &&
            gesture) {
          baseKey.seleindex = tooth;
          if (touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom) >
              0) {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] -
                    (touchoffect.dx -
                                (eX - keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] +
                    (touchoffect.dx -
                                (eX - keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
          if (keydata["locat"] == 1) {
            if (keydata["toothSA"][tooth - 1] >= keydata["toothSA"][0]) {
              keydata["toothSA"][tooth - 1] = keydata["toothSA"][0] - 100;
            }
          }
        }
//画线
        for (var i = 0; i < tooth; i++) {
          if (i == 0 || i == tooth - 1) {
            paintcut.color = Colors.red;
            if (((touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == tooth) {
              // //print("触发2:$i");
              if (i == tooth - 1) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
            if (((touchoffect.dx - (eX - keydata["toothSA"][0] / zoom)).abs() <
                    20) ||
                baseKey.seleindex == 1) {
              ////print("触发:$i");
              if (i == 0) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
          } else {
            paintcut.color = Colors.blue;
          }
          canvas.drawLine(Offset(eX - keydata["toothSA"][i] / zoom, cY + 5),
              Offset(eX - keydata["toothSA"][i] / zoom, gY - 5), paintcut);
        }
      } else {
        //上齿
        baseKey.seleside = 0;
        tooth = keydata["toothSB"].length;
        //尾部齿位
        if ((touchoffect.dx - (eX - keydata["toothSB"][0] / zoom)).abs() < 20 &&
            gesture) {
          baseKey.seleindex = 1;
          if (touchoffect.dx - (eX - keydata["toothSB"][0] / zoom) > 0) {
            keydata["toothSB"][0] = (keydata["toothSB"][0] -
                    (touchoffect.dx - (eX - keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][0] = (keydata["toothSB"][0] +
                    (touchoffect.dx - (eX - keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;

          if (keydata["toothSB"][0] <= keydata["toothSB"][tooth - 1]) {
            keydata["toothSB"][0] = keydata["toothSB"][tooth - 1] + 100;
          }
        }
        //头部齿位
        if ((touchoffect.dx - (eX - keydata["toothSB"][tooth - 1] / zoom))
                    .abs() <
                20 &&
            gesture) {
          baseKey.seleindex = tooth;
          if (touchoffect.dx - (eX - keydata["toothSB"][tooth - 1] / zoom) >
              0) {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] -
                    (touchoffect.dx -
                                (eX - keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] +
                    (touchoffect.dx -
                                (eX - keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;

          if (keydata["toothSB"][tooth - 1] >= keydata["toothSB"][0]) {
            keydata["toothSB"][tooth - 1] = keydata["toothSB"][0] - 100;
          }
        }
        //画线
        for (var i = 0; i < tooth; i++) {
          if (i == 0 || i == tooth - 1) {
            paintcut.color = Colors.red;
            if (((touchoffect.dx - (eX - keydata["toothSB"][tooth - 1] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == tooth) {
              // //print("触发2:$i");
              if (i == tooth - 1) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
            if (((touchoffect.dx - (eX - keydata["toothSB"][0] / zoom)).abs() <
                    20) ||
                baseKey.seleindex == 1) {
              ////print("触发:$i");
              if (i == 0) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
          } else {
            paintcut.color = Colors.blue;
          }
          canvas.drawLine(Offset(eX - keydata["toothSB"][i] / zoom, cY + 5),
              Offset(eX - keydata["toothSB"][i] / zoom, gY - 5), paintcut);
        }
      }
    } else {
      //对肩膀
      paintcut.color = const Color(0XFF6E66AA);
      canvas.drawLine(
          Offset(locatx, cY + 20), Offset(locatx, gY - 20), paintcut);

      if (keydata["side"] == 1) {
        //下齿
        tooth = keydata["toothSA"].length;
        //尾部齿位
        if ((touchoffect.dx - (eX - keydata["toothSA"][0] / zoom)).abs() < 20 &&
            gesture) {
          baseKey.seleindex = 1;
          if (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom) > 0) {
            keydata["toothSA"][0] = (keydata["toothSA"][0] -
                    (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][0] = (keydata["toothSA"][0] +
                    (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
          if (keydata["locat"] == 1) {
            if (keydata["toothSA"][0] <= keydata["toothSA"][tooth - 1]) {
              keydata["toothSA"][0] = keydata["toothSA"][tooth - 1] + 100;
            }
          }
        }
        //头部齿位
        if ((touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom))
                    .abs() <
                20 &&
            gesture) {
          baseKey.seleindex = tooth;
          if (touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom) >
              0) {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] -
                    (touchoffect.dx -
                                (eX - keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] +
                    (touchoffect.dx -
                                (eX - keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
          if (keydata["locat"] == 1) {
            if (keydata["toothSA"][tooth - 1] >= keydata["toothSA"][0]) {
              keydata["toothSA"][tooth - 1] = keydata["toothSA"][0] - 100;
            }
          }
        }
//画线
        for (var i = 0; i < tooth; i++) {
          if (i == 0 || i == tooth - 1) {
            paintcut.color = Colors.red;
            if (((touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == tooth) {
              // //print("触发2:$i");
              if (i == tooth - 1) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
            if (((touchoffect.dx - (eX - keydata["toothSA"][0] / zoom)).abs() <
                    20) ||
                baseKey.seleindex == 1) {
              ////print("触发:$i");
              if (i == 0) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
          } else {
            paintcut.color = Colors.blue;
          }
          canvas.drawLine(Offset(eX - keydata["toothSA"][i] / zoom, cY + 5),
              Offset(eX - keydata["toothSA"][i] / zoom, gY - 5), paintcut);
        }
      } else {
        //上齿
        tooth = keydata["toothSB"].length;
        //尾部齿位
        if ((touchoffect.dx - (locatx + keydata["toothSB"][0] / zoom)).abs() <
                20 &&
            gesture) {
          // //print("肩部");
          baseKey.seleindex = 1;
          if (touchoffect.dx - (locatx + keydata["toothSB"][0] / zoom) > 0) {
            keydata["toothSB"][0] = (keydata["toothSB"][0] +
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][0] = (keydata["toothSB"][0] -
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;

          if (keydata["toothSB"][0] >= keydata["toothSB"][tooth - 1]) {
            keydata["toothSB"][0] = keydata["toothSB"][tooth - 1] - 100;
          }
        }
        //头部齿位
        if ((touchoffect.dx - (locatx + keydata["toothSB"][tooth - 1] / zoom))
                    .abs() <
                20 &&
            gesture) {
          //print("头部");
          baseKey.seleindex = tooth;
          if (touchoffect.dx - (locatx + keydata["toothSB"][tooth - 1] / zoom) >
              0) {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] +
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] -
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;

          if (keydata["toothSB"][tooth - 1] <= keydata["toothSB"][0]) {
            keydata["toothSB"][tooth - 1] = keydata["toothSB"][0] + 100;
          }
        }
        //画线
        for (var i = 0; i < tooth; i++) {
          if (i == 0 || i == tooth - 1) {
            paintcut.color = Colors.red;
            if (((touchoffect.dx -
                            (locatx + keydata["toothSB"][tooth - 1] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == tooth) {
              // //print("触发2:$i");
              if (i == tooth - 1) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
            if (((touchoffect.dx - (locatx + keydata["toothSB"][0] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == 1) {
              ////print("触发:$i");
              if (i == 0) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
          } else {
            paintcut.color = Colors.blue;
          }
          canvas.drawLine(Offset(locatx + keydata["toothSB"][i] / zoom, cY + 5),
              Offset(locatx + keydata["toothSB"][i] / zoom, gY - 5), paintcut);
        }
      }
    }
  }

//绘图立铣内沟 实际值
  void drawSB5KeY(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+    H
 I   ------|
          |                             F
          -------------------------------\
          G                               \
                                           \
                                           / E
          C                               /
          -------------------------------/
          |                              D
    ------|      
    A     B
    ---------------------------
    */
    // Color frontcolor = Colors.blue;
    int tooth = sAhNum.length;
    int keYlength = sAhNum.length * 20; //钥匙长度 探测点的长度
    double locatx = keydata["length"] / zoom;
    // double aX = (_wide - keYlength / zoom) / 2 - 20;
    // double aY = _hight / 2 + keydata["wide"] / 2 / zoom + 20;
    // double bX = (_wide - keYlength / zoom) / 2;
    //double bY = _hight / 2 + keydata["wide"] / 2 / zoom + 20;
    double cX = (_wide - keYlength / zoom) / 2;
    double cY = _hight / 2 + keydata["wide"] / 2 / zoom;
    double eX = cX + keYlength / zoom;
    // double eY = _hight / 2;
    double gX = cX;
    double gY = cY - keydata["wide"] / zoom;
    //double hX = gX;
    // double hY = gY - 20;
    // double iX = hX - 20;
    // double iY = hY;
    //print(locatx);
    //print(eX);
    locatx = eX - locatx;
    //print(locatx);
    List<Offset> post = []; //实际齿深A
    List<Offset> post2 = []; //实际齿深B
    //List<Offset> post3 = []; //标准齿深A
    // List<Offset> post4 = []; //标准齿深B
    Rect rect;

    // length = keydata["toothSA"][tooth - 1] / zoom; //
    // double beginx = 50;
    // double beginy = 140; //代表肩膀宽度为1000丝

    for (var i = 0; i < tooth; i++) {
      post.add(Offset(cX + i * 20 / zoom - 2, cY - sAhNum[i] / zoom));
      post.add(Offset(cX + i * 20 / zoom + 2, cY - sAhNum[i] / zoom));
    }
    post.add(Offset(cX, cY));
    canvas.drawPoints(

        ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
        PointMode.polygon, //首尾相连
        //PointMode.lines, //两两相连
        //PointMode.points,//画点
        post,
        paintline..color = Colors.grey);

    for (var i = 0; i < tooth; i++) {
      post2.add(Offset(cX + i * 20 / zoom - 2, gY + sBhNum[i] / zoom));
      post2.add(Offset(cX + i * 20 / zoom + 2, gY + sBhNum[i] / zoom));
    }
    post2.add(Offset(gX, gY));
    canvas.drawPoints(

        ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
        PointMode.polygon, //首尾相连
        //PointMode.lines, //两两相连
        //PointMode.points,//画点
        post2,
        paintline..color = Colors.grey);
    if (keydata["class"] == 5) {
      rect = Rect.fromCircle(
          center: Offset(post2[0].dx, (post[0].dy + post2[0].dy) / 2),
          radius: 300 / zoom / 2);
      canvas.drawArc(rect, 2 * pi / 4, 2 * pi / 2, false, paintline);
    }
    if (keydata["locat"] == 1) {
      if (keydata["side"] == 1) {
        //下齿
        baseKey.seleside = 1;
        tooth = keydata["toothSA"].length;
        //尾部齿位
        if ((touchoffect.dx - (eX - keydata["toothSA"][0] / zoom)).abs() < 20 &&
            gesture) {
          baseKey.seleindex = 1;
          if (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom) > 0) {
            keydata["toothSA"][0] = (keydata["toothSA"][0] -
                    (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][0] = (keydata["toothSA"][0] +
                    (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
          if (keydata["locat"] == 1) {
            if (keydata["toothSA"][0] <= keydata["toothSA"][tooth - 1]) {
              keydata["toothSA"][0] = keydata["toothSA"][tooth - 1] + 100;
            }
          }
        }
        //头部齿位
        if ((touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom))
                    .abs() <
                20 &&
            gesture) {
          baseKey.seleindex = tooth;
          if (touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom) >
              0) {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] -
                    (touchoffect.dx -
                                (eX - keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] +
                    (touchoffect.dx -
                                (eX - keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
          if (keydata["locat"] == 1) {
            if (keydata["toothSA"][tooth - 1] >= keydata["toothSA"][0]) {
              keydata["toothSA"][tooth - 1] = keydata["toothSA"][0] - 100;
            }
          }
        }
//画线
        for (var i = 0; i < tooth; i++) {
          if (i == 0 || i == tooth - 1) {
            paintcut.color = Colors.red;
            if (((touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == tooth) {
              // //print("触发2:$i");
              if (i == tooth - 1) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
            if (((touchoffect.dx - (eX - keydata["toothSA"][0] / zoom)).abs() <
                    20) ||
                baseKey.seleindex == 1) {
              ////print("触发:$i");
              if (i == 0) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
          } else {
            paintcut.color = Colors.blue;
          }
          canvas.drawLine(Offset(eX - keydata["toothSA"][i] / zoom, cY + 5),
              Offset(eX - keydata["toothSA"][i] / zoom, gY - 5), paintcut);
        }
      } else {
        //上齿
        baseKey.seleside = 0;
        tooth = keydata["toothSB"].length;
        //尾部齿位
        if ((touchoffect.dx - (eX - keydata["toothSB"][0] / zoom)).abs() < 20 &&
            gesture) {
          baseKey.seleindex = 1;
          if (touchoffect.dx - (eX - keydata["toothSB"][0] / zoom) > 0) {
            keydata["toothSB"][0] = (keydata["toothSB"][0] -
                    (touchoffect.dx - (eX - keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][0] = (keydata["toothSB"][0] +
                    (touchoffect.dx - (eX - keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;

          if (keydata["toothSB"][0] <= keydata["toothSB"][tooth - 1]) {
            keydata["toothSB"][0] = keydata["toothSB"][tooth - 1] + 100;
          }
        }
        //头部齿位
        if ((touchoffect.dx - (eX - keydata["toothSB"][tooth - 1] / zoom))
                    .abs() <
                20 &&
            gesture) {
          baseKey.seleindex = tooth;
          if (touchoffect.dx - (eX - keydata["toothSB"][tooth - 1] / zoom) >
              0) {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] -
                    (touchoffect.dx -
                                (eX - keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] +
                    (touchoffect.dx -
                                (eX - keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;

          if (keydata["toothSB"][tooth - 1] >= keydata["toothSB"][0]) {
            keydata["toothSB"][tooth - 1] = keydata["toothSB"][0] - 100;
          }
        }
        //画线
        for (var i = 0; i < tooth; i++) {
          if (i == 0 || i == tooth - 1) {
            paintcut.color = Colors.red;
            if (((touchoffect.dx - (eX - keydata["toothSB"][tooth - 1] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == tooth) {
              // //print("触发2:$i");
              if (i == tooth - 1) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
            if (((touchoffect.dx - (eX - keydata["toothSB"][0] / zoom)).abs() <
                    20) ||
                baseKey.seleindex == 1) {
              ////print("触发:$i");
              if (i == 0) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
          } else {
            paintcut.color = Colors.blue;
          }
          canvas.drawLine(Offset(eX - keydata["toothSB"][i] / zoom, cY + 5),
              Offset(eX - keydata["toothSB"][i] / zoom, gY - 5), paintcut);
        }
      }
    } else {
      //对肩膀
      paintcut.color = const Color(0XFF6E66AA);
      canvas.drawLine(
          Offset(locatx, cY + 20), Offset(locatx, gY - 20), paintcut);

      if (keydata["side"] == 1) {
        //下齿
        baseKey.seleside = 1;
        tooth = keydata["toothSA"].length;
        //尾部齿位
        if ((touchoffect.dx - (eX - keydata["toothSA"][0] / zoom)).abs() < 20 &&
            gesture) {
          baseKey.seleindex = 1;
          if (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom) > 0) {
            keydata["toothSA"][0] = (keydata["toothSA"][0] -
                    (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][0] = (keydata["toothSA"][0] +
                    (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
          if (keydata["locat"] == 1) {
            if (keydata["toothSA"][0] <= keydata["toothSA"][tooth - 1]) {
              keydata["toothSA"][0] = keydata["toothSA"][tooth - 1] + 100;
            }
          }
        }
        //头部齿位
        if ((touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom))
                    .abs() <
                20 &&
            gesture) {
          baseKey.seleindex = tooth;
          if (touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom) >
              0) {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] -
                    (touchoffect.dx -
                                (eX - keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] +
                    (touchoffect.dx -
                                (eX - keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
          if (keydata["locat"] == 1) {
            if (keydata["toothSA"][tooth - 1] >= keydata["toothSA"][0]) {
              keydata["toothSA"][tooth - 1] = keydata["toothSA"][0] - 100;
            }
          }
        }
//画线
        for (var i = 0; i < tooth; i++) {
          if (i == 0 || i == tooth - 1) {
            paintcut.color = Colors.red;
            if (((touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == tooth) {
              // //print("触发2:$i");
              if (i == tooth - 1) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
            if (((touchoffect.dx - (eX - keydata["toothSA"][0] / zoom)).abs() <
                    20) ||
                baseKey.seleindex == 1) {
              ////print("触发:$i");
              if (i == 0) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
          } else {
            paintcut.color = Colors.blue;
          }
          canvas.drawLine(Offset(eX - keydata["toothSA"][i] / zoom, cY + 5),
              Offset(eX - keydata["toothSA"][i] / zoom, gY - 5), paintcut);
        }
      } else {
        //上齿
        baseKey.seleside = 0;
        tooth = keydata["toothSB"].length;
        //尾部齿位
        if ((touchoffect.dx - (locatx + keydata["toothSB"][0] / zoom)).abs() <
                20 &&
            gesture) {
          //print("肩部");
          baseKey.seleindex = 1;
          if (touchoffect.dx - (locatx + keydata["toothSB"][0] / zoom) > 0) {
            keydata["toothSB"][0] = (keydata["toothSB"][0] +
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][0] = (keydata["toothSB"][0] -
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;

          if (keydata["toothSB"][0] >= keydata["toothSB"][tooth - 1]) {
            keydata["toothSB"][0] = keydata["toothSB"][tooth - 1] - 100;
          }
        }
        //头部齿位
        if ((touchoffect.dx - (locatx + keydata["toothSB"][tooth - 1] / zoom))
                    .abs() <
                20 &&
            gesture) {
          //print("头部");
          baseKey.seleindex = tooth;
          if (touchoffect.dx - (locatx + keydata["toothSB"][tooth - 1] / zoom) >
              0) {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] +
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] -
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;

          if (keydata["toothSB"][tooth - 1] <= keydata["toothSB"][0]) {
            keydata["toothSB"][tooth - 1] = keydata["toothSB"][0] + 100;
          }
        }
        //画线
        for (var i = 0; i < tooth; i++) {
          if (i == 0 || i == tooth - 1) {
            paintcut.color = Colors.red;
            if (((touchoffect.dx -
                            (locatx + keydata["toothSB"][tooth - 1] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == tooth) {
              // //print("触发2:$i");
              if (i == tooth - 1) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
            if (((touchoffect.dx - (locatx + keydata["toothSB"][0] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == 1) {
              ////print("触发:$i");
              if (i == 0) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
          } else {
            paintcut.color = Colors.blue;
          }
          canvas.drawLine(Offset(locatx + keydata["toothSB"][i] / zoom, cY + 5),
              Offset(locatx + keydata["toothSB"][i] / zoom, gY - 5), paintcut);
        }
      }
    }
//开始画标准齿深
  }

//绘图立铣内沟 双边实际值
  void drawSB2KeY(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+    H
 I   ------|
          |                             F
          -------------------------------\
          G                               \
                                           \
                                           / E
          C                               /
          -------------------------------/
          |                              D
    ------|      
    A     B
    ---------------------------
    */
    // Color frontcolor = Colors.blue;
    int tooth = sAhNum.length;
    int keYlength = sAhNum.length * 20; //钥匙长度
    // double aX = (_wide - keYlength / zoom) / 2 - 20;
    //double aY = _hight / 2 + keydata["wide"] / 2 / zoom + 20;
    //double bX = (_wide - keYlength / zoom) / 2;
    // double bY = _hight / 2 + keydata["wide"] / 2 / zoom + 20;
    double cX = (_wide - keYlength / zoom) / 2;
    double cY = _hight / 2 + keydata["wide"] / 2 / zoom;
    double eX = cX + keYlength / zoom;
    double eY = _hight / 2;
    double gX = cX;
    double gY = cY - keydata["wide"] / zoom;
    //double hX = gX;
    //double hY = gY - 20;
    //double iX = hX - 20;
    //double iY = hY;
    double locatx = keydata["length"] / zoom;
    locatx = eX - locatx;
    List<Offset> post = []; //实际齿深A
    List<Offset> post2 = []; //实际齿深B
    //List<Offset> post3 = []; //标准齿深A
    // List<Offset> post4 = []; //标准齿深B
    //Rect rect;

    // length = keydata["toothSA"][tooth - 1] / zoom; //
    // double beginx = 50;
    // double beginy = 140; //代表肩膀宽度为1000丝

    for (var i = 0; i < tooth; i++) {
      post.add(Offset(cX + i * 20 / zoom - 2, cY - sAhNum[i] / zoom));
      post.add(Offset(cX + i * 20 / zoom + 2, cY - sAhNum[i] / zoom));
    }
    post.add(Offset(cX, cY));
    canvas.drawPoints(

        ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
        PointMode.polygon, //首尾相连
        //PointMode.lines, //两两相连
        //PointMode.points,//画点
        post,
        paintline..color = Colors.grey);

    for (var i = 0; i < tooth; i++) {
      post2.add(Offset(cX + i * 20 / zoom - 2, gY + sBhNum[i] / zoom));
      post2.add(Offset(cX + i * 20 / zoom + 2, gY + sBhNum[i] / zoom));
    }
    post2.add(Offset(gX, gY));
    canvas.drawPoints(

        ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
        PointMode.polygon, //首尾相连
        //PointMode.lines, //两两相连
        //PointMode.points,//画点
        post2,
        paintline..color = Colors.grey);

    tooth = keydata["toothSA"].length;
    /*  if (keydata["locat"] == 1) {
      if ((touchoffect.dx - (eX - keydata["toothSA"][0] / zoom)).abs() < 20 &&
          gesture) {
        baseKey.seleindex = 1;
        if (touchoffect.dy > eY) {
          baseKey.seleside = 1;
          if (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom) > 0) {
            keydata["toothSA"][0] = (keydata["toothSA"][0] -
                    (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][0] = (keydata["toothSA"][0] +
                    (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
          if (keydata["toothSA"][0] <= keydata["toothSA"][tooth - 1]) {
            keydata["toothSA"][0] = keydata["toothSA"][tooth - 1] + 100;
          }
        } else {
          baseKey.seleside = 0;
          if (touchoffect.dx - (eX - keydata["toothSB"][0] / zoom) > 0) {
            keydata["toothSB"][0] = (keydata["toothSB"][0] -
                    (touchoffect.dx - (eX - keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][0] = (keydata["toothSB"][0] +
                    (touchoffect.dx - (eX - keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
          if (keydata["toothSB"][0] <= keydata["toothSB"][tooth - 1]) {
            keydata["toothSB"][0] = keydata["toothSB"][tooth - 1] + 100;
          }
        }
      }
      if ((touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom)).abs() <
              20 &&
          gesture) {
        baseKey.seleindex = tooth;
        if (touchoffect.dy > eY) {
          baseKey.seleside = 1;
          if (touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom) >
              0) {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] -
                    (touchoffect.dx -
                                (eX - keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] +
                    (touchoffect.dx -
                                (eX - keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
          if (keydata["toothSA"][tooth - 1] >= keydata["toothSA"][0]) {
            keydata["toothSA"][tooth - 1] = keydata["toothSA"][0] - 100;
          }
        } else {
          baseKey.seleside = 0;
          if (touchoffect.dx - (eX - keydata["toothSB"][tooth - 1] / zoom) >
              0) {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] -
                    (touchoffect.dx -
                                (eX - keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] +
                    (touchoffect.dx -
                                (eX - keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
          if (keydata["toothSB"][tooth - 1] >= keydata["toothSB"][0]) {
            keydata["toothSB"][tooth - 1] = keydata["toothSB"][0] - 100;
          }
        }
      }
      //print("baseKey.seleside:${baseKey.seleside}");

      for (var i = 0; i < tooth; i++) {
        if (i == 0 || i == tooth - 1) {
          paintcut.color = Colors.red;
          if (((touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom))
                      .abs() <
                  20) ||
              baseKey.seleindex == tooth) {
            // //print("触发2:$i");
            if (i == tooth - 1 && baseKey.seleside == 1) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
          if (((touchoffect.dx - (eX - keydata["toothSA"][0] / zoom)).abs() <
                  20) ||
              baseKey.seleindex == 1) {
            ////print("触发:$i");
            if (i == 0 && baseKey.seleside == 1) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
        } else {
          paintcut.color = Colors.blue;
        }
        canvas.drawLine(Offset(eX - keydata["toothSA"][i] / zoom, cY + 5),
            Offset(eX - keydata["toothSA"][i] / zoom, eY + 10), paintcut);
      }

      for (var i = 0; i < tooth; i++) {
        if (i == 0 || i == tooth - 1) {
          paintcut.color = Colors.red;
          if (((touchoffect.dx - (eX - keydata["toothSB"][tooth - 1] / zoom))
                      .abs() <
                  20) ||
              baseKey.seleindex == tooth) {
            // //print("触发2:$i");
            if (i == tooth - 1 && baseKey.seleside == 0) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
          if (((touchoffect.dx - (eX - keydata["toothSB"][0] / zoom)).abs() <
                  20) ||
              baseKey.seleindex == 1) {
            ////print("触发:$i");
            if (i == 0 && baseKey.seleside == 0) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
        } else {
          paintcut.color = Colors.blue;
        }
        canvas.drawLine(Offset(eX - keydata["toothSB"][i] / zoom, eY - 10),
            Offset(eX - keydata["toothSB"][i] / zoom, gY - 5), paintcut);
      }
    } else {
      //对肩膀
      paintcut.color = const Color(0XFF6E66AA);
      canvas.drawLine(
          Offset(locatx, cY + 20), Offset(locatx, gY - 20), paintcut);

      if ((touchoffect.dx - (locatx + keydata["toothSA"][0] / zoom)).abs() <
              20 &&
          gesture) {
        baseKey.seleindex = 1;
        if (touchoffect.dy > eY) {
          baseKey.seleside = 1;
          if (touchoffect.dx - (locatx + keydata["toothSA"][0] / zoom) > 0) {
            keydata["toothSA"][0] = (keydata["toothSA"][0] +
                    (touchoffect.dx -
                                (locatx + keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][0] = (keydata["toothSA"][0] -
                    (touchoffect.dx -
                                (locatx + keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
          if (keydata["toothSA"][0] >= keydata["toothSA"][tooth - 1]) {
            keydata["toothSA"][0] = keydata["toothSA"][tooth - 1] - 100;
          }
        } else {
          baseKey.seleside = 0;
          if (touchoffect.dx - (locatx + keydata["toothSB"][0] / zoom) > 0) {
            keydata["toothSB"][0] = (keydata["toothSB"][0] +
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][0] = (keydata["toothSB"][0] -
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
          if (keydata["toothSB"][0] >= keydata["toothSB"][tooth - 1]) {
            keydata["toothSB"][0] = keydata["toothSB"][tooth - 1] - 100;
          }
        }
      }
      if ((touchoffect.dx - (locatx + keydata["toothSA"][tooth - 1] / zoom))
                  .abs() <
              20 &&
          gesture) {
        baseKey.seleindex = tooth;
        if (touchoffect.dy > eY) {
          baseKey.seleside = 1;
          if (touchoffect.dx - (locatx + keydata["toothSA"][tooth - 1] / zoom) >
              0) {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] +
                    (touchoffect.dx -
                                (locatx + keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] -
                    (touchoffect.dx -
                                (locatx + keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
          if (keydata["toothSA"][tooth - 1] <= keydata["toothSA"][0]) {
            keydata["toothSA"][tooth - 1] = keydata["toothSA"][0] + 100;
          }
        } else {
          baseKey.seleside = 0;
          if (touchoffect.dx - (locatx + keydata["toothSB"][tooth - 1] / zoom) >
              0) {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] +
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] -
                    (touchoffect.dx -
                                (locatx + keydata["toothSB"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
          if (keydata["toothSB"][tooth - 1] <= keydata["toothSB"][0]) {
            keydata["toothSB"][tooth - 1] = keydata["toothSB"][0] + 100;
          }
        }
      }
      //print("baseKey.seleside:${baseKey.seleside}");

      for (var i = 0; i < tooth; i++) {
        if (i == 0 || i == tooth - 1) {
          paintcut.color = Colors.red;
          if (((touchoffect.dx -
                          (locatx + keydata["toothSA"][tooth - 1] / zoom))
                      .abs() <
                  20) ||
              baseKey.seleindex == tooth) {
            // //print("触发2:$i");
            if (i == tooth - 1 && baseKey.seleside == 1) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
          if (((touchoffect.dx - (locatx + keydata["toothSA"][0] / zoom))
                      .abs() <
                  20) ||
              baseKey.seleindex == 1) {
            ////print("触发:$i");
            if (i == 0 && baseKey.seleside == 1) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
        } else {
          paintcut.color = Colors.blue;
        }
        canvas.drawLine(Offset(locatx + keydata["toothSA"][i] / zoom, cY + 5),
            Offset(locatx + keydata["toothSA"][i] / zoom, eY + 10), paintcut);
      }

      for (var i = 0; i < tooth; i++) {
        if (i == 0 || i == tooth - 1) {
          paintcut.color = Colors.red;
          if (((touchoffect.dx -
                          (locatx + keydata["toothSB"][tooth - 1] / zoom))
                      .abs() <
                  20) ||
              baseKey.seleindex == tooth) {
            // //print("触发2:$i");
            if (i == tooth - 1 && baseKey.seleside == 0) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
          if (((touchoffect.dx - (locatx + keydata["toothSB"][0] / zoom))
                      .abs() <
                  20) ||
              baseKey.seleindex == 1) {
            ////print("触发:$i");
            if (i == 0 && baseKey.seleside == 0) {
              paintcut.color = Colors.green;
            } else {
              paintcut.color = Colors.red;
            }
          }
        } else {
          paintcut.color = Colors.blue;
        }
        canvas.drawLine(Offset(locatx + keydata["toothSB"][i] / zoom, eY - 10),
            Offset(locatx + keydata["toothSB"][i] / zoom, gY - 5), paintcut);
      }
    }
    */

//开始画标准齿深
    if (showmodel) {
      if (keydata["locat"] == 1) {
        if ((touchoffect.dx - (eX - keydata["toothSB"][0] / zoom)).abs() < 20 &&
            gesture) {
          baseKey.seleindex = 1;
          if (touchoffect.dy > eY) {
            baseKey.seleside = 1;
            if (touchoffect.dx - (eX - keydata["toothSB"][0] / zoom) > 0) {
              keydata["toothSB"][0] = (keydata["toothSB"][0] -
                      (touchoffect.dx -
                                  (eX - keydata["toothSB"][0] / zoom).abs())
                              .abs() *
                          zoom)
                  .toInt();
            } else {
              keydata["toothSB"][0] = (keydata["toothSB"][0] +
                      (touchoffect.dx -
                                  (eX - keydata["toothSB"][0] / zoom).abs())
                              .abs() *
                          zoom)
                  .toInt();
            }
            // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
            if (keydata["toothSB"][0] <= keydata["toothSB"][tooth - 1]) {
              keydata["toothSB"][0] = keydata["toothSB"][tooth - 1] + 100;
            }
          } else {
            baseKey.seleside = 0;
            if (touchoffect.dx - (eX - keydata["toothSA"][0] / zoom) > 0) {
              keydata["toothSA"][0] = (keydata["toothSA"][0] -
                      (touchoffect.dx -
                                  (eX - keydata["toothSA"][0] / zoom).abs())
                              .abs() *
                          zoom)
                  .toInt();
            } else {
              keydata["toothSA"][0] = (keydata["toothSA"][0] +
                      (touchoffect.dx -
                                  (eX - keydata["toothSA"][0] / zoom).abs())
                              .abs() *
                          zoom)
                  .toInt();
            }
            // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
            if (keydata["toothSA"][0] <= keydata["toothSA"][tooth - 1]) {
              keydata["toothSA"][0] = keydata["toothSA"][tooth - 1] + 100;
            }
          }
        }
        if ((touchoffect.dx - (eX - keydata["toothSB"][tooth - 1] / zoom))
                    .abs() <
                20 &&
            gesture) {
          baseKey.seleindex = tooth;
          if (touchoffect.dy > eY) {
            baseKey.seleside = 1;
            if (touchoffect.dx - (eX - keydata["toothSB"][tooth - 1] / zoom) >
                0) {
              keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] -
                      (touchoffect.dx -
                                  (eX - keydata["toothSB"][tooth - 1] / zoom)
                                      .abs())
                              .abs() *
                          zoom)
                  .toInt();
            } else {
              keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] +
                      (touchoffect.dx -
                                  (eX - keydata["toothSB"][tooth - 1] / zoom)
                                      .abs())
                              .abs() *
                          zoom)
                  .toInt();
            }
            //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
            if (keydata["toothSB"][tooth - 1] >= keydata["toothSB"][0]) {
              keydata["toothSB"][tooth - 1] = keydata["toothSB"][0] - 100;
            }
          } else {
            baseKey.seleside = 0;
            if (touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom) >
                0) {
              keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] -
                      (touchoffect.dx -
                                  (eX - keydata["toothSA"][tooth - 1] / zoom)
                                      .abs())
                              .abs() *
                          zoom)
                  .toInt();
            } else {
              keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] +
                      (touchoffect.dx -
                                  (eX - keydata["toothSA"][tooth - 1] / zoom)
                                      .abs())
                              .abs() *
                          zoom)
                  .toInt();
            }
            //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
            if (keydata["toothSA"][tooth - 1] >= keydata["toothSA"][0]) {
              keydata["toothSA"][tooth - 1] = keydata["toothSA"][0] - 100;
            }
          }
        }
        //print("baseKey.seleside:${baseKey.seleside}");

        for (var i = 0; i < tooth; i++) {
          if (i == 0 || i == tooth - 1) {
            paintcut.color = Colors.red;
            if (((touchoffect.dx - (eX - keydata["toothSB"][tooth - 1] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == tooth) {
              // //print("触发2:$i");
              if (i == tooth - 1 && baseKey.seleside == 1) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
            if (((touchoffect.dx - (eX - keydata["toothSB"][0] / zoom)).abs() <
                    20) ||
                baseKey.seleindex == 1) {
              ////print("触发:$i");
              if (i == 0 && baseKey.seleside == 1) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
          } else {
            paintcut.color = Colors.blue;
          }
          canvas.drawLine(Offset(eX - keydata["toothSB"][i] / zoom, cY + 5),
              Offset(eX - keydata["toothSB"][i] / zoom, eY + 10), paintcut);
        }

        for (var i = 0; i < tooth; i++) {
          if (i == 0 || i == tooth - 1) {
            paintcut.color = Colors.red;
            if (((touchoffect.dx - (eX - keydata["toothSA"][tooth - 1] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == tooth) {
              // //print("触发2:$i");
              if (i == tooth - 1 && baseKey.seleside == 0) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
            if (((touchoffect.dx - (eX - keydata["toothSA"][0] / zoom)).abs() <
                    20) ||
                baseKey.seleindex == 1) {
              ////print("触发:$i");
              if (i == 0 && baseKey.seleside == 0) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
          } else {
            paintcut.color = Colors.blue;
          }
          canvas.drawLine(Offset(eX - keydata["toothSA"][i] / zoom, eY - 10),
              Offset(eX - keydata["toothSA"][i] / zoom, gY - 5), paintcut);
        }
      } else {
        //对肩膀
        paintcut.color = const Color(0XFF6E66AA);
        canvas.drawLine(
            Offset(locatx, cY + 20), Offset(locatx, gY - 20), paintcut);

        if ((touchoffect.dx - (locatx + keydata["toothSB"][0] / zoom)).abs() <
                20 &&
            gesture) {
          baseKey.seleindex = 1;
          if (touchoffect.dy > eY) {
            baseKey.seleside = 1;
            if (touchoffect.dx - (locatx + keydata["toothSB"][0] / zoom) > 0) {
              keydata["toothSB"][0] = (keydata["toothSB"][0] +
                      (touchoffect.dx -
                                  (locatx + keydata["toothSB"][0] / zoom).abs())
                              .abs() *
                          zoom)
                  .toInt();
            } else {
              keydata["toothSB"][0] = (keydata["toothSB"][0] -
                      (touchoffect.dx -
                                  (locatx + keydata["toothSB"][0] / zoom).abs())
                              .abs() *
                          zoom)
                  .toInt();
            }
            // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
            if (keydata["toothSB"][0] >= keydata["toothSB"][tooth - 1]) {
              keydata["toothSB"][0] = keydata["toothSB"][tooth - 1] - 100;
            }
          } else {
            baseKey.seleside = 0;
            if (touchoffect.dx - (locatx + keydata["toothSA"][0] / zoom) > 0) {
              keydata["toothSA"][0] = (keydata["toothSA"][0] +
                      (touchoffect.dx -
                                  (locatx + keydata["toothSA"][0] / zoom).abs())
                              .abs() *
                          zoom)
                  .toInt();
            } else {
              keydata["toothSA"][0] = (keydata["toothSA"][0] -
                      (touchoffect.dx -
                                  (locatx + keydata["toothSA"][0] / zoom).abs())
                              .abs() *
                          zoom)
                  .toInt();
            }
            // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
            if (keydata["toothSA"][0] >= keydata["toothSA"][tooth - 1]) {
              keydata["toothSA"][0] = keydata["toothSA"][tooth - 1] - 100;
            }
          }
        }
        if ((touchoffect.dx - (locatx + keydata["toothSB"][tooth - 1] / zoom))
                    .abs() <
                20 &&
            gesture) {
          baseKey.seleindex = tooth;
          if (touchoffect.dy > eY) {
            baseKey.seleside = 1;
            if (touchoffect.dx -
                    (locatx + keydata["toothSB"][tooth - 1] / zoom) >
                0) {
              keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] +
                      (touchoffect.dx -
                                  (locatx +
                                          keydata["toothSB"][tooth - 1] / zoom)
                                      .abs())
                              .abs() *
                          zoom)
                  .toInt();
            } else {
              keydata["toothSB"][tooth - 1] = (keydata["toothSB"][tooth - 1] -
                      (touchoffect.dx -
                                  (locatx +
                                          keydata["toothSB"][tooth - 1] / zoom)
                                      .abs())
                              .abs() *
                          zoom)
                  .toInt();
            }
            //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
            if (keydata["toothSB"][tooth - 1] <= keydata["toothSB"][0]) {
              keydata["toothSB"][tooth - 1] = keydata["toothSB"][0] + 100;
            }
          } else {
            baseKey.seleside = 0;
            if (touchoffect.dx -
                    (locatx + keydata["toothSA"][tooth - 1] / zoom) >
                0) {
              keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] +
                      (touchoffect.dx -
                                  (locatx +
                                          keydata["toothSA"][tooth - 1] / zoom)
                                      .abs())
                              .abs() *
                          zoom)
                  .toInt();
            } else {
              keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] -
                      (touchoffect.dx -
                                  (locatx +
                                          keydata["toothSA"][tooth - 1] / zoom)
                                      .abs())
                              .abs() *
                          zoom)
                  .toInt();
            }
            //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
            if (keydata["toothSA"][tooth - 1] <= keydata["toothSA"][0]) {
              keydata["toothSA"][tooth - 1] = keydata["toothSA"][0] + 100;
            }
          }
        }
        //print("baseKey.seleside:${baseKey.seleside}");

        for (var i = 0; i < tooth; i++) {
          if (i == 0 || i == tooth - 1) {
            paintcut.color = Colors.red;
            if (((touchoffect.dx -
                            (locatx + keydata["toothSB"][tooth - 1] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == tooth) {
              // //print("触发2:$i");
              if (i == tooth - 1 && baseKey.seleside == 1) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
            if (((touchoffect.dx - (locatx + keydata["toothSB"][0] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == 1) {
              ////print("触发:$i");
              if (i == 0 && baseKey.seleside == 1) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
          } else {
            paintcut.color = Colors.blue;
          }
          canvas.drawLine(Offset(locatx + keydata["toothSB"][i] / zoom, cY + 5),
              Offset(locatx + keydata["toothSB"][i] / zoom, eY + 10), paintcut);
        }

        for (var i = 0; i < tooth; i++) {
          if (i == 0 || i == tooth - 1) {
            paintcut.color = Colors.red;
            if (((touchoffect.dx -
                            (locatx + keydata["toothSA"][tooth - 1] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == tooth) {
              // //print("触发2:$i");
              if (i == tooth - 1 && baseKey.seleside == 0) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
            if (((touchoffect.dx - (locatx + keydata["toothSA"][0] / zoom))
                        .abs() <
                    20) ||
                baseKey.seleindex == 1) {
              ////print("触发:$i");
              if (i == 0 && baseKey.seleside == 0) {
                paintcut.color = Colors.green;
              } else {
                paintcut.color = Colors.red;
              }
            }
          } else {
            paintcut.color = Colors.blue;
          }
          canvas.drawLine(
              Offset(locatx + keydata["toothSA"][i] / zoom, eY - 10),
              Offset(locatx + keydata["toothSA"][i] / zoom, gY - 5),
              paintcut);
        }
      }
    } else {
      //显示齿号 以及齿深线
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // //print(size.height);

    // //print(size.width);
    _wide = size.width;
    _hight = size.height;
    switch (keydata["class"]) {
      case 0: //平铣双边
        drawSB0KeY(canvas);
        break;
      case 1: //平铣单边
        //print(sAhNum);
        //print(sBhNum);
        //print(keydata["side"]);
        //print(keydata["locat"]);
        //print(sAhNum.length);
        //print(sBhNum.length);
        drawSB3KeY(canvas);
        break;
      case 2: //立铣内沟双边

        drawSB2KeY(canvas);
        break;
      case 3: //立铣外沟单边
        //print(sAhNum);
        //print(sBhNum);
        //print(keydata["side"]);
        //print(keydata["locat"]);
        //print(sAhNum.length);
        //print(sBhNum.length);
        drawSB3KeY(canvas);
        break;
      case 4: //立铣外沟双边
        drawSB4KeY(canvas);
        break;
      case 5: //立铣内沟单边
        drawSB5KeY(canvas); //画实际齿深
        // drawSB5CKeY(canvas); //画标准齿深
        break;
      case 6:
        break;
      case 7:
        break;
      case 8:
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
