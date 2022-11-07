import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
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

class CamerPainter extends CustomPainter {
  //Map keydata;
  int zoom = 7; //缩放倍数
  late double _wide;
  late double _hight;
  Color toothDepthColor = const Color(0xff4caf50);
  Color toothSAColor = const Color(0x64ff9800);
  //List<int> baseKey.ahNum;
  //List<int> baseKey.bhNum;
  //List<String> sbaseKey.ahNum;
  //List<String> sbaseKey.bhNum;
  double effectivetouch = 5; //定义有效触摸区域 +/-
  Offset touchoffset;
  int seletooth;
  int seleaxis;
  int seleahnum;
  CamerPainter(this.touchoffset, this.seletooth, this.seleaxis, this.seleahnum);

  Paint paintline = Paint()
    ..color = const Color(0xff384c70) //画笔颜色
    ..strokeCap = StrokeCap.round //画笔笔触类型
    ..isAntiAlias = true //是否启动抗锯齿
    ..style = PaintingStyle.fill
    ..strokeWidth = 1.0; //画笔的宽度
  //齿深线画笔
  Paint paintcut = Paint()
    ..color = Colors.red //画笔颜色
    ..strokeCap = StrokeCap.round //画笔笔触类型
    ..isAntiAlias = true //是否启动抗锯齿
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.5; //画笔的宽度
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
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+
    ---------------------------
    */
    // Color frontcolor = const Color(0xff384c70);
    // double length;
    int tooth = baseKey.toothSA.length;
    List<Offset> post = [];
    //List<Offset> post2 = [];
    Rect rect;

    if (baseKey.locat == 0) {
      // length = baseKey.toothSA[tooth - 1] / zoom +
      //     baseKey.wide / zoom / 2 +
      //     20; //有一个尖头
      double cX = (_wide - baseKey.wide / zoom) / 2;
      double cY = (_hight - baseKey.toothSA[tooth - 1] / zoom) / 2 +
          baseKey.toothSA[tooth - 1] / zoom;
      double bX = cX - (_wide / zoom) / 2;
      double bY = cY;

      double dX = cX;
      double dY = cY -
          baseKey.toothSA[tooth - 1] / zoom -
          (baseKey.toothSA[0] - baseKey.toothSA[1]).abs() / zoom -
          20;

      double eY = dY;
      double gX = cX + baseKey.wide / zoom;
      double gY = dY;
      double fX = gX + (_wide / zoom) / 2;

      double hX = gX;
      double hY = cY;
      double iX = fX;
      double iY = cY;

      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀

      post.add(Offset(cX, cY));
      post.add(Offset(dX, dY));
      post.add(Offset(gX, gY));
      post.add(Offset(hX, hY));
      post.add(Offset(cX, cY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      //绘制B面的齿深线

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        //   //绘制上面的齿深线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(cX + baseKey.toothDepth[i] / zoom, cY),
              Offset(cX + baseKey.toothDepth[i] / zoom, dY),
            ],
            paintcut..color = toothDepthColor);

        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(hX - baseKey.toothDepth[i] / zoom, cY),
              Offset(hX - baseKey.toothDepth[i] / zoom, dY),
            ],
            paintcut..color = toothDepthColor);

        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(cX + baseKey.toothDepth[i] / zoom, eY - 10),
            10,
            const Color(0xff384c70));

        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(hX - baseKey.toothDepth[i] / zoom, eY - 10),
            10,
            const Color(0xff384c70));
      }

      for (var i = 0; i < tooth; i++) {
        //画齿深远点

        if (seletooth == i) {
          paintline.color = Colors.red;
        } else {
          paintline.color = const Color(0xff384c70);
        }

        rect = Rect.fromCircle(
            center: Offset(
                cX + baseKey.ahNum[i] / zoom, cY - baseKey.toothSA[i] / zoom),
            radius: 4.0);
        canvas.drawArc(rect, 0, 360, false, paintline);

        rect = Rect.fromCircle(
            center: Offset(
                hX - baseKey.ahNum[i] / zoom, cY - baseKey.toothSA[i] / zoom),
            radius: 4.0);
        canvas.drawArc(rect, 0, 360, false, paintline);
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(dX, cY - baseKey.toothSA[i] / zoom),
              Offset(gX, cY - baseKey.toothSA[i] / zoom),
            ],
            paintcut..color = toothSAColor);
      }
      paintcut.color = Colors.red;
      _showtext(
          canvas, "肩部定位", Offset(bX - 20, bY + 5), 10, const Color(0xff384c70));
      paintcut.strokeWidth = 2.0;
      canvas.drawLine(Offset(bX, bY), Offset(iX, iY), paintcut);
      paintcut.strokeWidth = 0.5;
      // canvas.drawLine(Offset(bX - 20, bY), Offset(hX + 20, hY), paintcut);
    } else {
      //对头类钥匙画法
      double cX = (_wide - baseKey.wide / zoom) / 2;
      double cY =
          (_hight - baseKey.toothSA[0] / zoom) / 2 + baseKey.toothSA[0] / zoom;
      double bX = cX - 20;

      //double aX = bX;
      // double aY = bY + 20;
      double dX = cX;
      double dY = cY -
          baseKey.toothSA[0] / zoom -
          (baseKey.toothSA[0] - baseKey.toothSA[1]).abs() / zoom -
          20;
      double eX = bX;
      double eY = dY;
      double gX = cX + baseKey.wide / zoom;
      double gY = dY;
      double fX = gX + 20;

      double hX = gX;
      double hY = cY;

      //根据齿号生成轨迹

      post.add(Offset(cX, cY));
      post.add(Offset(dX, dY));

      post.add(Offset(gX, gY));

      post.add(Offset(hX, hY));

      post.add(Offset(cX, cY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));

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
              Offset(gX - baseKey.toothDepth[i] / zoom, cY),
              Offset(gX - baseKey.toothDepth[i] / zoom, eY),
            ],
            paintcut..color = toothDepthColor);

        //   //绘制上面的齿深线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(cX + baseKey.toothDepth[i] / zoom, cY),
              Offset(cX + baseKey.toothDepth[i] / zoom, eY),
            ],
            paintcut..color = toothDepthColor);
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(cX + baseKey.toothDepth[i] / zoom, eY - 10),
            10,
            const Color(0xff384c70));
      }

      for (var i = 0; i < tooth; i++) {
        //画齿深远点
        if (seletooth == i) {
          // print(seletooth);
          paintline.color = Colors.red;
        } else {
          paintline.color = const Color(0xff384c70);
        }
        rect = Rect.fromCircle(
            center: Offset(
                gX - baseKey.ahNum[i] / zoom, dY + baseKey.toothSA[i] / zoom),
            radius: 4.0);

        canvas.drawArc(rect, 0, 360, false, paintline);
        rect = Rect.fromCircle(
            center: Offset(
                cX + baseKey.bhNum[i] / zoom, dY + baseKey.toothSA[i] / zoom),
            radius: 4.0);
        canvas.drawArc(rect, 0, 360, false, paintline);

        //画齿位线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(dX, dY + baseKey.toothSA[i] / zoom),
              Offset(gX, dY + baseKey.toothSA[i] / zoom),
            ],
            paintcut..color = toothSAColor);
      }

