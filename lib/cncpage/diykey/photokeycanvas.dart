import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:magictank/cncpage/basekey.dart';

///
/// @ClassName FlutterPainter
/// @Description 绘制类
/// @Author waitwalker
/// @Date 2020-03-07
/*
//点的定义
 (0.0)→x+           (headX,headY)E
 ↓                    *         
 y+                 *    *
   (head1x,head1y)*D       *(head2x,head2y) F
                  *        *
                  *        *
                  *        *
                  *        *
                  *        *
                  *        *
(beginx,beginy)****BC      ****(endX,endY) GH
               *              *
(locatx,locaty)* A            *(locatx,locaty)I
*/

class PhotoPainter extends CustomPainter {
  Map keydata;
  int zoom = 7; //缩放倍数
  late double _wide;
  late double _hight;
  //List<int> baseKey.ahNum;
  // List<int> baseKey.bhNum;
  //List<String> sbaseKey.ahNum;
  // List<String> sbaseKey.bhNum;
  double effectivetouch = 5; //定义有效触摸区域 +/-
  Offset touchoffset;
  int step;
  int seletooth;
  PhotoPainter(this.touchoffset, this.step, this.keydata, this.seletooth);

  Paint paintline = Paint()
    ..color = Colors.blue //画笔颜色
    ..strokeCap = StrokeCap.round //画笔笔触类型
    ..isAntiAlias = true //是否启动抗锯齿
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0; //画笔的宽度
  Paint paintcut = Paint()
    ..color = Colors.red //画笔颜色
    ..strokeCap = StrokeCap.round //画笔笔触类型
    ..isAntiAlias = true //是否启动抗锯齿
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0; //画笔的宽度
  Paint paintspot = Paint()
    ..color = Colors.red //画笔颜色
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

//绘图平铣双边
  void drawSB0key(Canvas canvas) {
    // Color frontcolor = Colors.blue;
    // double length;
    int tooth = keydata["toothSA"].length;
    List<Offset> post = [];
    //List<Offset> post2 = [];
    //Rect rect;

    if (keydata["locat"] == 0) {
      // length = keydata["toothSA"][tooth - 1] / zoom +
      //     keydata["wide"] / zoom / 2 +
      //     20; //有一个尖头
      double cX = (_wide - keydata["wide"] / zoom) / 2;
      double cY = (_hight - keydata["toothSA"][tooth - 1] / zoom) / 2 +
          keydata["toothSA"][tooth - 1] / zoom;
      double bX = (_wide - 1000 / zoom) / 2;
      double bY = cY;
      double aX = bX;
      double aY = bY + 20;
      double dX = cX;
      double dY = cY - keydata["toothSA"][tooth - 1] / zoom - 20;
      double eX = _wide / 2;
      double eY = dY - 30;
      double fX = cX + keydata["wide"] / zoom;
      double fY = dY;
      double gX = fX;
      double gY = cY;
      double hX = bX + 1000 / zoom;
      double hY = gY;
      double iX = hX;
      double iY = aY;

      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀
      post.add(Offset(aX, aY));
      post.add(Offset(bX, bY));
      post.add(Offset(cX, cY));

      for (var i = 0; i < tooth; i++) {
        post.add(Offset(gX - baseKey.bhNum[i] / zoom,
            gY - keydata["toothSA"][i] / zoom + 2));
        post.add(Offset(gX - baseKey.bhNum[i] / zoom,
            gY - keydata["toothSA"][i] / zoom - 2));
      }
      post.add(Offset(dX, dY));
      post.add(Offset(eX, eY));
      post.add(Offset(fX, fY));
      for (var i = tooth - 1; i >= 0; i--) {
        post.add(Offset(cX + baseKey.ahNum[i] / zoom,
            cY - keydata["toothSA"][i] / zoom - 2));
        post.add(Offset(cX + baseKey.ahNum[i] / zoom,
            cY - keydata["toothSA"][i] / zoom + 2));
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
      //对头类钥匙画法
      double cX = (_wide - keydata["wide"] / zoom) / 2;
      double cY = (_hight - 2000 / zoom) / 2 + 2000 / zoom;

      double dX = cX;
      double dY = cY - 2000 / zoom - 20;
      double eX = _wide / 2;
      double eY = dY - 30;
      double fX = cX + keydata["wide"] / zoom;
      double fY = dY;
      double gX = fX;
      double gY = cY;

      //根据齿号生成轨迹

      post.add(Offset(cX, cY));
      //先画左边
      for (var i = 0; i < tooth; i++) {
        post.add(Offset(cX, eY + keydata["toothSA"][i] / zoom + 2));
        post.add(Offset(cX, eY + keydata["toothSA"][i] / zoom - 2));
      }
      post.add(Offset(dX, dY));
      post.add(Offset(eX, eY));
      post.add(Offset(fX, fY));
      for (var i = tooth - 1; i >= 0; i--) {
        post.add(Offset(fX, eY + keydata["toothSA"][i] / zoom - 2));
        post.add(Offset(fX, eY + keydata["toothSA"][i] / zoom + 2));
      }
      post.add(Offset(gX, gY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = Colors.blue);
      if (step == 6) {
        //画齿位线 操作齿位线
        //print("画齿位");
        int tooth = keydata["toothSA"].length;
        if ((touchoffset.dy - (eY + keydata["toothSA"][0] / zoom)).abs() <
            20.0) {
          baseKey.seleindex = 0;
          //print("lest");
          if (touchoffset.dy - (eY + keydata["toothSA"][0] / zoom) > 0) {
            keydata["toothSA"][0] = (keydata["toothSA"][0] +
                    (touchoffset.dy - (eY + keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][0] = (keydata["toothSA"][0] -
                    (touchoffset.dy - (eY + keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
          // if (keydata["locat"] == 1) {
          //   if (keydata["toothSA"][0] <= keydata["toothSA"][tooth - 1]) {
          //     keydata["toothSA"][0] = keydata["toothSA"][tooth - 1] + 200;
          //   }
          // }
        }
        if ((touchoffset.dy - (eY + keydata["toothSA"][tooth - 1] / zoom))
                .abs() <
            20.0) {
          baseKey.seleindex = tooth - 1;
          //print("head");

          if (touchoffset.dy - (eY + keydata["toothSA"][tooth - 1] / zoom) >
              0) {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] +
                    (touchoffset.dy -
                                (eY + keydata["toothSA"][tooth - 1] / zoom))
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] -
                    (touchoffset.dy -
                                (eY + keydata["toothSA"][tooth - 1] / zoom))
                            .abs() *
                        zoom)
                .toInt();
          }
          // keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
          if (keydata["locat"] == 1) {
            if (keydata["toothSA"][0] <= keydata["toothSA"][tooth - 1]) {
              keydata["toothSA"][0] = keydata["toothSA"][tooth - 1] + 200;
            }
          }
        }

        for (var i = 0; i < tooth; i++) {
          if (baseKey.seleindex == i) {
            paintcut.color = Colors.green;
          } else {
            paintcut.color = Colors.red;
          }
          canvas.drawLine(Offset(cX - 5, eY + keydata["toothSA"][i] / zoom),
              Offset(fX + 5, eY + keydata["toothSA"][i] / zoom), paintcut);

          _showtext(
              canvas,
              keydata["toothSA"][i].toString(),
              Offset(cX - 25, eY + keydata["toothSA"][i] / zoom),
              10,
              Colors.blue);
        }
      }
      if (step == 7) {
        //画齿深线

        int toothnum = keydata["toothDepth"].length;
        //print("齿深：$toothnum");
        if ((touchoffset.dx - (cX + keydata["toothDepth"][0] / zoom)).abs() <
            10.0) {
          baseKey.seleindex = 0;
          //print("一号齿深");
          if (touchoffset.dx - (cX + keydata["toothDepth"][0] / zoom) > 0) {
            keydata["toothDepth"][0] = (keydata["toothDepth"][0] +
                    (touchoffset.dx -
                                (cX + keydata["toothDepth"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothDepth"][0] = (keydata["toothDepth"][0] -
                    (touchoffset.dx -
                                (cX + keydata["toothDepth"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][0] = keydata["toothSA"][0] + cutsindeX;
          // if (keydata["toothDepth"] == 1) {
          //   if (keydata["toothDepth"][0] <=
          //       keydata["toothDepth"][toothnum - 1]) {
          //     keydata["toothDepth"][0] =
          //         keydata["toothDepth"][toothnum - 1] + 10;
          //   }
          // }
        } else if ((touchoffset.dx -
                    (cX + keydata["toothDepth"][toothnum - 1] / zoom))
                .abs() <
            10.0) {
          baseKey.seleindex = toothnum - 1;
          //print("最后齿深");

          if (touchoffset.dx -
                  (cX + keydata["toothDepth"][toothnum - 1] / zoom) >
              0) {
            keydata["toothDepth"][toothnum - 1] = (keydata["toothDepth"]
                        [toothnum - 1] +
                    (touchoffset.dx -
                                (cX +
                                    keydata["toothDepth"][toothnum - 1] / zoom))
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothDepth"][toothnum - 1] = (keydata["toothDepth"]
                        [toothnum - 1] -
                    (touchoffset.dx -
                                (cX +
                                    keydata["toothDepth"][toothnum - 1] / zoom))
                            .abs() *
                        zoom)
                .toInt();
          }

          // if (keydata["toothDepth"][0] <= keydata["toothDepth"][toothnum - 1]) {
          //    keydata["toothDepth"][0] = keydata["toothDepth"][toothnum - 1] + 10;
          //  }
        }

        for (var i = 0; i < toothnum; i++) {
          if (baseKey.seleindex == i) {
            paintcut.color = Colors.green;
          } else {
            paintcut.color = Colors.red;
          }
          canvas.drawLine(Offset(cX + keydata["toothDepth"][i] / zoom, eY - 20),
              Offset(cX + keydata["toothDepth"][i] / zoom, cY + 20), paintcut);

          _showtext(
              canvas,
              keydata["toothDepth"][i].toString(),
              Offset(cX + keydata["toothDepth"][i] / zoom,
                  eY + keydata["toothDepth"][i] / zoom),
              10,
              Colors.blue);
        }
      }

//画定位线
      paintcut.color = Colors.red;
      canvas.drawLine(Offset(cX - 5, eY), Offset(fX + 5, eY), paintcut);
    }
  }

//立铣外沟双边
  void drawSB4key(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+
    ---------------------------
    */
    // Color frontcolor = Colors.blue;
    //double length;
    int tooth = keydata["toothSA"].length;
    List<Offset> post = [];
    //  List<Offset> post2 = [];
    Rect rect;
    if (keydata["locat"] == 0) {
      // length = keydata["toothSA"][tooth - 1] / zoom +
      //     keydata["wide"] / zoom / 2 +
      //     20; //有一个尖头
      double cX = (_wide - keydata["wide"] / zoom) / 2;
      double cY = (_hight - keydata["toothSA"][tooth - 1] / zoom) / 2 +
          keydata["toothSA"][tooth - 1] / zoom;
      double bX = (_wide - 1000 / zoom) / 2;
      double bY = cY;
      double aX = bX;
      double aY = bY + 20;
      double dX = cX;
      double dY = cY - keydata["toothSA"][tooth - 1] / zoom - 20;
      double eX = _wide / 2;
      double eY = dY - 30;
      double fX = cX + keydata["wide"] / zoom;
      double fY = dY;
      double gX = fX;
      double gY = cY;
      double hX = bX + 1000 / zoom;
      double hY = gY;
      double iX = hX;
      double iY = aY;

      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀
      post.add(Offset(aX, aY));
      post.add(Offset(bX, bY));
      post.add(Offset(cX, cY));

      for (var i = 0; i < tooth; i++) {
        post.add(Offset(gX - baseKey.bhNum[i] / zoom,
            gY - keydata["toothSA"][i] / zoom + 2));
        post.add(Offset(gX - baseKey.bhNum[i] / zoom,
            gY - keydata["toothSA"][i] / zoom - 2));
      }
      post.add(Offset(dX, dY));
      post.add(Offset(eX, eY));
      post.add(Offset(fX, fY));
      for (var i = tooth - 1; i >= 0; i--) {
        post.add(Offset(cX + baseKey.ahNum[i] / zoom,
            cY - keydata["toothSA"][i] / zoom - 2));
        post.add(Offset(cX + baseKey.ahNum[i] / zoom,
            cY - keydata["toothSA"][i] / zoom + 2));
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

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      //绘制B面的齿深线

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(gX - keydata["toothDepth"][i] / zoom, aY),
              Offset(gX - keydata["toothDepth"][i] / zoom, eY),
            ],
            paintcut..color = Colors.red);

        //   //绘制上面的齿深线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(cX + keydata["toothDepth"][i] / zoom, aY),
              Offset(cX + keydata["toothDepth"][i] / zoom, eY),
            ],
            paintcut..color = Colors.red);
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(gX - keydata["toothDepth"][i] / zoom, eY - 6),
            10,
            Colors.blue);
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(cX + keydata["toothDepth"][i] / zoom, eY - 6),
            10,
            Colors.blue);
        canvas.drawLine(Offset(bX - 20, bY), Offset(hX + 20, hY), paintcut);
      }

      for (var i = 0; i < tooth; i++) {
        // if (i == cutsindeX) {
        //   frontcolor = Colors.red;
        // } else {
        //   frontcolor = Colors.blue;
        // }
        // frontcolor = Colors.blue;
        // _showtext(
        //     canvas,
        //     baseKey.ahNums[i],
        //     Offset(headX - keydata["toothSA"][i] / zoom - 9, endY - 18),
        //     18,
        //     frontcolor);
        // _showtext(
        //     canvas,
        //     baseKey.ahNums[i],
        //     Offset(headX - keydata["toothSA"][i] / zoom - 9, beginy + 18),
        //     18,
        //     frontcolor);
        //画齿深远点
        if (step - tooth == i && step > tooth) {
          paintline.color = Colors.green;
        } else {
          paintline.color = Colors.blue;
        }
        rect = Rect.fromCircle(
            center: Offset(gX - baseKey.bhNum[i] / zoom,
                gY - keydata["toothSA"][i] / zoom),
            radius: 2.0);
        canvas.drawArc(rect, 0, 360, false, paintline);
        if (step == i) {
          paintline.color = Colors.green;
        } else {
          paintline.color = Colors.blue;
        }
        rect = Rect.fromCircle(
            center: Offset(cX + baseKey.ahNum[i] / zoom,
                cY - keydata["toothSA"][i] / zoom),
            radius: 2.0);
        canvas.drawArc(rect, 0, 360, false, paintline);
      }
    } else {
      //对头类钥匙画法
      //print"对头");
      double cX = (_wide - keydata["wide"] / zoom) / 2;
      double cY = (_hight - keydata["toothSA"][0] / zoom) / 2 +
          keydata["toothSA"][0] / zoom;
      //double bX = (_wide - 1000 / zoom) / 2;
      // double bY = cY;
      //double aX = bX;
      //double aY = bY + 20;
      double dX = cX;
      double dY = cY - keydata["toothSA"][0] / zoom - 20;
      double eX = _wide / 2;
      double eY = dY - 30;
      double fX = cX + keydata["wide"] / zoom;
      double fY = dY;
      double gX = fX;
      double gY = cY;
      // double hX = bX + 1000 / zoom;
      // double hY = gY;
      //double iX = hX;
      //  double iY = aY;

      // length = keydata["toothSA"][tooth - 1] / zoom; //
      // double beginx = 50;
      // double beginy = 140; //代表肩膀宽度为1000丝
      // length =
      //     keydata["toothSA"][0] / zoom + keydata["wide"] / zoom / 2; //有一个尖头

      //判断触摸的位置是否在有效区域
      //判断方法 计算每个齿的的有效区域并判断是否在这个范围内
      // debugPrint("触摸位置");
      ////print(touchoffset);
      // debugPrint("起始位置");

      // int j = 0;
      // for (var i = 0; i < tooth; i++) {
      //   //effectivetouch
      //   //先确定X坐标
      //   // ////print(headY + keydata["toothSA"][i] / zoom);
      //   if (eY + keydata["toothSA"][i] / zoom - effectivetouch <
      //           touchoffset.dy &&
      //       touchoffset.dy <
      //           eY + keydata["toothSA"][i] / zoom + effectivetouch) {
      //     for (j = 0; j < baseKey.toothDepth.length; j++) {
      //       //判断A边区域
      //       if (touchoffset.dx >
      //               gX - keydata["toothDepth"][j] / zoom - effectivetouch &&
      //           touchoffset.dx <
      //               gX - keydata["toothDepth"][j] / zoom + effectivetouch) {
      //         debugPrint("捕捉到齿位:$i");
      //         baseKey.ahNum[i] = keydata["toothDepth"][j];
      //         baseKey.ahNums[i] = baseKey.toothDepthName[j];
      //         // baseKey.bhNum[i] = keydata["toothDepth"][j];
      //         // baseKey.bhNums[i] = baseKey.toothDepthName[j];
      //         break;
      //       }
      //       //判断B边的区域
      //       if (touchoffset.dx >
      //               cX + keydata["toothDepth"][j] / zoom - effectivetouch &&
      //           touchoffset.dx <
      //               cX + keydata["toothDepth"][j] / zoom + effectivetouch) {
      //         // baseKey.ahNum[i] = keydata["toothDepth"][j];
      //         //  baseKey.ahNums[i] = baseKey.toothDepthName[j];
      //         baseKey.bhNum[i] = keydata["toothDepth"][j];
      //         baseKey.bhNums[i] = baseKey.toothDepthName[j];
      //         break;
      //       }
      //     }
      ////print(j);
/*
          if (j == baseKey.toothDepth.length) //没有找到位置启用第二套方案
          {
            if (touchoffset.dx >
                    gX -
                        baseKey.toothDepth
                                [baseKey.toothDepth.length - 1] /
                            zoom +
                        effectivetouch &&
                touchoffset.dx <
                    cX +
                        baseKey.toothDepth
                                [baseKey.toothDepth.length - 1] /
                            zoom -
                        effectivetouch) {
              int currentindeX = baseKey.toothDepth.indeXOf(baseKey.ahNum[i]);
              ////print(baseKey.ahNum[i]);
              ////print(baseKey.toothDepth.length);
              ////print(currentindeX);
              int Depthlength = baseKey.toothDepth.length - 1;
              if (currentindeX < Depthlength) {
                currentindeX = currentindeX + 1;
              }
              ////print(currentindeX);
              baseKey.ahNum[i] = keydata["toothDepth"][currentindeX];
              baseKey.ahNums[i] = baseKey.toothDepthName[currentindeX];
              baseKey.bhNum[i] = keydata["toothDepth"][currentindeX];
              baseKey.bhNums[i] = baseKey.toothDepthName[currentindeX];
            }

            if (touchoffset.dx <
                    gX - keydata["toothDepth"][0] / zoom - effectivetouch ||
                touchoffset.dx >
                    cX + keydata["toothDepth"][0] / zoom + effectivetouch) {
              int currentindeX = baseKey.toothDepth.indeXOf(baseKey.ahNum[i]);
              ////print(baseKey.ahNum[i]);
              ////print(baseKey.toothDepth.length);
              ////print(currentindeX);
              int Depthlength = baseKey.toothDepth.length - 1;
              if (currentindeX > 0) {
                currentindeX = currentindeX - 1;
              }
              ////print(currentindeX);
              baseKey.ahNum[i] = keydata["toothDepth"][currentindeX];
              baseKey.ahNums[i] = baseKey.toothDepthName[currentindeX];
              baseKey.bhNum[i] = keydata["toothDepth"][currentindeX];
              baseKey.bhNums[i] = baseKey.toothDepthName[currentindeX];
            }
          }*/
      // }
      //}

      //根据齿号生成轨迹

      post.add(Offset(cX, cY));
      //先画左边
      for (var i = 0; i < tooth; i++) {
        post.add(Offset(gX - baseKey.ahNum[i] / zoom,
            eY + keydata["toothSA"][i] / zoom + 2));
        post.add(Offset(gX - baseKey.ahNum[i] / zoom,
            eY + keydata["toothSA"][i] / zoom - 2));
      }
      post.add(Offset(dX, dY));
      post.add(Offset(eX, eY));
      post.add(Offset(fX, fY));
      for (var i = tooth - 1; i >= 0; i--) {
        post.add(Offset(cX + baseKey.bhNum[i] / zoom,
            eY + keydata["toothSA"][i] / zoom - 2));
        post.add(Offset(cX + baseKey.bhNum[i] / zoom,
            eY + keydata["toothSA"][i] / zoom + 2));
      }
      post.add(Offset(gX, gY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = Colors.blue);

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      //绘制下面的齿深线

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(gX - keydata["toothDepth"][i] / zoom, cY),
              Offset(gX - keydata["toothDepth"][i] / zoom, eY),
            ],
            paintcut..color = Colors.red);

        //   //绘制上面的齿深线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(cX + keydata["toothDepth"][i] / zoom, cY),
              Offset(cX + keydata["toothDepth"][i] / zoom, eY),
            ],
            paintcut..color = Colors.red);
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(gX - keydata["toothDepth"][i] / zoom, eY - 6),
            10,
            Colors.blue);
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(cX + keydata["toothDepth"][i] / zoom, eY - 6),
            10,
            Colors.blue);
      }

      for (var i = 0; i < tooth; i++) {
        // if (i == cutsindeX) {
        //   frontcolor = Colors.red;
        // } else {
        //   frontcolor = Colors.blue;
        // }
        //frontcolor = Colors.blue;
        // _showtext(
        //     canvas,
        //     baseKey.ahNums[i],
        //     Offset(headX - keydata["toothSA"][i] / zoom - 9, endY - 18),
        //     18,
        //     frontcolor);
        // _showtext(
        //     canvas,
        //     baseKey.ahNums[i],
        //     Offset(headX - keydata["toothSA"][i] / zoom - 9, beginy + 18),
        //     18,
        //     frontcolor);
        //画齿深远点
        if (step == i) {
          paintline.color = Colors.green;
        } else {
          paintline.color = Colors.blue;
        }
        rect = Rect.fromCircle(
            center: Offset(gX - baseKey.ahNum[i] / zoom,
                eY + keydata["toothSA"][i] / zoom),
            radius: 2.0);
        canvas.drawArc(rect, 0, 360, false, paintline);
        rect = Rect.fromCircle(
            center: Offset(cX + baseKey.bhNum[i] / zoom,
                eY + keydata["toothSA"][i] / zoom),
            radius: 2.0);
        canvas.drawArc(rect, 0, 360, false, paintline);
      }
//画定位线
      canvas.drawLine(Offset(cX - 5, eY), Offset(fX + 5, eY), paintcut);
    }
  }

//立铣外沟单边
//平铣单边
  void drawSB3key(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+
    ---------------------------
    */
    // Color frontcolor = Colors.blue;
    //double length;
    int tooth = keydata["toothSA"].length;
    List<Offset> post = [];
    //List<Offset> post2 = [];
    Rect rect;
    if (keydata["locat"] == 0) {
      // length = keydata["toothSA"][tooth - 1] / zoom +
      //     keydata["wide"] / zoom / 2 +
      //     20; //有一个尖头
      double cX = (_wide - keydata["wide"] / zoom) / 2;
      double cY = (_hight - keydata["toothSA"][tooth - 1] / zoom) / 2 +
          keydata["toothSA"][tooth - 1] / zoom;
      double bX = (_wide - 1000 / zoom) / 2;
      double bY = cY;
      double aX = bX;
      double aY = bY + 20;
      double dX = cX;
      double dY = cY - keydata["toothSA"][tooth - 1] / zoom - 20;
      // double eX = _wide / 2;
      double eY = dY - 30;
      double fX = cX + keydata["wide"] / zoom;
      double fY = dY;
      double gX = fX;
      double gY = cY;
      double hX = bX + 1000 / zoom;
      double hY = gY;
      double iX = hX;
      double iY = aY;

      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀
      if (baseKey.side == 1) {
        post.add(Offset(iX, iY));
        post.add(Offset(hX, hY));
        post.add(Offset(gX, gY));
        post.add(Offset(fX, fY));
        for (var i = tooth - 1; i >= 0; i--) {
          post.add(Offset(gX - baseKey.bhNum[i] / zoom,
              gY - keydata["toothSA"][i] / zoom + 2));
          post.add(Offset(gX - baseKey.bhNum[i] / zoom,
              gY - keydata["toothSA"][i] / zoom - 2));
        }
        post.add(Offset(cX, cY));
        post.add(Offset(bX, bY));
        post.add(Offset(aX, aY));
      } else {
        post.add(Offset(aX, aY));
        post.add(Offset(bX, bY));
        post.add(Offset(cX, cY));
        post.add(Offset(dX, dY));
        for (var i = tooth - 1; i >= 0; i--) {
          post.add(Offset(cX + baseKey.ahNum[i] / zoom,
              cY - keydata["toothSA"][i] / zoom - 2));
          post.add(Offset(cX + baseKey.ahNum[i] / zoom,
              cY - keydata["toothSA"][i] / zoom + 2));
        }
        post.add(Offset(gX, gY));
        post.add(Offset(hX, hY));
        post.add(Offset(iX, iY));
      }

      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = Colors.blueAccent);

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      //绘制B面的齿深线

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        if (baseKey.side == 1) {
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(gX - keydata["toothDepth"][i] / zoom, aY),
                Offset(gX - keydata["toothDepth"][i] / zoom, eY),
              ],
              paintcut..color = Colors.red);
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(gX - keydata["toothDepth"][i] / zoom, eY - 6),
              10,
              Colors.blue);
        } else {
          //   //绘制上面的齿深线
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(cX + keydata["toothDepth"][i] / zoom, aY),
                Offset(cX + keydata["toothDepth"][i] / zoom, eY),
              ],
              paintcut..color = Colors.red);
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(cX + keydata["toothDepth"][i] / zoom, eY - 6),
              10,
              Colors.blue);
        }

        canvas.drawLine(Offset(bX - 20, bY), Offset(hX + 20, hY), paintcut);
      }

      for (var i = 0; i < tooth; i++) {
        // if (i == cutsindeX) {
        //   frontcolor = Colors.red;
        // } else {
        //   frontcolor = Colors.blue;
        // }
        // frontcolor = Colors.blue;
        // _showtext(
        //     canvas,
        //     baseKey.ahNums[i],
        //     Offset(headX - keydata["toothSA"][i] / zoom - 9, endY - 18),
        //     18,
        //     frontcolor);
        // _showtext(
        //     canvas,
        //     baseKey.ahNums[i],
        //     Offset(headX - keydata["toothSA"][i] / zoom - 9, beginy + 18),
        //     18,
        //     frontcolor);
        //画齿深远点
        if (step == i) {
          paintline.color = Colors.green;
        } else {
          paintline.color = Colors.blue;
        }
        if (baseKey.side == 1) {
          rect = Rect.fromCircle(
              center: Offset(gX - baseKey.bhNum[i] / zoom,
                  gY - keydata["toothSA"][i] / zoom),
              radius: 2.0);
          canvas.drawArc(rect, 0, 360, false, paintline);
        } else {
          rect = Rect.fromCircle(
              center: Offset(cX + baseKey.ahNum[i] / zoom,
                  cY - keydata["toothSA"][i] / zoom),
              radius: 2.0);
          canvas.drawArc(rect, 0, 360, false, paintline);
        }
      }
    } else {
      //对头类钥匙画法
      double cX = (_wide - keydata["wide"] / zoom) / 2;
      double cY = (_hight - keydata["toothSA"][0] / zoom) / 2 +
          keydata["toothSA"][0] / zoom;
      //double bX = (_wide - 1000 / zoom) / 2;
      //double bY = cY;
      //double aX = bX;
      //double aY = bY + 20;
      double dX = cX;
      double dY = cY - keydata["toothSA"][0] / zoom - 20;
      // double eX = _wide / 2;
      double eY = dY;
      double fX = cX + keydata["wide"] / zoom;
      double fY = dY;
      double gX = fX;
      double gY = cY;
      // double hX = bX + 1000 / zoom;
      // double hY = gY;
      // double iX = hX;
      // double iY = aY;

      // length = keydata["toothSA"][tooth - 1] / zoom; //
      // double beginx = 50;
      // double beginy = 140; //代表肩膀宽度为1000丝
      // length =
      //     keydata["toothSA"][0] / zoom + keydata["wide"] / zoom / 2; //有一个尖头

      //判断触摸的位置是否在有效区域
      //判断方法 计算每个齿的的有效区域并判断是否在这个范围内
      debugPrint("触摸位置");
      ////print(touchoffset);
      debugPrint("起始位置");

      int j = 0;
      for (var i = 0; i < tooth; i++) {
        //effectivetouch
        //先确定X坐标
        // ////print(headY + keydata["toothSA"][i] / zoom);
        if (eY + keydata["toothSA"][i] / zoom - effectivetouch <
                touchoffset.dy &&
            touchoffset.dy <
                eY + keydata["toothSA"][i] / zoom + effectivetouch) {
          for (j = 0; j < baseKey.toothDepth.length; j++) {
            //判断A边区域

            if (baseKey.side == 1) {
              if (touchoffset.dx >
                      gX - keydata["toothDepth"][j] / zoom - effectivetouch &&
                  touchoffset.dx <
                      gX - keydata["toothDepth"][j] / zoom + effectivetouch) {
                debugPrint("捕捉到齿位:$i");
                baseKey.ahNum[i] = keydata["toothDepth"][j];
                baseKey.ahNums[i] = baseKey.toothDepthName[j];
                // baseKey.bhNum[i] = keydata["toothDepth"][j];
                // baseKey.bhNums[i] = baseKey.toothDepthName[j];
                break;
              }
            }
            //判断B边的区域
            else {
              if (touchoffset.dx >
                      cX + keydata["toothDepth"][j] / zoom - effectivetouch &&
                  touchoffset.dx <
                      cX + keydata["toothDepth"][j] / zoom + effectivetouch) {
                // baseKey.ahNum[i] = keydata["toothDepth"][j];
                //  baseKey.ahNums[i] = baseKey.toothDepthName[j];
                baseKey.bhNum[i] = keydata["toothDepth"][j];
                baseKey.bhNums[i] = baseKey.toothDepthName[j];
                break;
              }
            }
          }
          ////print(j);
/*
          if (j == baseKey.toothDepth.length) //没有找到位置启用第二套方案
          {
            if (touchoffset.dx >
                    gX -
                        baseKey.toothDepth
                                [baseKey.toothDepth.length - 1] /
                            zoom +
                        effectivetouch &&
                touchoffset.dx <
                    cX +
                        baseKey.toothDepth
                                [baseKey.toothDepth.length - 1] /
                            zoom -
                        effectivetouch) {
              int currentindeX = baseKey.toothDepth.indeXOf(baseKey.ahNum[i]);
              ////print(baseKey.ahNum[i]);
              ////print(baseKey.toothDepth.length);
              ////print(currentindeX);
              int Depthlength = baseKey.toothDepth.length - 1;
              if (currentindeX < Depthlength) {
                currentindeX = currentindeX + 1;
              }
              ////print(currentindeX);
              baseKey.ahNum[i] = keydata["toothDepth"][currentindeX];
              baseKey.ahNums[i] = baseKey.toothDepthName[currentindeX];
              baseKey.bhNum[i] = keydata["toothDepth"][currentindeX];
              baseKey.bhNums[i] = baseKey.toothDepthName[currentindeX];
            }

            if (touchoffset.dx <
                    gX - keydata["toothDepth"][0] / zoom - effectivetouch ||
                touchoffset.dx >
                    cX + keydata["toothDepth"][0] / zoom + effectivetouch) {
              int currentindeX = baseKey.toothDepth.indeXOf(baseKey.ahNum[i]);
              ////print(baseKey.ahNum[i]);
              ////print(baseKey.toothDepth.length);
              ////print(currentindeX);
              int Depthlength = baseKey.toothDepth.length - 1;
              if (currentindeX > 0) {
                currentindeX = currentindeX - 1;
              }
              ////print(currentindeX);
              baseKey.ahNum[i] = keydata["toothDepth"][currentindeX];
              baseKey.ahNums[i] = baseKey.toothDepthName[currentindeX];
              baseKey.bhNum[i] = keydata["toothDepth"][currentindeX];
              baseKey.bhNums[i] = baseKey.toothDepthName[currentindeX];
            }
          }*/
        }
      }

      //根据齿号生成轨迹

      if (baseKey.side == 1) {
        post.add(Offset(gX, gY));
        post.add(Offset(fX, fY));

        for (var i = tooth - 1; i >= 0; i--) {
          post.add(Offset(gX - baseKey.ahNum[i] / zoom,
              eY + keydata["toothSA"][i] / zoom - 2));
          post.add(Offset(gX - baseKey.ahNum[i] / zoom,
              eY + keydata["toothSA"][i] / zoom + 2));
        }
        post.add(Offset(cX, cY));
      } else {
        post.add(Offset(cX, cY));
        post.add(Offset(dX, dY));

        for (var i = tooth - 1; i >= 0; i--) {
          post.add(Offset(cX + baseKey.bhNum[i] / zoom,
              eY + keydata["toothSA"][i] / zoom - 2));
          post.add(Offset(cX + baseKey.bhNum[i] / zoom,
              eY + keydata["toothSA"][i] / zoom + 2));
        }
        post.add(Offset(gX, gY));
      }
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = Colors.blue);

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      //绘制下面的齿深线

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        if (baseKey.side == 1) {
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(gX - keydata["toothDepth"][i] / zoom, cY),
                Offset(gX - keydata["toothDepth"][i] / zoom, eY),
              ],
              paintcut..color = Colors.red);
        } else {
          //   //绘制上面的齿深线
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(cX + keydata["toothDepth"][i] / zoom, cY),
                Offset(cX + keydata["toothDepth"][i] / zoom, eY),
              ],
              paintcut..color = Colors.red);
        }
        if (baseKey.side == 1) {
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(gX - keydata["toothDepth"][i] / zoom, eY - 6),
              10,
              Colors.blue);
        } else {
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(cX + keydata["toothDepth"][i] / zoom, eY - 6),
              10,
              Colors.blue);
        }
      }

      for (var i = 0; i < tooth; i++) {
        // if (i == cutsindeX) {
        //   frontcolor = Colors.red;
        // } else {
        //   frontcolor = Colors.blue;
        // }
        //  frontcolor = Colors.blue;
        // _showtext(
        //     canvas,
        //     baseKey.ahNums[i],
        //     Offset(headX - keydata["toothSA"][i] / zoom - 9, endY - 18),
        //     18,
        //     frontcolor);
        // _showtext(
        //     canvas,
        //     baseKey.ahNums[i],
        //     Offset(headX - keydata["toothSA"][i] / zoom - 9, beginy + 18),
        //     18,
        //     frontcolor);
        if (baseKey.side == 1) {
          //画齿深远点
          rect = Rect.fromCircle(
              center: Offset(gX - baseKey.ahNum[i] / zoom,
                  eY + keydata["toothSA"][i] / zoom),
              radius: 2.0);
          canvas.drawArc(rect, 0, 360, false, paintline);
        } else {
          rect = Rect.fromCircle(
              center: Offset(cX + baseKey.bhNum[i] / zoom,
                  eY + keydata["toothSA"][i] / zoom),
              radius: 2.0);
          canvas.drawArc(rect, 0, 360, false, paintline);
        }
      }