//画定位线
      paintcut.color = Colors.red;

      _showtext(
          canvas, "头部定位", Offset(eX - 20, eY + 5), 10, const Color(0xff384c70));
      paintcut.strokeWidth = 2.0;
      canvas.drawLine(Offset(eX, eY), Offset(fX, eY), paintcut);
      paintcut.strokeWidth = 0.5;
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
    // Color frontcolor = const Color(0xff384c70);
    // double length;
    int tooth = baseKey.toothSA.length;
    List<Offset> post = [];
    //List<Offset> post2 = [];
    Rect rect;

    if (baseKey.locat == 0) {
      // length = baseKey.toothSA[tooth - 1] / zoom +
      //     baseKey.wide / zoom / 2 +
      //     20; //有一个尖头
      double cX = (_wide - baseKey.wide / zoom) / 2;
      double cY = (_hight - baseKey.toothSA[tooth - 1] / zoom) / 2 +
          baseKey.toothSA[tooth - 1] / zoom;
      double bX = cX - (_wide / zoom) / 2;
      double bY = cY;
      //double aX = bX;
      // double aY = bY + 20;
      double dX = cX;
      double dY = cY -
          baseKey.toothSA[tooth - 1] / zoom -
          (baseKey.toothSA[0] - baseKey.toothSA[1]).abs() / zoom -
          20;

      double eY = dY;
      double gX = cX + baseKey.wide / zoom;
      double gY = dY;
      double fX = gX + (_wide / zoom) / 2;

      double hX = gX;
      double hY = cY;
      double iX = fX;
      double iY = cY;

      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀

      post.add(Offset(cX, cY));
      post.add(Offset(dX, dY));
      post.add(Offset(gX, gY));
      post.add(Offset(hX, hY));
      post.add(Offset(cX, cY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        if (seleaxis == 1) {
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(gX - baseKey.toothDepth[i] / zoom, eY - 10),
              10,
              const Color(0xff384c70));
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(gX - baseKey.toothDepth[i] / zoom, cY),
                Offset(gX - baseKey.toothDepth[i] / zoom, eY),
              ],
              paintcut..color = toothDepthColor);
        }
        //   //绘制上面的齿深线
        else {
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(cX + baseKey.toothDepth[i] / zoom, cY),
                Offset(cX + baseKey.toothDepth[i] / zoom, eY),
              ],
              paintcut..color = toothDepthColor);
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(cX + baseKey.toothDepth[i] / zoom, eY - 10),
              10,
              const Color(0xff384c70));
        }
      }

      for (var i = 0; i < tooth; i++) {
        //画齿深远点
        if (seletooth == i) {
          // print(seletooth);
          paintline.color = Colors.red;
        } else {
          paintline.color = const Color(0xff384c70);
        }
        if (seleaxis == 0) {
          rect = Rect.fromCircle(
              center: Offset(
                  cX + baseKey.ahNum[i] / zoom, cY - baseKey.toothSB[i] / zoom),
              radius: 4.0);

          canvas.drawArc(rect, 0, 360, false, paintline);
        } else {
          rect = Rect.fromCircle(
              center: Offset(
                  gX - baseKey.bhNum[i] / zoom, cY - baseKey.toothSA[i] / zoom),
              radius: 4.0);
          canvas.drawArc(rect, 0, 360, false, paintline);

          //画齿位线

        }
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(dX, dY + baseKey.toothSA[i] / zoom),
              Offset(gX, dY + baseKey.toothSA[i] / zoom),
            ],
            paintcut..color = toothSAColor);
      }
      paintcut.color = Colors.red;
      _showtext(
          canvas, "肩部定位", Offset(bX - 20, bY + 5), 10, const Color(0xff384c70));
      paintcut.strokeWidth = 2.0;
      canvas.drawLine(Offset(bX, bY), Offset(iX, iY), paintcut);
      paintcut.strokeWidth = 0.5;
    } else {
      //对头类钥匙画法
      double cX = (_wide - baseKey.wide / zoom) / 2;
      double cY =
          (_hight - baseKey.toothSA[0] / zoom) / 2 + baseKey.toothSA[0] / zoom;
      double bX = cX - (_wide / zoom) / 2;

      //double aX = bX;
      // double aY = bY + 20;
      double dX = cX;
      double dY = cY -
          baseKey.toothSA[0] / zoom -
          (baseKey.toothSA[0] - baseKey.toothSA[1]).abs() / zoom -
          20;
      double eX = bX;
      double eY = dY;
      double gX = cX + baseKey.wide / zoom;
      double gY = dY;
      double fX = gX + (_wide / zoom) / 2;
      double fY = dY;
      double hX = gX;
      double hY = cY;

      //根据齿号生成轨迹

      post.add(Offset(cX, cY));
      post.add(Offset(dX, dY));
      post.add(Offset(gX, gY));
      post.add(Offset(hX, hY));
      // post.add(Offset(iX, iY));
      post.add(Offset(cX, cY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      //绘制下面的齿深线

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        if (seleaxis == 0) {
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(cX + baseKey.toothDepth[i] / zoom - 2.5, eY - 10),
              10,
              const Color(0xff384c70));
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(cX + baseKey.toothDepth[i] / zoom, cY),
                Offset(cX + baseKey.toothDepth[i] / zoom, eY),
              ],
              paintcut..color = toothDepthColor);
        }
        //   //绘制上面的齿深线
        else {
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(gX - baseKey.toothDepth[i] / zoom, cY),
                Offset(gX - baseKey.toothDepth[i] / zoom, eY),
              ],
              paintcut..color = toothDepthColor);
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(gX - baseKey.toothDepth[i] / zoom - 2.5, eY - 10),
              10,
              Colors.red);
        }
      }

      for (var i = 0; i < tooth; i++) {
        //画齿深远点
        if (seletooth == i) {
          // print(seletooth);
          paintline.color = Colors.red.shade700;
        } else {
          paintline.color = const Color(0xff384c70);
        }
        if (seleaxis == 0) {
          rect = Rect.fromCircle(
              center: Offset(
                  cX + baseKey.bhNum[i] / zoom, dY + baseKey.toothSB[i] / zoom),
              radius: 4.0);

          canvas.drawArc(rect, 0, 360, false, paintline);
        } else {
          rect = Rect.fromCircle(
              center: Offset(
                  gX - baseKey.ahNum[i] / zoom, dY + baseKey.toothSA[i] / zoom),
              radius: 4.0);
          canvas.drawArc(rect, 0, 360, false, paintline);

          //画齿位线

        }
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(dX, dY + baseKey.toothSA[i] / zoom),
              Offset(gX, dY + baseKey.toothSA[i] / zoom),
            ],
            paintcut..color = toothSAColor);
      }

//画定位线
      paintcut.color = Colors.red;
      _showtext(canvas, "头部定位", Offset(eX - 20, eY + 5), 10, Colors.red);
      paintcut.strokeWidth = 2.0;
      canvas.drawLine(Offset(eX, eY), Offset(fX, fY), paintcut);
      paintcut.strokeWidth = 0.5;
    }
  }

//立铣外沟单边
//平铣单边
//绘图平铣双边
  void drawSB3key(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+
    ---------------------------
    */
    // Color frontcolor = const Color(0xff384c70);
    // double length;
    int tooth = baseKey.toothSA.length;
    List<Offset> post = [];
    //List<Offset> post2 = [];
    Rect rect;

    if (baseKey.locat == 0) {
      // length = baseKey.toothSA[tooth - 1] / zoom +
      //     baseKey.wide / zoom / 2 +
      //     20; //有一个尖头
      double cX = (_wide - baseKey.wide / zoom) / 2;
      double cY = (_hight - baseKey.toothSA[tooth - 1] / zoom) / 2 +
          baseKey.toothSA[tooth - 1] / zoom;
      double bX = cX - (_wide / zoom) / 2;
      double bY = cY;
      //double aX = bX;
      // double aY = bY + 20;
      double dX = cX;
      double dY = cY -
          baseKey.toothSA[tooth - 1] / zoom -
          (baseKey.toothSA[0] - baseKey.toothSA[1]).abs() / zoom -
          20;

      double eY = dY;
      double gX = cX + baseKey.wide / zoom;
      double gY = dY;
      double fX = gX + (_wide / zoom) / 2;

      double hX = gX;
      double hY = cY;
      double iX = fX;
      double iY = cY;

      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀

      post.add(Offset(cX, cY));
      post.add(Offset(dX, dY));
      post.add(Offset(gX, gY));
      post.add(Offset(hX, hY));
      post.add(Offset(cX, cY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      //绘制B面的齿深线

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        //   //绘制上面的齿深线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(cX + baseKey.toothDepth[i] / zoom, cY),
              Offset(cX + baseKey.toothDepth[i] / zoom, dY),
            ],
            paintcut..color = toothDepthColor);

        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(cX + baseKey.toothDepth[i] / zoom, eY - 6),
            10,
            const Color(0xff384c70));
      }

      for (var i = 0; i < tooth; i++) {
        //画齿深远点
        if (seletooth == i) {
          paintline.color = Colors.red;
        } else {
          paintline.color = const Color(0xff384c70);
        }
        rect = Rect.fromCircle(
            center: Offset(
                cX + baseKey.ahNum[i] / zoom, cY - baseKey.toothSA[i] / zoom),
            radius: 4.0);
        canvas.drawArc(rect, 0, 360, false, paintline);
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(dX, cY - baseKey.toothSA[i] / zoom),
              Offset(gX, cY - baseKey.toothSA[i] / zoom),
            ],
            paintcut..color = toothSAColor);
      }
      paintcut.color = Colors.red;
      _showtext(
          canvas, "肩部定位", Offset(bX - 20, bY + 5), 10, const Color(0xff384c70));
      paintcut.strokeWidth = 2.0;
      canvas.drawLine(Offset(bX, bY), Offset(iX, iY), paintcut);
      paintcut.strokeWidth = 0.5;
    } else {
      //对头类钥匙画法
      double cX = (_wide - baseKey.wide / zoom) / 2;
      double cY =
          (_hight - baseKey.toothSA[0] / zoom) / 2 + baseKey.toothSA[0] / zoom;
      double bX = cX - (_wide / zoom) / 2;

      //double aX = bX;
      // double aY = bY + 20;
      double dX = cX;
      double dY = cY -
          baseKey.toothSA[0] / zoom -
          (baseKey.toothSA[0] - baseKey.toothSA[1]).abs() / zoom -
          20;
      double eX = bX;
      double eY = dY;
      double gX = cX + baseKey.wide / zoom;
      double gY = dY;
      double fX = gX + (_wide / zoom) / 2;
      double fY = dY;
      double hX = gX;
      double hY = cY;

      //根据齿号生成轨迹

      post.add(Offset(cX, cY));
      post.add(Offset(dX, dY));
      post.add(Offset(gX, gY));
      post.add(Offset(hX, hY));
      // post.add(Offset(iX, iY));
      post.add(Offset(cX, cY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      //绘制下面的齿深线

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        if (baseKey.side == 1) {
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(gX - baseKey.toothDepth[i] / zoom, eY - 10),
              10,
              const Color(0xff384c70));
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(gX - baseKey.toothDepth[i] / zoom, cY),
                Offset(gX - baseKey.toothDepth[i] / zoom, eY),
              ],
              paintcut..color = Colors.green);
        }
        //   //绘制上面的齿深线
        else {
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(cX + baseKey.toothDepth[i] / zoom, cY),
                Offset(cX + baseKey.toothDepth[i] / zoom, eY),
              ],
              paintcut..color = toothDepthColor);
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(cX + baseKey.toothDepth[i] / zoom, eY - 10),
              10,
              const Color(0xff384c70));

          if (baseKey.keySerNum == 260) {
            _showtext(
                canvas,
                baseKey.toothDepthName[i],
                Offset(gX - baseKey.toothDepth[i] / zoom, eY - 10),
                10,
                const Color(0xff384c70));
            canvas.drawPoints(

                ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
                PointMode.polygon, //首尾相连
                //PointMode.lines, //两两相连
                //PointMode.points,//画点
                [
                  Offset(gX - baseKey.toothDepth[i] / zoom, cY),
                  Offset(gX - baseKey.toothDepth[i] / zoom, eY),
                ],
                paintcut..color = Colors.green);
          }
        }
      }

      for (var i = 0; i < tooth; i++) {
        //画齿深远点
        if (seletooth == i) {
          // print(seletooth);
          paintline.color = Colors.red;
        } else {
          paintline.color = const Color(0xff384c70);
        }
        if (baseKey.side == 1) {
          rect = Rect.fromCircle(
              center: Offset(
                  gX - baseKey.ahNum[i] / zoom, dY + baseKey.toothSA[i] / zoom),
              radius: 4.0);

          canvas.drawArc(rect, 0, 360, false, paintline);
        } else {
          if (baseKey.keySerNum == 260) {
            if (i % 2 == 0) {
              rect = Rect.fromCircle(
                  center: Offset(cX + baseKey.bhNum[i] / zoom,
                      dY + baseKey.toothSA[i] / zoom),
                  radius: 4.0);
              canvas.drawArc(rect, 0, 360, false, paintline);
            } else {
              rect = Rect.fromCircle(
                  center: Offset(gX - baseKey.ahNum[i] / zoom,
                      dY + baseKey.toothSA[i] / zoom),
                  radius: 4.0);

              canvas.drawArc(rect, 0, 360, false, paintline);
            }
          } else {
            rect = Rect.fromCircle(
                center: Offset(cX + baseKey.bhNum[i] / zoom,
                    dY + baseKey.toothSA[i] / zoom),
                radius: 4.0);
            canvas.drawArc(rect, 0, 360, false, paintline);
          }
          //画齿位线

        }
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(dX, dY + baseKey.toothSA[i] / zoom),
              Offset(gX, dY + baseKey.toothSA[i] / zoom),
            ],
            paintcut..color = toothSAColor);
      }