//画定位线
      canvas.drawLine(Offset(cX - 5, eY), Offset(fX + 5, eY), paintcut);
    }
  }

//立铣内沟单边
  void drawSB5key(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+
    ---------------------------
    */
    //Color frontcolor = Colors.blue;
    //double length;
    int tooth = keydata["toothSA"].length;
    List<Offset> post = [];
    List<Offset> post2 = [];
    Rect rect;

    // length = keydata["toothSA"][tooth - 1] / zoom +
    //     keydata["wide"] / zoom / 2 +
    //     20; //有一个尖头
    double cX = (_wide - keydata["wide"] / zoom) / 2;
    double cY = (_hight - 3000 / zoom) / 2 + 3000 / zoom - 50;
    double bX = cX - 20;
    double bY = cY;
    double aX = bX;
    double aY = bY + 20;
    double dX = cX;
    double dY = cY - 3000 / zoom;
    double eX = cX + keydata["wide"] / zoom;
    double eY = dY;
    double fX = eX;
    double fY = cY;
    double gX = fX + 20;
    double gY = fY;
    double hX = gX;
    double hY = aY;

    //肩膀画法
    //判断对齐方式 对肩膀
    //根据齿号生成轨迹
    //先画肩膀
    post.add(Offset(aX, aY));
    post.add(Offset(bX, bY));
    post.add(Offset(cX, cY));
    post.add(Offset(dX, dY));
    post.add(Offset(eX, eY));
    post.add(Offset(fX, fY));
    post.add(Offset(gX, gY));
    post.add(Offset(hX, hY));

    canvas.drawPoints(

        ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
        PointMode.polygon, //首尾相连
        //PointMode.lines, //两两相连
        //PointMode.points,//画点
        post,
        paintline..color = Colors.blueAccent);

    //绘制齿深线
    //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

    //绘制齿位线
    if (step == 6) {
      int tooth = keydata["toothSA"].length;
      if (keydata["loact"] == 0) {
      } else {
        //对头
        tooth = keydata["toothSA"].length;
        //尾部齿位
        if ((touchoffset.dy - (dY + keydata["toothSA"][0] / zoom)).abs() < 20) {
          baseKey.seleindex = 1;
          if (touchoffset.dy - (dY + keydata["toothSA"][0] / zoom) > 0) {
            keydata["toothSA"][0] = (keydata["toothSA"][0] +
                    (touchoffset.dy - (dY + keydata["toothSA"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][0] = (keydata["toothSA"][0] -
                    (touchoffset.dy - (dY + keydata["toothSA"][0] / zoom).abs())
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
        if ((touchoffset.dy - (dY + keydata["toothSA"][tooth - 1] / zoom))
                .abs() <
            20) {
          baseKey.seleindex = tooth;
          if (touchoffset.dy - (dY + keydata["toothSA"][tooth - 1] / zoom) >
              0) {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] +
                    (touchoffset.dy -
                                (dY + keydata["toothSA"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothSA"][tooth - 1] = (keydata["toothSA"][tooth - 1] -
                    (touchoffset.dy -
                                (dY + keydata["toothSA"][tooth - 1] / zoom)
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
            if (((touchoffset.dy - (dY + keydata["toothSA"][tooth - 1] / zoom))
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
            if (((touchoffset.dy - (dY + keydata["toothSA"][0] / zoom)).abs() <
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
          canvas.drawLine(Offset(dX - 20, dY + keydata["toothSA"][i] / zoom),
              Offset(eX + 20, dY + keydata["toothSA"][i] / zoom), paintcut);
          _showtext(
              canvas,
              keydata["toothSA"][i].toString(),
              Offset(dX - 40, dY + keydata["toothSA"][i] / zoom),
              10,
              Colors.blue);
        }

        //print(keydata["toothSA"]);
        // Color seleColor = Colors.green;
        // if ((touchoffset.dy - (dY + keydata["toothSA"][0] / zoom)).abs() < 10) {
        //   baseKey.seleindex = 0;
        // } else {
        //   baseKey.seleindex = 1;
        // }
        // for (var i = 0; i < tooth; i++) {
        //   if ((baseKey.seleindex == 0 && i == 0) ||
        //       baseKey.seleindex == 1 && i == tooth - 1) {
        //     seleColor = Colors.green;
        //   } else {
        //     seleColor = Colors.red;
        //   }
        //   canvas.drawPoints(

        //       ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
        //       PointMode.polygon, //首尾相连
        //       //PointMode.lines, //两两相连
        //       //PointMode.points,//画点
        //       [
        //         Offset(dX - 20, dY + keydata["toothSA"][i] / zoom),
        //         Offset(eX + 20, dY + keydata["toothSA"][i] / zoom)
        //       ],
        //       paintline..color = seleColor);
        //   _showtext(
        //       canvas,
        //       keydata["toothSA"][i].toString(),
        //       Offset(dX - 40, dY + keydata["toothSA"][i] / zoom),
        //       10,
        //       Colors.blue);
        // }
      }
    }
    //绘制齿深线
    if (step == 7) {
      int tooth = keydata["toothDepth"].length;

      //对头
      tooth = keydata["toothDepth"].length;

      if (keydata["side"] == 0) {
        //最右边边齿深线
        if ((touchoffset.dx - (cX + keydata["toothDepth"][0] / zoom)).abs() <
            10) {
          baseKey.seleindex = 1;
          if (touchoffset.dx - (cX + keydata["toothDepth"][0] / zoom) > 0) {
            keydata["toothDepth"][0] = (keydata["toothDepth"][0] +
                    (touchoffset.dx -
                                (cX + keydata["toothDepth"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothDepth"][0] = (keydata["toothDepth"][0] -
                    (touchoffset.dx -
                                (cX + keydata["toothDepth"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }

          if (keydata["toothDepth"][0] <= keydata["toothDepth"][tooth - 1]) {
            keydata["toothDepth"][0] = keydata["toothDepth"][tooth - 1] + 50;
          }
        }
        //最左边齿位
        if ((touchoffset.dx - (cX + keydata["toothDepth"][tooth - 1] / zoom))
                .abs() <
            10) {
          baseKey.seleindex = tooth;
          if (touchoffset.dx - (cX + keydata["toothDepth"][tooth - 1] / zoom) >
              0) {
            keydata["toothDepth"][tooth - 1] = (keydata["toothDepth"]
                        [tooth - 1] +
                    (touchoffset.dx -
                                (cX + keydata["toothDepth"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothDepth"][tooth - 1] = (keydata["toothDepth"]
                        [tooth - 1] -
                    (touchoffset.dx -
                                (cX + keydata["toothDepth"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
          if (keydata["toothDepth"][0] <= keydata["toothDepth"][tooth - 1]) {
            keydata["toothDepth"][0] = keydata["toothDepth"][tooth - 1] + 50;
          }
        }
        for (var i = 0; i < tooth; i++) {
          if (i == 0 || i == tooth - 1) {
            paintcut.color = Colors.red;
            if (((touchoffset.dy -
                            (cX + keydata["toothDepth"][tooth - 1] / zoom))
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
            if (((touchoffset.dx - (cY + keydata["toothDepth"][0] / zoom))
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
          canvas.drawLine(Offset(cX + keydata["toothDepth"][i] / zoom, dY - 20),
              Offset(cX + keydata["toothDepth"][i] / zoom, aY + 20), paintcut);
          _showtext(
              canvas,
              keydata["toothDepthName"][i],
              Offset(cX + keydata["toothDepth"][i] / zoom, dY - 20),
              10,
              Colors.blue);
          _showtext(
              canvas,
              "${keydata["toothDepthName"][i]}:${keydata["toothDepth"][i]}",
              Offset(cX - 50, dY + 20 * i),
              10,
              Colors.red);
        }
      } else {
        // B边齿位
        if ((touchoffset.dx - (fX - keydata["toothDepth"][0] / zoom)).abs() <
            10) {
          baseKey.seleindex = 1;
          if (touchoffset.dx - (fX - keydata["toothDepth"][0] / zoom) > 0) {
            keydata["toothDepth"][0] = (keydata["toothDepth"][0] -
                    (touchoffset.dx -
                                (fX - keydata["toothDepth"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothDepth"][0] = (keydata["toothDepth"][0] +
                    (touchoffset.dx -
                                (fX - keydata["toothDepth"][0] / zoom).abs())
                            .abs() *
                        zoom)
                .toInt();
          }

          if (keydata["toothDepth"][0] <= keydata["toothDepth"][tooth - 1]) {
            keydata["toothDepth"][0] = keydata["toothDepth"][tooth - 1] + 50;
          }
        }
        //最左边齿位
        if ((touchoffset.dx - (fX - keydata["toothDepth"][tooth - 1] / zoom))
                .abs() <
            10) {
          baseKey.seleindex = tooth;
          if (touchoffset.dx - (fX - keydata["toothDepth"][tooth - 1] / zoom) >
              0) {
            keydata["toothDepth"][tooth - 1] = (keydata["toothDepth"]
                        [tooth - 1] -
                    (touchoffset.dx -
                                (fX - keydata["toothDepth"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          } else {
            keydata["toothDepth"][tooth - 1] = (keydata["toothDepth"]
                        [tooth - 1] +
                    (touchoffset.dx -
                                (fX - keydata["toothDepth"][tooth - 1] / zoom)
                                    .abs())
                            .abs() *
                        zoom)
                .toInt();
          }
          //  keydata["toothSA"][tooth - 1] = keydata["toothSA"][tooth - 1] + cutsindeX;
          if (keydata["toothDepth"][0] <= keydata["toothDepth"][tooth - 1]) {
            keydata["toothDepth"][0] = keydata["toothDepth"][tooth - 1] + 50;
          }
        }
        for (var i = 0; i < tooth; i++) {
          if (i == 0 || i == tooth - 1) {
            paintcut.color = Colors.red;
            if (((touchoffset.dy -
                            (fX - keydata["toothDepth"][tooth - 1] / zoom))
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
            if (((touchoffset.dx - (fX - keydata["toothDepth"][0] / zoom))
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
          canvas.drawLine(Offset(fX - keydata["toothDepth"][i] / zoom, dY - 20),
              Offset(fX - keydata["toothDepth"][i] / zoom, aY + 20), paintcut);
          _showtext(
              canvas,
              keydata["toothDepthName"][i],
              Offset(fX - keydata["toothDepth"][i] / zoom, dY - 20),
              10,
              Colors.blue);
          _showtext(
              canvas,
              "${keydata["toothDepthName"][i]}:${keydata["toothDepth"][i]}",
              Offset(cX - 50, dY + 20 * i),
              10,
              Colors.red);
        }
      }
    }
  }

//立铣内沟双边

  void drawSB2key(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+
    ---------------------------
    */
    //Color frontcolor = Colors.blue;
    //double length;
    int tooth = keydata["toothSA"].length;
    List<Offset> post = [];
    // List<Offset> post2 = [];
    Rect rect;
    if (keydata["locat"] == 0) {
      // length = keydata["toothSA"][tooth - 1] / zoom +
      //     keydata["wide"] / zoom / 2 +
      //     20; //有一个尖头
      double cX = (_wide - keydata["wide"] / zoom) / 2;
      double cY = (_hight - keydata["toothSA"][tooth - 1] / zoom) / 2 +
          keydata["toothSA"][tooth - 1] / zoom;
      double bX = (_wide - 1000 / zoom) / 2;
      double bY = cY;
      double aX = bX;
      double aY = bY + 20;
      double dX = cX;
      double dY = cY - keydata["toothSA"][tooth - 1] / zoom - 20;
      // double eX = _wide / 2;
      double eY = dY - 30;
      double fX = cX + keydata["wide"] / zoom;
      double fY = dY;
      double gX = fX;
      double gY = cY;
      double hX = bX + 1000 / zoom;
      double hY = gY;
      double iX = hX;
      double iY = aY;
//生成齿号
/*
      int j = 0;
      for (var i = 0; i < tooth; i++) {
        //effectivetouch
        //先确定X坐标
        // ////print(headY + keydata["toothSA"][i] / zoom);
        if (cY - keydata["toothSA"][i] / zoom - effectivetouch <
                touchoffset.dy &&
            touchoffset.dy <
                cY - keydata["toothSA"][i] / zoom + effectivetouch) {
          for (j = 0; j < baseKey.toothDepth.length; j++) {
            //判断A边区域
            if (touchoffset.dx >
                    gX - keydata["toothDepth"][j] / zoom - effectivetouch &&
                touchoffset.dx <
                    gX - keydata["toothDepth"][j] / zoom + effectivetouch) {
              debugPrint("捕捉到齿位:$i");
              // baseKey.ahNum[i] = keydata["toothDepth"][j];
              //baseKey.ahNums[i] = baseKey.toothDepthName[j];
              baseKey.bhNum[i] = keydata["toothDepth"][j];
              baseKey.bhNums[i] = baseKey.toothDepthName[j];
              break;
            }
            //判断B边的区域
            if (touchoffset.dx >
                    cX + keydata["toothDepth"][j] / zoom - effectivetouch &&
                touchoffset.dx <
                    cX + keydata["toothDepth"][j] / zoom + effectivetouch) {
              baseKey.ahNum[i] = keydata["toothDepth"][j];
              baseKey.ahNums[i] = baseKey.toothDepthName[j];
              //baseKey.bhNum[i] = keydata["toothDepth"][j];
              // baseKey.bhNums[i] = baseKey.toothDepthName[j];
              break;
            }
          }
          ////print(j);
          // if (j == baseKey.toothDepth.length) //没有找到位置启用第二套方案
          // {
          //   if (touchoffset.dx >
          //           gX -
          //               baseKey.toothDepth
          //                       [baseKey.toothDepth.length - 1] /
          //                   zoom +
          //               effectivetouch &&
          //       touchoffset.dx <
          //           cX +
          //               baseKey.toothDepth
          //                       [baseKey.toothDepth.length - 1] /
          //                   zoom -
          //               effectivetouch) {
          //     int currentindeX = baseKey.toothDepth.indeXOf(baseKey.ahNum[i]);
          //     ////print(baseKey.ahNum[i]);
          //     ////print(baseKey.toothDepth.length);
          //     ////print(currentindeX);
          //     int Depthlength = baseKey.toothDepth.length - 1;
          //     if (currentindeX < Depthlength) {
          //       currentindeX = currentindeX + 1;
          //     }
          //     ////print(currentindeX);
          //     baseKey.ahNum[i] = keydata["toothDepth"][currentindeX];
          //     baseKey.ahNums[i] = baseKey.toothDepthName[currentindeX];
          //     baseKey.bhNum[i] = keydata["toothDepth"][currentindeX];
          //     baseKey.bhNums[i] = baseKey.toothDepthName[currentindeX];
          //   }

          //   if (touchoffset.dx <
          //           gX - keydata["toothDepth"][0] / zoom - effectivetouch ||
          //       touchoffset.dx >
          //           cX + keydata["toothDepth"][0] / zoom + effectivetouch) {
          //     int currentindeX = baseKey.toothDepth.indeXOf(baseKey.ahNum[i]);
          //     ////print(baseKey.ahNum[i]);
          //     ////print(baseKey.toothDepth.length);
          //     ////print(currentindeX);
          //     int Depthlength = baseKey.toothDepth.length - 1;
          //     if (currentindeX > 0) {
          //       currentindeX = currentindeX - 1;
          //     }
          //     ////print(currentindeX);
          //     baseKey.ahNum[i] = keydata["toothDepth"][currentindeX];
          //     baseKey.ahNums[i] = baseKey.toothDepthName[currentindeX];
          //     baseKey.bhNum[i] = keydata["toothDepth"][currentindeX];
          //     baseKey.bhNums[i] = baseKey.toothDepthName[currentindeX];
          //   }
          // }
        }
      }*/

      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀
      post.add(Offset(aX, aY));
      post.add(Offset(bX, bY));
      post.add(Offset(cX, cY));
      post.add(Offset(dX, dY));

      for (var i = tooth - 1; i >= 0; i--) {
        post.add(Offset(cX + baseKey.ahNum[i] / zoom,
            cY - keydata["toothSA"][i] / zoom - 2));
        post.add(Offset(cX + baseKey.ahNum[i] / zoom,
            cY - keydata["toothSA"][i] / zoom + 2));
      }
      post.add(Offset((cX + gX) / 2, cY));
      for (var i = 0; i < tooth; i++) {
        post.add(Offset(gX - baseKey.bhNum[i] / zoom,
            gY - keydata["toothSA"][i] / zoom + 2));
        post.add(Offset(gX - baseKey.bhNum[i] / zoom,
            gY - keydata["toothSA"][i] / zoom - 2));
      }

      post.add(Offset(fX, fY));
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

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      //绘制B面的齿深线

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(gX - keydata["toothDepth"][i] / zoom, aY),
              Offset(gX - keydata["toothDepth"][i] / zoom, eY),
            ],
            paintcut..color = Colors.red);

        //   //绘制上面的齿深线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(cX + keydata["toothDepth"][i] / zoom, aY),
              Offset(cX + keydata["toothDepth"][i] / zoom, eY),
            ],
            paintcut..color = Colors.red);
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(gX - keydata["toothDepth"][i] / zoom, eY - 6),
            10,
            Colors.blue);
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(cX + keydata["toothDepth"][i] / zoom, eY - 6),
            10,
            Colors.blue);
        canvas.drawLine(Offset(bX - 20, bY), Offset(hX + 20, hY), paintcut);
      }

      for (var i = 0; i < tooth; i++) {
        // if (i == cutsindeX) {
        //   frontcolor = Colors.red;
        // } else {
        //   frontcolor = Colors.blue;
        // }
        //   frontcolor = Colors.blue;
        // _showtext(
        //     canvas,
        //     baseKey.ahNums[i],
        //     Offset(headX - keydata["toothSA"][i] / zoom - 9, endY - 18),
        //     18,
        //     frontcolor);
        // _showtext(
        //     canvas,
        //     baseKey.ahNums[i],
        //     Offset(headX - keydata["toothSA"][i] / zoom - 9, beginy + 18),
        //     18,
        //     frontcolor);
        //画齿深远点
        if (step == i) {
          paintline.color = Colors.green;
        } else {
          paintline.color = Colors.blue;
        }
        rect = Rect.fromCircle(
            center: Offset(gX - baseKey.bhNum[i] / zoom,
                gY - keydata["toothSA"][i] / zoom),
            radius: 2.0);
        canvas.drawArc(rect, 0, 360, false, paintline);
        rect = Rect.fromCircle(
            center: Offset(cX + baseKey.ahNum[i] / zoom,
                cY - keydata["toothSA"][i] / zoom),
            radius: 2.0);
        canvas.drawArc(rect, 0, 360, false, paintline);
      }
    } else {
      //对头类钥匙画法
      double cX = (_wide - keydata["wide"] / zoom) / 2;
      double cY = (_hight - keydata["toothSA"][0] / zoom) / 2 +
          keydata["toothSA"][0] / zoom;
      // double bX = (_wide - 1000 / zoom) / 2;
      //double bY = cY;
      //double aX = bX;
      // double aY = bY + 20;
      double dX = cX;
      double dY = cY - keydata["toothSA"][0] / zoom - 20;
      //  double eX = _wide / 2;
      double eY = dY;
      double fX = cX + keydata["wide"] / zoom;
      double fY = dY;
      double gX = fX;
      double gY = cY;
      // double hX = bX + 1000 / zoom;
      //double hY = gY;
      //double iX = hX;
      //double iY = aY;

      // length = keydata["toothSA"][tooth - 1] / zoom; //
      // double beginx = 50;
      // double beginy = 140; //代表肩膀宽度为1000丝
      // length =
      //     keydata["toothSA"][0] / zoom + keydata["wide"] / zoom / 2; //有一个尖头

      //判断触摸的位置是否在有效区域
      //判断方法 计算每个齿的的有效区域并判断是否在这个范围内
      debugPrint("触摸位置");
      ////print(touchoffset);
      debugPrint("起始位置");

      int j = 0;
      for (var i = 0; i < tooth; i++) {
        //effectivetouch
        //先确定X坐标
        // ////print(headY + keydata["toothSA"][i] / zoom);
        if (eY + keydata["toothSA"][i] / zoom - effectivetouch <
                touchoffset.dy &&
            touchoffset.dy <
                eY + keydata["toothSA"][i] / zoom + effectivetouch) {
          for (j = 0; j < baseKey.toothDepth.length; j++) {
            //判断A边区域
            if (touchoffset.dx >
                    gX - keydata["toothDepth"][j] / zoom - effectivetouch &&
                touchoffset.dx <
                    gX - keydata["toothDepth"][j] / zoom + effectivetouch) {
              debugPrint("捕捉到齿位:$i");
              baseKey.ahNum[i] = keydata["toothDepth"][j];
              baseKey.ahNums[i] = baseKey.toothDepthName[j];
              // baseKey.bhNum[i] = keydata["toothDepth"][j];
              // baseKey.bhNums[i] = baseKey.toothDepthName[j];
              break;
            }
            //判断B边的区域
            if (touchoffset.dx >
                    cX + keydata["toothDepth"][j] / zoom - effectivetouch &&
                touchoffset.dx <
                    cX + keydata["toothDepth"][j] / zoom + effectivetouch) {
              // baseKey.ahNum[i] = keydata["toothDepth"][j];
              //  baseKey.ahNums[i] = baseKey.toothDepthName[j];
              baseKey.bhNum[i] = keydata["toothDepth"][j];
              baseKey.bhNums[i] = baseKey.toothDepthName[j];
              break;
            }
          }
          ////print(j);
/*
          if (j == baseKey.toothDepth.length) //没有找到位置启用第二套方案
          {
            if (touchoffset.dx >
                    gX -
                        baseKey.toothDepth
                                [baseKey.toothDepth.length - 1] /
                            zoom +
                        effectivetouch &&
                touchoffset.dx <
                    cX +
                        baseKey.toothDepth
                                [baseKey.toothDepth.length - 1] /
                            zoom -
                        effectivetouch) {
              int currentindeX = baseKey.toothDepth.indeXOf(baseKey.ahNum[i]);
              ////print(baseKey.ahNum[i]);
              ////print(baseKey.toothDepth.length);
              ////print(currentindeX);
              int Depthlength = baseKey.toothDepth.length - 1;
              if (currentindeX < Depthlength) {
                currentindeX = currentindeX + 1;
              }
              ////print(currentindeX);
              baseKey.ahNum[i] = keydata["toothDepth"][currentindeX];
              baseKey.ahNums[i] = baseKey.toothDepthName[currentindeX];
              baseKey.bhNum[i] = keydata["toothDepth"][currentindeX];
              baseKey.bhNums[i] = baseKey.toothDepthName[currentindeX];
            }

            if (touchoffset.dx <
                    gX - keydata["toothDepth"][0] / zoom - effectivetouch ||
                touchoffset.dx >
                    cX + keydata["toothDepth"][0] / zoom + effectivetouch) {
              int currentindeX = baseKey.toothDepth.indeXOf(baseKey.ahNum[i]);
              ////print(baseKey.ahNum[i]);
              ////print(baseKey.toothDepth.length);
              ////print(currentindeX);
              int Depthlength = baseKey.toothDepth.length - 1;
              if (currentindeX > 0) {
                currentindeX = currentindeX - 1;
              }
              ////print(currentindeX);
              baseKey.ahNum[i] = keydata["toothDepth"][currentindeX];
              baseKey.ahNums[i] = baseKey.toothDepthName[currentindeX];
              baseKey.bhNum[i] = keydata["toothDepth"][currentindeX];
              baseKey.bhNums[i] = baseKey.toothDepthName[currentindeX];
            }
          }*/
        }
      }

      //根据齿号生成轨迹

      post.add(Offset(cX, cY));
      post.add(Offset(dX, dY));
      //先画左边
      for (var i = tooth - 1; i >= 0; i--) {
        post.add(Offset(cX + baseKey.bhNum[i] / zoom,
            eY + keydata["toothSA"][i] / zoom - 2));
        post.add(Offset(cX + baseKey.bhNum[i] / zoom,
            eY + keydata["toothSA"][i] / zoom + 2));
      }
      post.add(Offset((gX + cX) / 2, cY));
      for (var i = 0; i < tooth; i++) {
        post.add(Offset(gX - baseKey.ahNum[i] / zoom,
            eY + keydata["toothSA"][i] / zoom + 2));
        post.add(Offset(gX - baseKey.ahNum[i] / zoom,
            eY + keydata["toothSA"][i] / zoom - 2));
      }

      post.add(Offset(fX, fY));
      post.add(Offset(gX, gY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = Colors.blue);

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      //绘制下面的齿深线

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(gX - keydata["toothDepth"][i] / zoom, cY),
              Offset(gX - keydata["toothDepth"][i] / zoom, eY),
            ],
            paintcut..color = Colors.red);

        //   //绘制上面的齿深线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(cX + keydata["toothDepth"][i] / zoom, cY),
              Offset(cX + keydata["toothDepth"][i] / zoom, eY),
            ],
            paintcut..color = Colors.red);
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(gX - keydata["toothDepth"][i] / zoom, eY - 6),
            10,
            Colors.blue);
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(cX + keydata["toothDepth"][i] / zoom, eY - 6),
            10,
            Colors.blue);
      }

      for (var i = 0; i < tooth; i++) {
        // if (i == cutsindeX) {
        //   frontcolor = Colors.red;
        // } else {
        //   frontcolor = Colors.blue;
        // }
        // frontcolor = Colors.blue;
        // _showtext(
        //     canvas,
        //     baseKey.ahNums[i],
        //     Offset(headX - keydata["toothSA"][i] / zoom - 9, endY - 18),
        //     18,
        //     frontcolor);
        // _showtext(
        //     canvas,
        //     baseKey.ahNums[i],
        //     Offset(headX - keydata["toothSA"][i] / zoom - 9, beginy + 18),
        //     18,
        //     frontcolor);
        //画齿深远点
        rect = Rect.fromCircle(
            center: Offset(gX - baseKey.ahNum[i] / zoom,
                eY + keydata["toothSA"][i] / zoom),
            radius: 2.0);
        canvas.drawArc(rect, 0, 360, false, paintline);
        rect = Rect.fromCircle(
            center: Offset(cX + baseKey.bhNum[i] / zoom,
                eY + keydata["toothSA"][i] / zoom),
            radius: 2.0);
        canvas.drawArc(rect, 0, 360, false, paintline);
      }
//画定位线
      canvas.drawLine(Offset(cX - 5, eY), Offset(fX + 5, eY), paintcut);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // debugPrint("画布高度");
    // ////print(size.height);
    // debugPrint("画布宽度");
    // ////print(size.width);
    _wide = size.width;
    _hight = size.height;
    // baseKey.ahNum[0] = 819;
    // baseKey.keyClass = 4;
    ////print(keydata);
    switch (keydata["class"]) {
      case 0: //平铣双边
        //   debugPrint("平铣双边");
        drawSB0key(canvas);
        break;
      case 1: //平铣单边
        drawSB3key(canvas);
        break;
      case 2: //立铣内沟双边
        // debugPrint("立铣内沟双边");
        drawSB2key(canvas);
        break;
      case 3: //立铣外沟单边
        drawSB3key(canvas);
        break;
      case 4: //立铣外沟双边
        drawSB4key(canvas);
        break;
      case 5: //立铣内沟单边
        drawSB5key(canvas);
        break;
      case 6:
        break;
      case 7:
        break;
      case 8:
        break;
    }
  }

  void getcolors(Offset offset) {}
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