//画定位线
      paintcut.color = Colors.red;
      _showtext(
          canvas, "头部定位", Offset(eX - 20, eY + 5), 10, const Color(0xff384c70));
      paintcut.strokeWidth = 2.0;
      canvas.drawLine(Offset(eX, eY), Offset(fX, fY), paintcut);
      paintcut.strokeWidth = 0.5;
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
    // Color frontcolor = const Color(0xff384c70);
    // double length;
    int tooth = baseKey.toothSA.length;
    List<Offset> post = [];
    //List<Offset> post2 = [];
    Rect rect;

    if (baseKey.locat == 0) {
      // length = baseKey.toothSA[tooth - 1] / zoom +
      //     baseKey.wide / zoom / 2 +
      //     20; //有一个尖头
      double cX = (_wide - baseKey.wide / zoom) / 2;
      double cY = (_hight - baseKey.toothSA[tooth - 1] / zoom) / 2 +
          baseKey.toothSA[tooth - 1] / zoom;
      double bX = cX - (_wide / zoom) / 2;
      double bY = cY;
      //double aX = bX;
      // double aY = bY + 20;
      double dX = cX;
      double dY = cY -
          baseKey.toothSA[tooth - 1] / zoom -
          (baseKey.toothSA[0] - baseKey.toothSA[1]).abs() / zoom -
          20;

      double eY = dY;
      double gX = cX + baseKey.wide / zoom;
      double gY = dY;
      double fX = gX + (_wide / zoom) / 2;

      double hX = gX;
      double hY = cY;
      double iX = fX;
      double iY = cY;

      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀

      post.add(Offset(cX, cY));
      post.add(Offset(dX, dY));
      post.add(Offset(gX, gY));
      post.add(Offset(hX, hY));
      post.add(Offset(cX, cY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      //绘制B面的齿深线

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        //   //绘制上面的齿深线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(cX + baseKey.toothDepth[i] / zoom, cY),
              Offset(cX + baseKey.toothDepth[i] / zoom, dY),
            ],
            paintcut..color = toothDepthColor);

        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(cX + baseKey.toothDepth[i] / zoom, eY - 6),
            10,
            const Color(0xff384c70));
      }

      for (var i = 0; i < tooth; i++) {
        //画齿深远点
        if (seletooth == i) {
          paintline.color = Colors.red;
        } else {
          paintline.color = const Color(0xff384c70);
        }
        rect = Rect.fromCircle(
            center: Offset(
                cX + baseKey.ahNum[i] / zoom, cY - baseKey.toothSA[i] / zoom),
            radius: 4.0);
        canvas.drawArc(rect, 0, 360, false, paintline);
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(dX, cY - baseKey.toothSA[i] / zoom),
              Offset(gX, cY - baseKey.toothSA[i] / zoom),
            ],
            paintcut..color = toothSAColor);
      }
      paintcut.color = Colors.red;
      _showtext(
          canvas, "肩部定位", Offset(bX - 20, bY + 5), 10, const Color(0xff384c70));
      paintcut.strokeWidth = 2.0;
      canvas.drawLine(Offset(bX, bY), Offset(iX, iY), paintcut);
      paintcut.strokeWidth = 0.5;
    } else {
      //对头类钥匙画法
      double cX = (_wide - baseKey.wide / zoom) / 2;
      double cY =
          (_hight - baseKey.toothSA[0] / zoom) / 2 + baseKey.toothSA[0] / zoom;
      double bX = cX - (_wide / zoom) / 2;

      //double aX = bX;
      // double aY = bY + 20;
      double dX = cX;
      double dY = cY -
          baseKey.toothSA[0] / zoom -
          (baseKey.toothSA[0] - baseKey.toothSA[1]).abs() / zoom -
          20;
      double eX = bX;
      double eY = dY;
      double gX = cX + baseKey.wide / zoom;
      double gY = dY;
      double fX = gX + (_wide / zoom) / 2;
      double fY = dY;
      double hX = gX;
      double hY = cY;

      //根据齿号生成轨迹

      post.add(Offset(cX, cY));
      post.add(Offset(dX, dY));
      post.add(Offset(gX, gY));
      post.add(Offset(hX, hY));
      // post.add(Offset(iX, iY));
      post.add(Offset(cX, cY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      //绘制下面的齿深线

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        if (baseKey.side == 1) {
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(gX - baseKey.toothDepth[i] / zoom, eY - 10),
              10,
              const Color(0xff384c70));
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(gX - baseKey.toothDepth[i] / zoom, cY),
                Offset(gX - baseKey.toothDepth[i] / zoom, eY),
              ],
              paintcut..color = Colors.green);
        }
        //   //绘制上面的齿深线
        else {
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(cX + baseKey.toothDepth[i] / zoom, cY),
                Offset(cX + baseKey.toothDepth[i] / zoom, eY),
              ],
              paintcut..color = toothDepthColor);
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(cX + baseKey.toothDepth[i] / zoom, eY - 10),
              10,
              const Color(0xff384c70));
        }
      }

      for (var i = 0; i < tooth; i++) {
        //画齿深远点
        if (seletooth == i) {
          // print(seletooth);
          paintline.color = Colors.red;
        } else {
          paintline.color = const Color(0xff384c70);
        }
        if (baseKey.side == 1) {
          rect = Rect.fromCircle(
              center: Offset(
                  gX - baseKey.ahNum[i] / zoom, dY + baseKey.toothSA[i] / zoom),
              radius: 4.0);

          canvas.drawArc(rect, 0, 360, false, paintline);
        } else {
          rect = Rect.fromCircle(
              center: Offset(
                  cX + baseKey.bhNum[i] / zoom, dY + baseKey.toothSA[i] / zoom),
              radius: 4.0);
          canvas.drawArc(rect, 0, 360, false, paintline);

          //画齿位线

        }
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(dX, dY + baseKey.toothSA[i] / zoom),
              Offset(gX, dY + baseKey.toothSA[i] / zoom),
            ],
            paintcut..color = toothSAColor);
      }

//画定位线
      paintcut.color = Colors.red;
      _showtext(
          canvas, "头部定位", Offset(eX - 20, eY + 5), 10, const Color(0xff384c70));
      paintcut.strokeWidth = 2.0;
      canvas.drawLine(Offset(eX, eY), Offset(fX, fY), paintcut);
      paintcut.strokeWidth = 0.5;
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
    // Color frontcolor = const Color(0xff384c70);
    // double length;
    int tooth = baseKey.toothSA.length;
    List<Offset> post = [];
    //List<Offset> post2 = [];
    Rect rect;

    if (baseKey.locat == 0) {
      // length = baseKey.toothSA[tooth - 1] / zoom +
      //     baseKey.wide / zoom / 2 +
      //     20; //有一个尖头
      double cX = (_wide - baseKey.wide / zoom) / 2;
      double cY = (_hight - baseKey.toothSA[tooth - 1] / zoom) / 2 +
          baseKey.toothSA[tooth - 1] / zoom;
      double bX = cX - (_wide / zoom) / 2;
      double bY = cY;
      //double aX = bX;
      // double aY = bY + 20;
      double dX = cX;
      double dY = cY -
          baseKey.toothSA[tooth - 1] / zoom -
          (baseKey.toothSA[0] - baseKey.toothSA[1]).abs() / zoom -
          20;

      double eY = dY;
      double gX = cX + baseKey.wide / zoom;
      double gY = dY;
      double fX = gX + (_wide / zoom) / 2;

      double hX = gX;
      double hY = cY;
      double iX = fX;
      double iY = cY;

      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀

      post.add(Offset(cX, cY));
      post.add(Offset(dX, dY));
      post.add(Offset(gX, gY));
      post.add(Offset(hX, hY));
      post.add(Offset(cX, cY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        if (seleaxis == 1) {
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(gX - baseKey.toothDepth[i] / zoom, eY - 10),
              10,
              const Color(0xff384c70));
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(gX - baseKey.toothDepth[i] / zoom, cY),
                Offset(gX - baseKey.toothDepth[i] / zoom, eY),
              ],
              paintcut..color = toothDepthColor);
        }
        //   //绘制上面的齿深线
        else {
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(cX + baseKey.toothDepth[i] / zoom, cY),
                Offset(cX + baseKey.toothDepth[i] / zoom, eY),
              ],
              paintcut..color = toothDepthColor);
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(cX + baseKey.toothDepth[i] / zoom, eY - 10),
              10,
              const Color(0xff384c70));
        }
      }

      for (var i = 0; i < tooth; i++) {
        //画齿深远点
        if (seletooth == i) {
          // print(seletooth);
          paintline.color = Colors.red;
        } else {
          paintline.color = const Color(0xff384c70);
        }
        if (seleaxis == 0) {
          rect = Rect.fromCircle(
              center: Offset(
                  cX + baseKey.ahNum[i] / zoom, cY - baseKey.toothSB[i] / zoom),
              radius: 4.0);

          canvas.drawArc(rect, 0, 360, false, paintline);
        } else {
          rect = Rect.fromCircle(
              center: Offset(
                  gX - baseKey.bhNum[i] / zoom, cY - baseKey.toothSA[i] / zoom),
              radius: 4.0);
          canvas.drawArc(rect, 0, 360, false, paintline);

          //画齿位线

        }
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(dX, dY + baseKey.toothSA[i] / zoom),
              Offset(gX, dY + baseKey.toothSA[i] / zoom),
            ],
            paintcut..color = toothSAColor);
      }
      paintcut.color = Colors.red;
      _showtext(
          canvas, "肩部定位", Offset(bX - 20, bY + 5), 10, const Color(0xff384c70));
      paintcut.strokeWidth = 2.0;
      canvas.drawLine(Offset(bX, bY), Offset(iX, iY), paintcut);
      paintcut.strokeWidth = 0.5;
    } else {
      //对头类钥匙画法
      double cX = (_wide - baseKey.wide / zoom) / 2;
      double cY =
          (_hight - baseKey.toothSA[0] / zoom) / 2 + baseKey.toothSA[0] / zoom;
      double bX = cX - (_wide / zoom) / 2;

      //double aX = bX;
      // double aY = bY + 20;
      double dX = cX;
      double dY = cY -
          baseKey.toothSA[0] / zoom -
          (baseKey.toothSA[0] - baseKey.toothSA[1]).abs() / zoom -
          20;
      double eX = bX;
      double eY = dY;
      double gX = cX + baseKey.wide / zoom;
      double gY = dY;
      double fX = gX + (_wide / zoom) / 2;
      double fY = dY;
      double hX = gX;
      double hY = cY;

      //根据齿号生成轨迹

      post.add(Offset(cX, cY));
      post.add(Offset(dX, dY));
      post.add(Offset(gX, gY));
      post.add(Offset(hX, hY));
      // post.add(Offset(iX, iY));
      post.add(Offset(cX, cY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      //绘制下面的齿深线

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        if (seleaxis == 1) {
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(gX - baseKey.toothDepth[i] / zoom, eY - 10),
              10,
              const Color(0xff384c70));
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(gX - baseKey.toothDepth[i] / zoom, cY),
                Offset(gX - baseKey.toothDepth[i] / zoom, eY),
              ],
              paintcut..color = toothDepthColor);
        }
        //   //绘制上面的齿深线
        else {
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(cX + baseKey.toothDepth[i] / zoom, cY),
                Offset(cX + baseKey.toothDepth[i] / zoom, eY),
              ],
              paintcut..color = toothDepthColor);
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(cX + baseKey.toothDepth[i] / zoom, eY - 10),
              10,
              const Color(0xff384c70));
        }
      }

      for (var i = 0; i < tooth; i++) {
        //画齿深远点
        if (seletooth == i) {
          // print(seletooth);
          paintline.color = Colors.red;
        } else {
          paintline.color = const Color(0xff384c70);
        }
        if (seleaxis == 0) {
          rect = Rect.fromCircle(
              center: Offset(
                  cX + baseKey.ahNum[i] / zoom, dY + baseKey.toothSB[i] / zoom),
              radius: 4.0);

          /// paintline.strokeWidth = 5.0;
          canvas.drawArc(rect, 0, 360, false, paintline);
        } else {
          rect = Rect.fromCircle(
              center: Offset(
                  gX - baseKey.bhNum[i] / zoom, dY + baseKey.toothSA[i] / zoom),
              radius: 4.0);
          // paintline.strokeWidth = 5.0;
          canvas.drawArc(rect, 0, 360, false, paintline);

          //画齿位线

        }
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(dX, dY + baseKey.toothSA[i] / zoom),
              Offset(gX, dY + baseKey.toothSA[i] / zoom),
            ],
            paintcut..color = toothSAColor);
      }

//画定位线
      paintcut.color = Colors.red;
      _showtext(
          canvas, "头部定位", Offset(eX - 20, eY + 5), 10, const Color(0xff384c70));
      paintcut.strokeWidth = 2.0;
      canvas.drawLine(Offset(eX, eY), Offset(fX, fY), paintcut);
      paintcut.strokeWidth = 0.5;
    }
  }

//FO21TBE1
  void drawSB7key(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+
    ---------------------------
    */
    // Color frontcolor = const Color(0xff384c70);
    // double length;
    int tooth = baseKey.toothSA.length;
    List<Offset> post = [];
    //List<Offset> post2 = [];
    Rect rect;

    {
      //对头类钥匙画法
      double cX = (_wide - baseKey.thickness / zoom) / 2;
      double cY =
          (_hight - baseKey.toothSA[0] / zoom) / 2 + baseKey.toothSA[0] / zoom;
      double bX = cX - 20;

      //double aX = bX;
      // double aY = bY + 20;
      double dX = cX;
      double dY = cY -
          baseKey.toothSA[0] / zoom -
          (baseKey.toothSA[0] - baseKey.toothSA[1]).abs() / zoom -
          20;
      double eX = bX;
      double eY = dY;
      double gX = cX + baseKey.thickness / zoom;
      double gY = dY;
      double fX = gX + 20;

      double hX = gX;
      double hY = cY;

      //根据齿号生成轨迹

      post.add(Offset(cX, cY));
      post.add(Offset(dX, dY));

      post.add(Offset(gX, gY));

      post.add(Offset(hX, hY));

      post.add(Offset(cX, cY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      //绘制下面的齿深线
//fo21 中间宽度

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(
                  gX -
                      tan(pi / 180 * baseKey.toothDepth[i] / 100) *
                          ((baseKey.wide - 170) / 2) /
                          zoom,
                  cY),
              Offset(
                  gX -
                      tan(pi / 180 * baseKey.toothDepth[i] / 100) *
                          ((baseKey.wide - 170) / 2) /
                          zoom,
                  eY),
            ],
            paintcut..color = toothDepthColor); //toothDepthColor

        //   //绘制上面的齿深线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(
                  cX +
                      tan(pi / 180 * baseKey.toothDepth[i] / 100) *
                          ((baseKey.wide - 170) / 2) /
                          zoom,
                  cY),
              Offset(
                  cX +
                      tan(pi / 180 * baseKey.toothDepth[i] / 100) *
                          ((baseKey.wide - 170) / 2) /
                          zoom,
                  eY),
            ],
            paintcut..color = toothDepthColor);
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(cX + baseKey.toothDepth[i] / zoom, eY - 10),
            10,
            const Color(0xff384c70));
      }

      for (var i = 0; i < tooth; i++) {
        //画齿深远点
        if (seletooth == i) {
          // print(seletooth);
          paintline.color = Colors.red;
        } else {
          paintline.color = const Color(0xff384c70);
        }
        rect = Rect.fromCircle(
            center: Offset(
                gX -
                    tan(pi / 180 * baseKey.ahNum[i] / 100) *
                        ((baseKey.wide - 170) / 2) /
                        zoom,
                dY + baseKey.toothSA[i] / zoom),
            radius: 4.0);

        canvas.drawArc(rect, 0, 360, false, paintline);
        rect = Rect.fromCircle(
            center: Offset(
                cX +
                    tan(pi / 180 * baseKey.bhNum[i] / 100) *
                        ((baseKey.wide - 170) / 2) /
                        zoom,
                dY + baseKey.toothSA[i] / zoom),
            radius: 4.0);
        canvas.drawArc(rect, 0, 360, false, paintline);

        //画齿位线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(dX, dY + baseKey.toothSA[i] / zoom),
              Offset(gX, dY + baseKey.toothSA[i] / zoom),
            ],
            paintcut..color = toothSAColor);
      }

//画定位线
      paintcut.color = Colors.red;
      _showtext(
          canvas, "头部定位", Offset(eX - 20, eY + 5), 10, const Color(0xff384c70));
      paintcut.strokeWidth = 2.0;
      canvas.drawLine(Offset(eX, eY), Offset(fX, eY), paintcut);
      paintcut.strokeWidth = 0.5;
    }
  }

//VA21125 1126
  void drawSB13key(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+
    ---------------------------
    */
    // Color frontcolor = const Color(0xff384c70);
    // double length;
    int tooth = baseKey.toothSA.length;
    List<Offset> post = [];
    //List<Offset> post2 = [];
    Rect rect;

    {
      //对头类钥匙画法
      double cX = (_wide - baseKey.wide / zoom) / 2;
      double cY =
          (_hight - baseKey.toothSA[0] / zoom) / 2 + baseKey.toothSA[0] / zoom;
      double bX = cX - (_wide / zoom) / 2;

      //double aX = bX;
      // double aY = bY + 20;
      double dX = cX;
      double dY = cY -
          baseKey.toothSA[0] / zoom -
          (baseKey.toothSA[0] - baseKey.toothSA[1]).abs() / zoom -
          20;
      double eX = bX;
      double eY = dY;
      double gX = cX + baseKey.wide / zoom;
      double gY = dY;
      double fX = gX + (_wide / zoom) / 2;
      double fY = dY;
      double hX = gX;
      double hY = cY;

      //根据齿号生成轨迹

      post.add(Offset(cX, cY));
      post.add(Offset(dX, dY));
      post.add(Offset(gX, gY));
      post.add(Offset(hX, hY));
      // post.add(Offset(iX, iY));
      post.add(Offset(cX, cY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数

      //绘制下面的齿深线

      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        if (i < 5) {
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(gX - baseKey.toothDepth[i] / zoom, eY - 10),
              10,
              const Color(0xff384c70));
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(gX - baseKey.toothDepth[i] / zoom, cY),
                Offset(gX - baseKey.toothDepth[i] / zoom, eY),
              ],
              paintcut..color = Colors.green);
        }
        //   //绘制上面的齿深线
        else {
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(cX + baseKey.toothDepth[i] / zoom, cY),
                Offset(cX + baseKey.toothDepth[i] / zoom, eY),
              ],
              paintcut..color = toothDepthColor);
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(cX + baseKey.toothDepth[i] / zoom, eY - 10),
              10,
              const Color(0xff384c70));
        }
      }

      for (var i = 0; i < tooth; i++) {
        //画齿深远点
        if (seletooth == i) {
          // print(seletooth);
          paintline.color = Colors.red;
        } else {
          paintline.color = const Color(0xff384c70);
        }
        int side = 0;
        int toothnum = 0;
        for (var j = 0; j < 10; j++) {
          rect = Rect.fromCircle(
              center: Offset(
                  gX - baseKey.ahNum[i] / zoom, dY + baseKey.toothSA[i] / zoom),
              radius: 4.0);
          canvas.drawArc(rect, 0, 360, false, paintline);
          //  break;

          rect = Rect.fromCircle(
              center: Offset(
                  cX + baseKey.bhNum[i] / zoom, dY + baseKey.toothSA[i] / zoom),
              radius: 4.0);
          canvas.drawArc(rect, 0, 360, false, paintline);
          //  break;

        }

        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(dX, dY + baseKey.toothSA[i] / zoom),
              Offset(gX, dY + baseKey.toothSA[i] / zoom),
            ],
            paintcut..color = toothSAColor);
      }

//画定位线
      paintcut.color = Colors.red;
      _showtext(
          canvas, "头部定位", Offset(eX - 20, eY + 5), 10, const Color(0xff384c70));
      paintcut.strokeWidth = 2.0;
      canvas.drawLine(Offset(eX, eY), Offset(fX, fY), paintcut);
      paintcut.strokeWidth = 0.5;
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

    //根据钥匙宽度 计算 缩放倍数
    zoom = (baseKey.wide ~/ (_wide - 230));
    var zoom2 = 0;
    if (baseKey.locat == 0) {
      zoom2 = (baseKey.toothSA[baseKey.cuts - 1] ~/ (_hight - 230));
    } else {
      zoom2 = (baseKey.toothSA[0] ~/ (_hight - 230));
    }
    zoom = zoom > zoom2 ? zoom : zoom2;

    switch (baseKey.keyClass) {
      case 0: //平铣双边
        //   debugPrint("平铣双边");
        drawSB0key(canvas);
        break;
      case 1: //平铣单边 立铣外沟单边
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
        drawSB3key(canvas);
        break;
      case 6:
        break;
      case 7: //FO21
        drawSB7key(canvas);
        break;
      case 8:
        break;
      case 13:
        drawSB13key(canvas);
        break;
    }
  }

  void getcolors(Offset offset) {}
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
