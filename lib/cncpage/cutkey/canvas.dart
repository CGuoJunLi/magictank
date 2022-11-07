import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:magictank/cncpage/basekey.dart';

///
/// @ClassName FlutterPainter
/// @Description 绘制类
/// @Author waitwalker
/// @Date 2020-03-07
///
class FlutterPainter extends CustomPainter {
  int zoom = 10; //缩放倍数
  late double _wide;
  late double _hight;
  int cutsindex;
  int model;
  FlutterPainter(this.cutsindex, {this.model = 0});
  Paint paintline = Paint()
    ..color = const Color(0xff384c70) //画笔颜色
    ..strokeCap = StrokeCap.round //画笔笔触类型
    ..isAntiAlias = true //是否启动抗锯齿
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0; //画笔的宽度
  Paint paintcut = Paint()
    ..color = const Color(0xff666666) //画笔颜色
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

  void drawLocat(
      Canvas canvas, double beginx, double beginy, double endx, double endy) {
    Paint locatpaintline = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round //画笔笔触类型
      ..isAntiAlias = true //是否启动抗锯齿
      ..strokeWidth = 2.0;

    List<Offset> post = [];
    // post.add(Offset(beginx, beginy));

    post.add(Offset(beginx, beginy));

    post.add(Offset(endx, endy));

    Path path = Path();
    path.moveTo(endx, endy);
    path.lineTo(endx - 5, endy - 10);
    path.lineTo(endx + 5, endy - 10);
    path.lineTo(endx, endy);

    canvas.drawPath(path, locatpaintline);
    canvas.drawPoints(

        ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
        PointMode.polygon, //首尾相连
        // PointMode.lines, //两两相连
        //PointMode.points,//画点
        post,
        locatpaintline);
  }

//绘图立铣内沟单边
  void drawSB5Key(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+



    ---------------------------
    
    */
    Color frontcolor = const Color(0xff666666);
    double beginx = 50;
    double beginy = 140; //代表肩膀宽度为1000丝
    double endy = beginy - 1000 / zoom; //代表肩膀宽度为1000丝
    double headx;
    double length;
    double locatx = beginx + 30; //肩膀位置x方向
    double locaty;
    int tooth = baseKey.toothSA.length;
    List<Offset> post = [];
    List<Offset> post2 = [];
    Rect rect;
    if (baseKey.locat == 0) {
      // length = baseKey.toothSA[tooth - 1] / zoom; //
      // double beginx = 50;
      // double beginy = 140; //代表肩膀宽度为1000丝
      length = baseKey.toothSA[tooth - 1] / zoom + baseKey.wide / zoom;
      beginx = (_wide - length) / 2;
      endy = (_hight - baseKey.wide / zoom) / 2;
      beginy = endy + baseKey.wide / zoom;
      headx = beginx + length;
      locatx = beginx + 20;
      locaty = beginy + 10;
      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀
      post.add(Offset(beginx, locaty));
      post.add(Offset(locatx, locaty));
      post.add(Offset(locatx,
          ((beginy - endy) / 2 + baseKey.wide / zoom / 2 + endy).toDouble()));
      post.add(Offset(locatx + baseKey.toothSA[tooth - 1] / zoom + 10,
          ((beginy - endy) / 2 + baseKey.wide / zoom / 2 + endy).toDouble()));
      for (var i = tooth - 1; i >= 0; i--) {
        if (baseKey.side == 0) {
          post.add(Offset(locatx + baseKey.toothSA[i] / zoom + 1,
              baseKey.ahNum[i] / zoom + baseKey.groove / zoom + endy));
          post.add(Offset(locatx + baseKey.toothSA[i] / zoom - 1,
              baseKey.ahNum[i] / zoom + baseKey.groove / zoom + endy));
        } else {
          post.add(Offset(locatx + baseKey.toothSA[i] / zoom / 100 + 1,
              baseKey.bhNum[i] / zoom + endy));
          post.add(Offset(locatx + baseKey.toothSA[i] / zoom / 100 - 1,
              baseKey.bhNum[i] / zoom + endy));
        }
      }
      switch (baseKey.keySerNum) {
        case 32769:
          post.add(Offset(locatx + baseKey.toothSA[0] / zoom / 100 - 10,
              baseKey.bhNum[0] / zoom + endy - 10));
          post2.add(Offset(locatx + baseKey.toothSA[0] / zoom - 25,
              baseKey.ahNum[0] / zoom + endy - 25));
          break;
        case 77:
          post.add(Offset(locatx + baseKey.toothSA[0] / zoom / 100 - 10,
              baseKey.bhNum[0] / zoom + endy));
          post2.add(Offset(locatx + baseKey.toothSA[0] / zoom - 25,
              baseKey.ahNum[0] / zoom + endy));
          break;
        default:
      }

      for (var i = 0; i < tooth; i++) {
        if (baseKey.side == 0) {
          post2.add(Offset(locatx + baseKey.toothSA[i] / zoom - 1,
              baseKey.ahNum[i] / zoom + endy));
          post2.add(Offset(locatx + baseKey.toothSA[i] / zoom + 1,
              baseKey.ahNum[i] / zoom + endy));
        } else {
          post2.add(Offset(locatx + baseKey.toothSA[i] / zoom / 100 + 1,
              baseKey.bhNum[i] / zoom + baseKey.groove / zoom + endy));
          post2.add(Offset(locatx - baseKey.toothSA[i] / zoom / 100 - 1,
              baseKey.bhNum[i] / zoom - baseKey.groove / zoom + endy));
        }
      }
      post2.add(Offset(locatx + baseKey.toothSA[tooth - 1] / zoom + 10,
          ((beginy - endy) / 2 - baseKey.wide / zoom / 2 + endy).toDouble()));
      post2.add(Offset(locatx,
          ((beginy - endy) / 2 - baseKey.wide / zoom / 2 + endy).toDouble()));

      post2.add(Offset(locatx, endy - 10));
      post2.add(Offset(beginx, endy - 10));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post2,
          paintline..color = const Color(0xff384c70));
      // canvas.drawCircle(
      //     Offset(post2[0].dx, (post[post.length - 1].dy + post2[0].dy) / 2),
      //     baseKey.groove / zoom / 2,
      //     paintline);
      switch (baseKey.keySerNum) {
        case 32769:
          rect = Rect.fromCircle(
              center: Offset((post[post.length - 1].dx + post2[0].dx) / 2,
                  (post[post.length - 1].dy + post2[0].dy) / 2),
              radius: 10);
          canvas.drawArc(rect, 2 * pi / 3, 2 * pi / 2, false, paintline);
          break;
        case 77:
          rect = Rect.fromCircle(
              center: Offset(
                  post2[0].dx, (post[post.length - 1].dy + post2[0].dy) / 2),
              radius: baseKey.groove / zoom / 2);
          canvas.drawArc(rect, 2 * pi / 4, 2 * pi / 2, false, paintline);
          break;
        default:
          rect = Rect.fromCircle(
              center: Offset(
                  post2[0].dx, (post[post.length - 1].dy + post2[0].dy) / 2),
              radius: baseKey.groove / zoom / 2);
          canvas.drawArc(rect, 2 * pi / 4, 2 * pi / 2, false, paintline);
          break;
      }

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数
      //例如HU66 12*12*4
      var j = baseKey.toothDepth.length - 1;
      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        j = j - i;
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(locatx, baseKey.toothDepth[i] / zoom + endy),
              Offset(
                  locatx +
                      baseKey.toothSA[tooth - 1] / zoom +
                      30 -
                      6 * i.toDouble(),
                  baseKey.toothDepth[i] / zoom + endy),
              Offset(
                  locatx +
                      baseKey.toothSA[tooth - 1] / zoom +
                      30 -
                      6 * i.toDouble(),
                  i == 0
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom - 5 * i + endy),
              Offset(
                  locatx + baseKey.toothSA[tooth - 1] / zoom + 30,
                  i == 0
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom - 5 * i + endy),
            ],
            paintcut..color = const Color(0xff666666));

        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(locatx + baseKey.toothSA[tooth - 1] / zoom + 30 + 6,
                baseKey.toothDepth[i] / zoom - 5 * i - 6 + endy),
            12,
            const Color(0xff666666));
      }
      //显示齿号
      for (var i = 0; i < tooth; i++) {
        // rect = Rect.fromLTWH(
        //     locatx + baseKey.toothSA[i] / zoom - 6, endy, 6, 6);
        // canvas.drawRect(rect, paintcut);
        if (i == cutsindex) {
          frontcolor = Colors.red;
        } else {
          frontcolor = const Color(0xff666666);
        }
        _showtext(
            canvas,
            baseKey.ahNums[i],
            Offset(locatx + baseKey.toothSA[i] / zoom - 9, endy - 18),
            18,
            frontcolor);
      }
      //    canvas.drawLine(
      //       Offset(locatx, beginy + 5), Offset(locatx, endy - 5), paintcut);
      drawLocat(canvas, locatx, beginy + 20, locatx, endy - 20);
    } else {
      length = baseKey.toothSA[0] / zoom + 20;
      beginx = (_wide - length) / 2;
      endy = (_hight - baseKey.wide / zoom) / 2;
      beginy = endy + baseKey.wide / zoom;
      headx = beginx + length;
      // beginx = 50;
      // endy = 40;
      // headx = beginx + baseKey.toothSA[0] / zoom + 10;
      // beginy = (40 + baseKey.wide / zoom).toDouble(); //起始点Y的坐标

      //根据齿号生成轨迹

      post.add(Offset(beginx, beginy));
      post.add(Offset(headx, beginy));
      //先画一边的齿号 准备钥匙数据
      switch (baseKey.keySerNum) {
        case 260:
        case 780:
        case 582:
          for (var i = tooth - 1; i >= 0; i--) {
            if (i % 2 == 0) {
              post.add(Offset(headx - baseKey.toothSA[i] / zoom + 2,
                  beginy - baseKey.ahNum[i] / zoom));
              post.add(Offset(headx - baseKey.toothSA[i] / zoom - 2,
                  beginy - baseKey.ahNum[i] / zoom));
            } else {
              post.add(Offset(headx - baseKey.toothSA[i] / zoom + 2,
                  baseKey.ahNum[i] / zoom + baseKey.groove / zoom + endy));
              post.add(Offset(headx - baseKey.toothSA[i] / zoom - 2,
                  baseKey.ahNum[i] / zoom + baseKey.groove / zoom + endy));
            }
          }
          break;
        default:
          for (var i = tooth - 1; i >= 0; i--) {
            if (baseKey.side == 0) {
              post.add(Offset(headx - baseKey.toothSA[i] / zoom + 2,
                  baseKey.ahNum[i] / zoom + baseKey.groove / zoom + endy));
              post.add(Offset(headx - baseKey.toothSA[i] / zoom - 2,
                  baseKey.ahNum[i] / zoom + baseKey.groove / zoom + endy));
            } else {
              post.add(Offset(headx - baseKey.toothSA[i] / zoom + 2,
                  beginy - baseKey.ahNum[i] / zoom));
              post.add(Offset(headx - baseKey.toothSA[i] / zoom - 2,
                  beginy - baseKey.ahNum[i] / zoom));
            }
          }
          break;
      }

      switch (baseKey.keySerNum) {
        case 77:
          post.add(Offset(locatx - 25, beginy - baseKey.bhNum[0] / zoom));
          post2.add(Offset(locatx - 25,
              beginy - baseKey.ahNum[0] / zoom - baseKey.groove / zoom));
          break;
        default:
      }
      //在画另一边的齿号
      switch (baseKey.keySerNum) {
        case 260:
        case 780:
        case 582:
          for (var i = 0; i < tooth; i++) {
            if (i % 2 == 0) {
              post2.add(Offset(headx - baseKey.toothSA[i] / zoom - 1,
                  beginy - baseKey.ahNum[i] / zoom - baseKey.groove / zoom));
              post2.add(Offset(headx - baseKey.toothSA[i] / zoom + 1,
                  beginy - baseKey.ahNum[i] / zoom - baseKey.groove / zoom));
            } else {
              post2.add(Offset(headx - baseKey.toothSA[i] / zoom - 1,
                  baseKey.ahNum[i] / zoom + endy));
              post2.add(Offset(headx - baseKey.toothSA[i] / zoom + 1,
                  baseKey.ahNum[i] / zoom + endy));
            }
          }
          break;
        default:
          for (var i = 0; i < tooth; i++) {
            if (baseKey.side == 0) {
              post2.add(Offset(headx - baseKey.toothSA[i] / zoom - 1,
                  baseKey.ahNum[i] / zoom + endy));
              post2.add(Offset(headx - baseKey.toothSA[i] / zoom + 1,
                  baseKey.ahNum[i] / zoom + endy));
            } else {
              post2.add(Offset(headx - baseKey.toothSA[i] / zoom - 2,
                  beginy - baseKey.ahNum[i] / zoom - baseKey.groove / zoom));
              post2.add(Offset(headx - baseKey.toothSA[i] / zoom + 2,
                  beginy - baseKey.ahNum[i] / zoom - baseKey.groove / zoom));
            }
          }
          break;
      }

      //画钥匙的另一边
      post2.add(Offset(headx,
          ((beginy - endy) / 2 - baseKey.wide / zoom / 2 + endy).toDouble()));
      post2.add(Offset(beginx, endy));

      //画钥匙轮廓
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));
      //画钥匙另一边
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post2,
          paintline..color = const Color(0xff384c70));
      //画尾部的圆心
      rect = Rect.fromCircle(
          center:
              Offset(post2[0].dx, (post[post.length - 1].dy + post2[0].dy) / 2),
          radius: baseKey.groove / zoom / 2);
      canvas.drawArc(rect, 2 * pi / 4, 2 * pi / 2, false, paintline);

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数
      //例如HU66 12*12*4
      if (baseKey.side == 0) {
        //上齿
        var j = baseKey.toothDepth.length - 1;
        for (var i = 0; i < baseKey.toothDepth.length; i++) {
          j = j - i;
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(beginx, baseKey.toothDepth[i] / zoom + endy),
                Offset(headx + 30 - 6 * i.toDouble(),
                    baseKey.toothDepth[i] / zoom + endy),
                Offset(
                    headx + 30 - 6 * i.toDouble(),
                    i == 0
                        ? baseKey.toothDepth[i] / zoom + endy
                        : baseKey.toothDepth[i] / zoom - 5 * i + endy),
                Offset(
                    headx + 30,
                    i == 0
                        ? baseKey.toothDepth[i] / zoom + endy
                        : baseKey.toothDepth[i] / zoom - 5 * i + endy),
              ],
              paintcut..color = const Color(0xff666666));

          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(headx + 30 + 6,
                  baseKey.toothDepth[i] / zoom - 6 * i - 6 + endy),
              12,
              const Color(0xff666666));
        }
      }
      if (baseKey.side == 1 ||
          baseKey.keySerNum == 260 ||
          baseKey.keySerNum == 780 ||
          baseKey.keySerNum == 582) {
        //下齿号
        //画齿深线条
        var j = baseKey.toothDepth.length - 1;
        for (var i = 0; i < baseKey.toothDepth.length; i++) {
          j = j - i;
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(beginx, beginy - baseKey.toothDepth[i] / zoom),
                Offset(headx + 30 - 6 * i.toDouble(),
                    beginy - baseKey.toothDepth[i] / zoom),
                Offset(
                    headx + 30 - 6 * i.toDouble(),
                    i == 0
                        ? beginy - baseKey.toothDepth[i] / zoom
                        : beginy - baseKey.toothDepth[i] / zoom + 5 * i),
                Offset(
                    headx + 30,
                    i == 0
                        ? beginy - baseKey.toothDepth[i] / zoom
                        : beginy - baseKey.toothDepth[i] / zoom + 5 * i),
              ],
              paintcut..color = const Color(0xff666666));

          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(headx + 30 + 6,
                  beginy - baseKey.toothDepth[i] / zoom + 6 * i - 6),
              12,
              const Color(0xff666666));
        }
      }
      //画定位线

      //显示齿号
      for (var i = 0; i < tooth; i++) {
        if (i == cutsindex) {
          frontcolor = Colors.red;
        } else {
          frontcolor = const Color(0xff666666);
        }
        _showtext(
            canvas,
            baseKey.ahNums[i],
            Offset(headx - baseKey.toothSA[i] / zoom - 9, endy - 18),
            18,
            frontcolor);
      }
      drawLocat(canvas, headx, beginy + 20, headx, endy - 20);
    }
  }

//绘图立铣内沟双边
  void drawSB2Key(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+



    ---------------------------
    
    */
    Color frontcolor = const Color(0xff666666);
    double beginx = 50;
    double beginy = 140; //代表肩膀宽度为1000丝
    double endy = beginy - 1000 / zoom; //代表肩膀宽度为1000丝
    double headx;
    double length;
    double locatx = beginx + 30; //肩膀位置x方向
    double locaty;
    int tootha = baseKey.sideAtooth; //baseKey.toothSA.length;
    int toothb = baseKey.sideBtooth; //baseKey.toothSB.length;
    List<Offset> post = [];
    List<Offset> post2 = [];
    // Rect rect;
    if (baseKey.locat == 0) {
      length = baseKey.toothSA[tootha - 1] / zoom + 20;
      beginx = (_wide - length) / 2;
      endy = (_hight - baseKey.wide / zoom) / 2;
      beginy = endy + baseKey.wide / zoom;
      headx = beginx + length;
      locatx = beginx - 20;
      locaty = beginy + 20;
      // beginx = 50;
      // endy = 40;
      // headx = beginx + baseKey.toothSA[0] / zoom + 10;
      // beginy = (40 + baseKey.wide / zoom).toDouble(); //起始点Y的坐标

      //根据齿号生成轨迹
      post.add(Offset(locatx, locaty));
      post.add(Offset(beginx, locaty));

      post.add(Offset(beginx, beginy));
      post.add(Offset(headx, beginy));
      //先画一边的齿号 准备钥匙数据
      ////print(keydata);
      for (var i = toothb - 1; i >= 0; i--) {
        post.add(Offset(beginx + baseKey.toothSB[i] / zoom + 2,
            beginy - baseKey.bhNum[i] / zoom));

        post.add(Offset(beginx + baseKey.toothSB[i] / zoom - 2,
            beginy - baseKey.bhNum[i] / zoom));
      }
      //在画另一边的齿号
      for (var i = 0; i < tootha; i++) {
        post2.add(Offset(beginx + baseKey.toothSA[i] / zoom - 1,
            baseKey.ahNum[i] / zoom + endy));
        post2.add(Offset(beginx + baseKey.toothSA[i] / zoom + 1,
            baseKey.ahNum[i] / zoom + endy));
      }
      //画钥匙的另一边
      post2.add(Offset(headx,
          ((beginy - endy) / 2 - baseKey.wide / zoom / 2 + endy).toDouble()));
      post2.add(Offset(beginx, endy));
      post2.add(Offset(beginx, endy - 20));
      post2.add(Offset(beginx - 20, endy - 20));
      //画钥匙轮廓
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));
      //画钥匙另一边
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post2,
          paintline..color = const Color(0xff384c70));
      //画尾部的圆心

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数
      //例如HU66 12*12*4
      var j = baseKey.toothDepth.length - 1;
      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        j = j - i;
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(beginx, baseKey.toothDepth[i] / zoom + endy),
              Offset(headx + 30 - 6 * i.toDouble(),
                  baseKey.toothDepth[i] / zoom + endy),
              Offset(
                  headx + 30 - 6 * i.toDouble(),
                  i == 0
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom - 5 * i + endy),
              Offset(
                  headx + 30,
                  i == 0
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom - 5 * i + endy),
            ],
            paintcut..color = const Color(0xff666666));

        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(headx + 30 + 6,
                baseKey.toothDepth[i] / zoom - 5 * i - 6 + endy),
            12,
            const Color(0xff666666));
      }

      //下齿号
      //画齿深线条
      //     var j = baseKey.toothDepth.length - 1;
      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        j = j - i;
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(beginx, beginy - baseKey.toothDepth[i] / zoom),
              Offset(headx + 30 - 6 * i.toDouble(),
                  beginy - baseKey.toothDepth[i] / zoom),
              Offset(
                  headx + 30 - 6 * i.toDouble(),
                  i == 0
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy - baseKey.toothDepth[i] / zoom + 5 * i),
              Offset(
                  headx + 30,
                  i == 0
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy - baseKey.toothDepth[i] / zoom + 5 * i),
            ],
            paintcut..color = const Color(0xff666666));

        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(headx + 30 + 6,
                beginy - baseKey.toothDepth[i] / zoom + 5 * i - 6),
            12,
            const Color(0xff666666));
      }

      //  画定位线
      canvas.drawLine(
          Offset(beginx, beginy + 5), Offset(beginx, endy - 5), paintcut);
      //显示齿号
      for (var i = 0; i < tootha; i++) {
        if (i == cutsindex) {
          frontcolor = Colors.red;
        } else {
          frontcolor = const Color(0xff666666);
        }
        _showtext(
            canvas,
            baseKey.ahNums[i],
            Offset(beginx + baseKey.toothSA[i] / zoom - 9, endy - 18),
            18,
            frontcolor);
      }
      for (var i = 0; i < toothb; i++) {
        if (i == cutsindex - tootha) {
          frontcolor = Colors.red;
        } else {
          frontcolor = const Color(0xff666666);
        }
        _showtext(
            canvas,
            baseKey.bhNums[i],
            Offset(beginx + baseKey.toothSB[i] / zoom - 9, beginy + 18),
            18,
            frontcolor);
      }
    } else {
      length = baseKey.toothSA[0] / zoom + baseKey.wide / zoom;
      beginx = (_wide - length) / 2;
      endy = (_hight - baseKey.wide / zoom) / 2;
      beginy = endy + baseKey.wide / zoom;
      headx = beginx + length;

      // beginx = 50;
      // endy = 40;
      // headx = beginx + baseKey.toothSA[0] / zoom + 10;
      // beginy = (40 + baseKey.wide / zoom).toDouble(); //起始点Y的坐标

      //根据齿号生成轨迹

      post.add(Offset(beginx, beginy));
      post.add(Offset(headx, beginy));
      //先画一边的齿号 准备钥匙数据
      // //print(keydata);
      for (var i = toothb - 1; i >= 0; i--) {
        post.add(Offset(headx - baseKey.toothSB[i] / zoom + 2,
            beginy - baseKey.bhNum[i] / zoom));

        post.add(Offset(headx - baseKey.toothSB[i] / zoom - 2,
            beginy - baseKey.bhNum[i] / zoom));
      }
      //在画另一边的齿号
      for (var i = 0; i < toothb; i++) {
        post2.add(Offset(headx - baseKey.toothSA[i] / zoom - 1,
            baseKey.ahNum[i] / zoom + endy));
        post2.add(Offset(headx - baseKey.toothSA[i] / zoom + 1,
            baseKey.ahNum[i] / zoom + endy));
      }
      //画钥匙的另一边
      post2.add(Offset(headx,
          ((beginy - endy) / 2 - baseKey.wide / zoom / 2 + endy).toDouble()));
      post2.add(Offset(beginx, endy));

      //画钥匙轮廓
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));
      //画钥匙另一边
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post2,
          paintline..color = const Color(0xff384c70));
      //画尾部的圆心

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数
      //例如HU66 12*12*4
      var j = baseKey.toothDepth.length - 1;
      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        j = j - i;
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(beginx, baseKey.toothDepth[i] / zoom + endy),
              Offset(headx + 30 - 6 * i.toDouble(),
                  baseKey.toothDepth[i] / zoom + endy),
              Offset(
                  headx + 30 - 6 * i.toDouble(),
                  i == 0
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom - 5 * i + endy),
              Offset(
                  headx + 30,
                  i == 0
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom - 5 * i + endy),
            ],
            paintcut..color = const Color(0xff666666));

        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(headx + 30 + 6,
                baseKey.toothDepth[i] / zoom - 5 * i - 6 + endy),
            12,
            const Color(0xff666666));
      }

      //下齿号
      //画齿深线条
      //     var j = baseKey.toothDepth.length - 1;
      for (var i = 0; i < baseKey.toothDepth.length; i++) {
        j = j - i;
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(beginx, beginy - baseKey.toothDepth[i] / zoom),
              Offset(headx + 30 - 6 * i.toDouble(),
                  beginy - baseKey.toothDepth[i] / zoom),
              Offset(
                  headx + 30 - 6 * i.toDouble(),
                  i == 0
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy - baseKey.toothDepth[i] / zoom + 5 * i),
              Offset(
                  headx + 30,
                  i == 0
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy - baseKey.toothDepth[i] / zoom + 5 * i),
            ],
            paintcut..color = const Color(0xff666666));

        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(headx + 30 + 6,
                beginy - baseKey.toothDepth[i] / zoom + 5 * i - 6),
            12,
            const Color(0xff666666));
      }

      //  画定位线

      //显示齿号

      for (var i = 0; i < tootha; i++) {
        if (i == cutsindex) {
          frontcolor = Colors.red;
        } else {
          frontcolor = const Color(0xff666666);
        }
        _showtext(
            canvas,
            baseKey.ahNums[i],
            Offset(headx - baseKey.toothSA[i] / zoom - 9, endy - 18),
            18,
            frontcolor);
      }
      for (var i = 0; i < toothb; i++) {
        if (i == cutsindex - tootha) {
          frontcolor = Colors.red;
        } else {
          frontcolor = const Color(0xff666666);
        }
        _showtext(
            canvas,
            baseKey.bhNums[i],
            Offset(headx - baseKey.toothSB[i] / zoom - 9, beginy + 18),
            18,
            frontcolor);
      }
      drawLocat(canvas, headx, beginy + 20, headx, endy - 20);
      // canvas.drawLine(
      //     Offset(headx, beginy + 5), Offset(headx, endy - 5), paintcut);
    }
  }

//绘图平铣双边 立铣外沟双边
  void drawSB0Key(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+



    ---------------------------
    
    */
    Color frontcolor = const Color(0xff666666);
    double beginx = 50;
    double beginy = 140; //代表肩膀宽度为1000丝
    double endy = beginy - 1000 / zoom; //代表肩膀宽度为1000丝
    double headx;
    double length;
    double locatx = beginx + 30; //肩膀位置x方向
    double locaty;
    int tooth = baseKey.toothSA.length;
    List<Offset> post = [];
    // List<Offset> post2 = [];
    // Rect rect;
    // double aX;
    // double aY;
    // double bX;
    // double bY;
    // double cX;
    // double cY;
    // double dX;
    // double dY;
    // double eX;
    // double eY;
    // double fX;
    // double fY;
    // double gX;
    // double gY;
    // double hX;
    // double hY;
    // double iX;
    // double iY;

    if (baseKey.locat == 0) {
      // length = baseKey.toothSA[tooth - 1] / zoom; //
      // double beginx = 50;
      // double beginy = 140; //代表肩膀宽度为1000丝
      length = baseKey.toothSA[tooth - 1] / zoom +
          baseKey.wide / zoom / 2 +
          20; //有一个尖头
      beginx = (_wide - length) / 2;
      endy = (_hight - baseKey.wide / zoom) / 2;
      beginy = endy + baseKey.wide / zoom;
      headx = beginx + length;
      locatx = beginx + 20;
      locaty = beginy + 10;
      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀
      post.add(Offset(beginx, locaty));
      post.add(Offset(locatx, locaty));
      post.add(Offset(locatx, beginy));

      for (var i = 0; i < tooth; i++) {
        post.add(Offset(locatx + baseKey.toothSA[i] / zoom - 2,
            baseKey.ahNum[i] / zoom + endy));
        post.add(Offset(locatx + baseKey.toothSA[i] / zoom + 2,
            baseKey.ahNum[i] / zoom + endy));
      }
      //  post.add(Offset(headx - baseKey.wide / zoom / 2, beginy));
      post.add(Offset(headx, beginy - baseKey.wide / zoom / 2));
      //post.add(Offset(headx - baseKey.wide / zoom / 2, endy));
      for (var i = tooth - 1; i >= 0; i--) {
        post.add(Offset(locatx + baseKey.toothSA[i] / zoom + 2,
            beginy - baseKey.ahNum[i] / zoom));
        post.add(Offset(locatx + baseKey.toothSA[i] / zoom - 2,
            beginy - baseKey.ahNum[i] / zoom));
      }

      post.add(Offset(locatx, endy));
      post.add(Offset(locatx, endy - 10));
      post.add(Offset(beginx, endy - 10));
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
      int ahtoothnum = baseKey.toothDepth.length;
      for (var i = 0; i < ahtoothnum; i++) {
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(locatx, baseKey.toothDepth[i] / zoom + endy),
              Offset(headx - 6 * (ahtoothnum - i).toDouble(),
                  baseKey.toothDepth[i] / zoom + endy),
              Offset(
                  headx - 6 * (ahtoothnum - i).toDouble(),
                  i == ahtoothnum - 1
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom +
                          5 * (ahtoothnum - i) +
                          endy),
              Offset(
                  headx,
                  i == ahtoothnum - 1
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom +
                          5 * (ahtoothnum - i) +
                          endy),
            ],
            paintcut..color = const Color(0xff666666));

        //绘制上面的齿深线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(locatx, beginy - baseKey.toothDepth[i] / zoom),
              Offset(headx - 6 * (ahtoothnum - i).toDouble(),
                  beginy - baseKey.toothDepth[i] / zoom),
              Offset(
                  headx - 6 * (ahtoothnum - i).toDouble(),
                  i == ahtoothnum - 1
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy -
                          baseKey.toothDepth[i] / zoom -
                          5 * (ahtoothnum - i)),
              Offset(
                  headx,
                  i == ahtoothnum - 1
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy -
                          baseKey.toothDepth[i] / zoom -
                          5 * (ahtoothnum - i)),
            ],
            paintcut..color = const Color(0xff666666));
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(locatx + baseKey.toothSA[tooth - 1] / zoom + 30 + 6,
                baseKey.toothDepth[i] / zoom + 5 * (ahtoothnum - i) - 6 + endy),
            10,
            const Color(0xff666666));
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(
                locatx + baseKey.toothSA[tooth - 1] / zoom + 30 + 6,
                beginy -
                    baseKey.toothDepth[i] / zoom -
                    5 * (ahtoothnum - i) -
                    6),
            10,
            const Color(0xff666666));
        drawLocat(canvas, locatx, beginy + 20, locatx, endy - 20);
        // canvas.drawLine(
        //     Offset(locatx, beginy + 5), Offset(locatx, endy - 5), paintcut);
      }
      //显示齿号
      for (var i = 0; i < tooth; i++) {
        if (i == cutsindex) {
          frontcolor = Colors.red;
        } else {
          frontcolor = const Color(0xff666666);
        }
        _showtext(
            canvas,
            baseKey.ahNums[i],
            Offset(locatx + baseKey.toothSA[i] / zoom - 9, endy - 18),
            18,
            frontcolor);
        _showtext(
            canvas,
            baseKey.ahNums[i],
            Offset(locatx + baseKey.toothSA[i] / zoom - 9, beginy + 18),
            18,
            frontcolor);
      }
    } else {
      // length = baseKey.toothSA[tooth - 1] / zoom; //
      // double beginx = 50;
      // double beginy = 140; //代表肩膀宽度为1000丝

      double length =
          baseKey.toothSA[0] / zoom + baseKey.wide / zoom / 2; //有一个尖头
      beginx = (_wide - length) / 2;
      endy = (_hight - baseKey.wide / zoom) / 2;
      beginy = endy + baseKey.wide / zoom;
      headx = beginx + length;

      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀
      post.add(Offset(beginx, beginy));
      post.add(Offset(
          headx -
              baseKey.toothSA[0] / zoom -
              2 -
              (beginy - (baseKey.ahNum[0] / zoom + endy)),
          beginy));
      for (var i = 0; i < tooth; i++) {
        post.add(Offset(headx - baseKey.toothSA[i] / zoom - 2,
            baseKey.ahNum[i] / zoom + endy));
        post.add(Offset(headx - baseKey.toothSA[i] / zoom + 2,
            baseKey.ahNum[i] / zoom + endy));
      }
      post.add(Offset(headx - baseKey.toothSA[tooth - 1] / zoom + 4,
          baseKey.ahNum[tooth - 1] / zoom + endy));
      //  post.add(Offset(headx - baseKey.wide / zoom / 2, beginy));

      post.add(Offset(headx, beginy - baseKey.wide / zoom / 2 + 5));
      post.add(Offset(headx, beginy - baseKey.wide / zoom / 2 - 5));
      post.add(Offset(headx - baseKey.toothSA[tooth - 1] / zoom + 4,
          beginy - baseKey.ahNum[tooth - 1] / zoom));
      //post.add(Offset(headx - baseKey.wide / zoom / 2, endy));
      for (var i = tooth - 1; i >= 0; i--) {
        post.add(Offset(headx - baseKey.toothSA[i] / zoom + 2,
            beginy - baseKey.ahNum[i] / zoom));
        post.add(Offset(headx - baseKey.toothSA[i] / zoom - 2,
            beginy - baseKey.ahNum[i] / zoom));
      }
      post.add(Offset(
          headx -
              baseKey.toothSA[0] / zoom -
              2 -
              ((beginy - baseKey.ahNum[0] / zoom) - endy),
          endy));
      post.add(Offset(beginx, endy));
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
      int keyahtoothnum = baseKey.toothDepth.length;
      for (var i = 0; i < keyahtoothnum; i++) {
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(locatx, baseKey.toothDepth[i] / zoom + endy),
              Offset(headx - 6 * (keyahtoothnum - i).toDouble(),
                  baseKey.toothDepth[i] / zoom + endy),
              Offset(
                  headx - 6 * (keyahtoothnum - i).toDouble(),
                  i == keyahtoothnum - 1
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom +
                          endy +
                          5 * (keyahtoothnum - i)),
              Offset(
                  headx + 6,
                  i == keyahtoothnum - 1
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom +
                          5 * (keyahtoothnum - i) +
                          endy),
            ],
            paintcut..color = const Color(0xff666666));

        //绘制上面的齿深线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(locatx, beginy - baseKey.toothDepth[i] / zoom),
              Offset(headx - 6 * (keyahtoothnum - i).toDouble(),
                  beginy - baseKey.toothDepth[i] / zoom),
              Offset(
                  headx - 6 * (keyahtoothnum - i).toDouble(),
                  i == keyahtoothnum - 1
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy -
                          baseKey.toothDepth[i] / zoom -
                          5 * (keyahtoothnum - i)),
              Offset(
                  headx + 6,
                  i == keyahtoothnum - 1
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy -
                          baseKey.toothDepth[i] / zoom -
                          5 * (keyahtoothnum - i)),
            ],
            paintcut..color = const Color(0xff666666));
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(
                headx + 12,
                endy +
                    baseKey.toothDepth[i] / zoom +
                    5 * (keyahtoothnum - i) -
                    6),
            10,
            const Color(0xff666666));
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(
                headx + 12,
                beginy -
                    baseKey.toothDepth[i] / zoom -
                    5 * (keyahtoothnum - i) -
                    6),
            10,
            const Color(0xff666666));

        drawLocat(canvas, headx, beginy + 20, headx, endy - 20);
        // paintcut.color = Colors.red;
        // canvas.drawLine(
        //     Offset(headx, beginy + 5), Offset(headx, endy - 5), paintcut);
      }
      //显示齿号
      for (var i = 0; i < tooth; i++) {
        if (i == cutsindex) {
          frontcolor = Colors.red;
        } else {
          frontcolor = const Color(0xff666666);
        }
        _showtext(
            canvas,
            baseKey.ahNums[i],
            Offset(headx - baseKey.toothSA[i] / zoom - 9, endy - 18),
            18,
            frontcolor);
        _showtext(
            canvas,
            baseKey.ahNums[i],
            Offset(headx - baseKey.toothSA[i] / zoom - 9, beginy + 18),
            18,
            frontcolor);
      }
    }
  }

//绘图平铣单边
  void drawSB1Key(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+



    ---------------------------
    
    */
    Color frontcolor = const Color(0xff666666);
    double beginx = 50;
    double beginy = 140; //代表肩膀宽度为1000丝
    double endy = beginy - 1000 / zoom; //代表肩膀宽度为1000丝
    double headx;
    double length;
    double locatx = beginx + 30; //肩膀位置x方向
    double locaty;
    int tooth = baseKey.toothSA.length;
    List<Offset> post = [];
    // List<Offset> post2 = [];
    // Rect rect;
    if (baseKey.locat == 0) {
      // length = baseKey.toothSA[tooth - 1] / zoom; //
      // double beginx = 50;
      // double beginy = 140; //代表肩膀宽度为1000丝
      length = baseKey.toothSA[tooth - 1] / zoom +
          baseKey.wide / zoom / 2 +
          20; //有一个尖头
      beginx = (_wide - length) / 2;
      endy = (_hight - baseKey.wide / zoom) / 2;
      beginy = endy + baseKey.wide / zoom;
      headx = beginx + length;
      locatx = beginx + 20;
      locaty = beginy + 10;
      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀
      post.add(Offset(beginx, locaty));
      post.add(Offset(locatx, locaty));
      post.add(Offset(locatx, beginy));

      // for (var i = 0; i < tooth; i++) {
      //   post.add(Offset(
      //       locatx + baseKey.toothSA[i] / zoom - 2, baseKey.ahNum[i] / zoom + endy));
      //   post.add(Offset(
      //       locatx + baseKey.toothSA[i] / zoom + 2, baseKey.ahNum[i] / zoom + endy));
      // }
      //  post.add(Offset(headx - baseKey.wide / zoom / 2, beginy));
      post.add(Offset(headx, beginy));
      post.add(Offset(headx, beginy - baseKey.wide / zoom / 2));
      //post.add(Offset(headx - baseKey.wide / zoom / 2, endy));
      for (var i = tooth - 1; i >= 0; i--) {
        post.add(Offset(locatx + baseKey.toothSA[i] / zoom + 2,
            beginy - baseKey.ahNum[i] / zoom));
        post.add(Offset(locatx + baseKey.toothSA[i] / zoom - 2,
            beginy - baseKey.ahNum[i] / zoom));
      }

      post.add(Offset(locatx, endy));
      post.add(Offset(locatx, endy - 10));
      post.add(Offset(beginx, endy - 10));
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
        // canvas.drawPoints(

        //     ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
        //     PointMode.polygon, //首尾相连
        //     //PointMode.lines, //两两相连
        //     //PointMode.points,//画点
        //     [
        //       Offset(locatx, baseKey.toothDepth[i] / zoom + endy),
        //       Offset(headx - 6 * i.toDouble(),
        //           baseKey.toothDepth[i] / zoom + endy),
        //       Offset(
        //           headx - 6 * i.toDouble(),
        //           i == 0
        //               ? baseKey.toothDepth[i] / zoom + endy
        //               : baseKey.toothDepth[i] / zoom - 5 * i + endy),
        //       Offset(
        //           headx,
        //           i == 0
        //               ? baseKey.toothDepth[i] / zoom + endy
        //               : baseKey.toothDepth[i] / zoom - 5 * i + endy),
        //     ],
        //     paintcut..color = const Color(0xff666666));

        //绘制上面的齿深线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(locatx, beginy - baseKey.toothDepth[i] / zoom),
              Offset(headx - 6 * (baseKey.toothDepth.length - i).toDouble(),
                  beginy - baseKey.toothDepth[i] / zoom),
              Offset(
                  headx - 6 * (baseKey.toothDepth.length - i).toDouble(),
                  i == baseKey.toothDepth.length - 1
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy -
                          baseKey.toothDepth[i] / zoom -
                          5 * (baseKey.toothDepth.length - i)),
              Offset(
                  headx,
                  i == baseKey.toothDepth.length - 1
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy -
                          baseKey.toothDepth[i] / zoom -
                          5 * (baseKey.toothDepth.length - i)),
            ],
            paintcut..color = const Color(0xff666666));
        // _showtext(
        //     canvas,
        //     baseKey.toothDepthName[i],
        //     Offset(locatx + baseKey.toothSA[tooth - 1] / zoom + 30 + 6,
        //         baseKey.toothDepth[i] / zoom - 5 * i - 6 + endy),
        //     10,
        //     const Color(0xff666666));
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(
                locatx + baseKey.toothSA[tooth - 1] / zoom + 30 + 6,
                beginy -
                    baseKey.toothDepth[i] / zoom -
                    5 * (baseKey.toothDepth.length - i) -
                    6),
            10,
            const Color(0xff666666));
        drawLocat(canvas, locatx, beginy + 20, locatx, endy - 20);
        // canvas.drawLine(
        //     Offset(locatx, beginy + 5), Offset(locatx, endy - 5), paintcut);
      }
      //显示齿号
      for (var i = 0; i < tooth; i++) {
        if (i == cutsindex) {
          frontcolor = Colors.red;
        } else {
          frontcolor = const Color(0xff666666);
        }
        // _showtext(
        //     canvas,
        //     baseKey.ahNums[i],
        //     Offset(locatx + baseKey.toothSA[i] / zoom - 9, endy - 18),
        //     18,
        //     frontcolor);
        _showtext(
            canvas,
            baseKey.ahNums[i],
            Offset(locatx + baseKey.toothSA[i] / zoom - 9, beginy + 18),
            18,
            frontcolor);
      }
    }
  }

//绘图立铣外沟单边
  void drawSB3Key(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+



    ---------------------------
    
    */
    Color frontcolor = const Color(0xff666666);
    double beginx = 50;
    double beginy = 140; //代表肩膀宽度为1000丝
    double endy = beginy - 1000 / zoom; //代表肩膀宽度为1000丝
    double headx;
    double length;
    double locatx = beginx + 30; //肩膀位置x方向
    double locaty;
    int tooth = baseKey.toothSA.length;
    List<Offset> post = [];
    //List<Offset> post2 = [];
    // Rect rect;

    if (baseKey.locat == 0) {
      // length = baseKey.toothSA[tooth - 1] / zoom; //
      // double beginx = 50;
      // double beginy = 140; //代表肩膀宽度为1000丝
      length = baseKey.toothSA[tooth - 1] / zoom +
          baseKey.wide / zoom / 2 +
          20; //有一个尖头
      beginx = (_wide - length) / 2;
      endy = (_hight - baseKey.wide / zoom) / 2;
      beginy = endy + baseKey.wide / zoom;
      headx = beginx + length;
      locatx = beginx + 20;
      locaty = beginy + 10;
      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀
      post.add(Offset(beginx, locaty));
      post.add(Offset(locatx, locaty));
      post.add(Offset(locatx, beginy));

      if (baseKey.side == 0) {
        for (var i = 0; i < tooth; i++) {
          post.add(Offset(locatx + baseKey.toothSA[i] / zoom - 2,
              baseKey.ahNum[i] / zoom + endy));
          post.add(Offset(locatx + baseKey.toothSA[i] / zoom + 2,
              baseKey.ahNum[i] / zoom + endy));
        }
        post.add(Offset(headx + 20, endy));
      } else {
        post.add(Offset(headx, beginy));
        for (var i = tooth - 1; i >= 0; i--) {
          post.add(Offset(locatx + baseKey.toothSA[i] / zoom + 2,
              beginy - baseKey.ahNum[i] / zoom));
          post.add(Offset(locatx + baseKey.toothSA[i] / zoom - 2,
              beginy - baseKey.ahNum[i] / zoom));
        }
      }
      post.add(Offset(locatx, endy));
      post.add(Offset(locatx, endy - 10));
      post.add(Offset(beginx, endy - 10));
      //  post.add(Offset(headx - baseKey.wide / zoom / 2, beginy));

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
      int ahtoothnum = baseKey.toothDepth.length;
      for (var i = 0; i < ahtoothnum; i++) {
        if (baseKey.side == 0) {
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(locatx, baseKey.toothDepth[i] / zoom + endy),
                Offset(headx - 6 * (ahtoothnum - i).toDouble(),
                    baseKey.toothDepth[i] / zoom + endy),
                Offset(
                    headx - 6 * (ahtoothnum - i).toDouble(),
                    i == (ahtoothnum - 1)
                        ? baseKey.toothDepth[i] / zoom + endy
                        : baseKey.toothDepth[i] / zoom +
                            5 * (ahtoothnum - i) +
                            endy),
                Offset(
                    headx,
                    i == (ahtoothnum - 1)
                        ? baseKey.toothDepth[i] / zoom + endy
                        : baseKey.toothDepth[i] / zoom +
                            5 * (ahtoothnum - i) +
                            endy),
              ],
              paintcut..color = const Color(0xff666666));
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(
                  locatx + baseKey.toothSA[tooth - 1] / zoom + 30 + 6,
                  baseKey.toothDepth[i] / zoom +
                      5 * (ahtoothnum - i) -
                      6 +
                      endy),
              10,
              const Color(0xff666666));
        } else {
          //绘制上面的齿深线
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(locatx, beginy - baseKey.toothDepth[i] / zoom),
                Offset(headx - 6 * (ahtoothnum - i).toDouble(),
                    beginy - baseKey.toothDepth[i] / zoom),
                Offset(
                    headx - 6 * (ahtoothnum - i).toDouble(),
                    i == (ahtoothnum - 1)
                        ? beginy - baseKey.toothDepth[i] / zoom
                        : beginy -
                            baseKey.toothDepth[i] / zoom -
                            5 * (ahtoothnum - i)),
                Offset(
                    headx,
                    i == (ahtoothnum - 1)
                        ? beginy - baseKey.toothDepth[i] / zoom
                        : beginy -
                            baseKey.toothDepth[i] / zoom -
                            5 * (ahtoothnum - i)),
              ],
              paintcut..color = const Color(0xff666666));
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(
                  locatx + baseKey.toothSA[tooth - 1] / zoom + 30 + 6,
                  beginy -
                      baseKey.toothDepth[i] / zoom -
                      5 * (ahtoothnum - i) -
                      6),
              10,
              const Color(0xff666666));
        }

        //  canvas.drawLine(
        //     Offset(locatx, beginy + 5), Offset(locatx, endy - 5), paintcut);
      }
      //显示齿号
      for (var i = 0; i < tooth; i++) {
        if (i == cutsindex) {
          frontcolor = Colors.red;
        } else {
          frontcolor = const Color(0xff666666);
        }
        if (baseKey.side == 0) {
          _showtext(
              canvas,
              baseKey.ahNums[i],
              Offset(locatx + baseKey.toothSA[i] / zoom - 9, endy - 18),
              18,
              frontcolor);
        } else {
          _showtext(
              canvas,
              baseKey.ahNums[i],
              Offset(locatx + baseKey.toothSA[i] / zoom - 9, beginy + 18),
              18,
              frontcolor);
        }
      }
      drawLocat(canvas, locatx, beginy + 20, locatx, endy - 20);
    } else {
      // length = baseKey.toothSA[tooth - 1] / zoom; //
      // double beginx = 50;
      // double beginy = 140; //代表肩膀宽度为1000丝
      length = baseKey.toothSA[0] / zoom + baseKey.wide / zoom; //有一个尖头
      beginx = (_wide - length) / 2;
      endy = (_hight - baseKey.wide / zoom) / 2;
      beginy = endy + baseKey.wide / zoom;
      headx = beginx + length;
      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀
      post.add(Offset(beginx, beginy));
      if (baseKey.side == 0) {
        post.add(Offset(
            headx -
                baseKey.toothSA[0] / zoom -
                2 -
                (beginy - (baseKey.ahNum[0] / zoom + endy)),
            beginy));
        for (var i = 0; i < tooth; i++) {
          post.add(Offset(headx - baseKey.toothSA[i] / zoom - 2,
              baseKey.ahNum[i] / zoom + endy));
          post.add(Offset(headx - baseKey.toothSA[i] / zoom + 2,
              baseKey.ahNum[i] / zoom + endy));
        }

        //  post.add(Offset(headx - baseKey.wide / zoom / 2, beginy));
        post.add(Offset(headx, endy));
        //post.add(Offset(headx - baseKey.wide / zoom / 2, endy));

      } else {
        post.add(Offset(headx, beginy));
        for (var i = tooth - 1; i >= 0; i--) {
          post.add(Offset(headx - baseKey.toothSA[i] / zoom + 2,
              beginy - baseKey.ahNum[i] / zoom));
          post.add(Offset(headx - baseKey.toothSA[i] / zoom - 2,
              beginy - baseKey.ahNum[i] / zoom));
        }
        post.add(Offset(
            headx -
                baseKey.toothSA[0] / zoom -
                2 -
                (beginy - baseKey.ahNum[0] / zoom - endy),
            endy));
      }
      post.add(Offset(beginx, endy));
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

      int ahtoothnum = baseKey.toothDepth.length;
      for (var i = 0; i < ahtoothnum; i++) {
        if (baseKey.side == 0) {
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(locatx, baseKey.toothDepth[i] / zoom + endy),
                Offset(headx - 6 * (ahtoothnum - i).toDouble(),
                    baseKey.toothDepth[i] / zoom + endy),
                Offset(
                    headx - 6 * (ahtoothnum - i).toDouble(),
                    i == ahtoothnum - 1
                        ? baseKey.toothDepth[i] / zoom + endy
                        : baseKey.toothDepth[i] / zoom +
                            5 * (ahtoothnum - i) +
                            endy),
                Offset(
                    headx + 4,
                    i == ahtoothnum - 1
                        ? baseKey.toothDepth[i] / zoom + endy
                        : baseKey.toothDepth[i] / zoom +
                            5 * (ahtoothnum - i) +
                            endy),
              ],
              paintcut..color = const Color(0xff666666));
          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(
                  headx + 10,
                  baseKey.toothDepth[i] / zoom +
                      5 * (ahtoothnum - i) -
                      6 +
                      endy),
              10,
              const Color(0xff666666));
          //显示齿号
          for (var i = 0; i < tooth; i++) {
            if (i == cutsindex) {
              frontcolor = Colors.red;
            } else {
              frontcolor = const Color(0xff666666);
            }
            _showtext(
                canvas,
                baseKey.ahNums[i],
                Offset(headx - baseKey.toothSA[i] / zoom - 9, endy - 18),
                18,
                frontcolor);
          }
        }
        //绘制上面的齿深线
        else {
          canvas.drawPoints(

              ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
              PointMode.polygon, //首尾相连
              //PointMode.lines, //两两相连
              //PointMode.points,//画点
              [
                Offset(locatx, beginy - baseKey.toothDepth[i] / zoom),
                Offset(headx - 6 * (ahtoothnum - i).toDouble(),
                    beginy - baseKey.toothDepth[i] / zoom),
                Offset(
                    headx - 6 * (ahtoothnum - i).toDouble(),
                    i == ahtoothnum - 1
                        ? beginy - baseKey.toothDepth[i] / zoom
                        : beginy -
                            baseKey.toothDepth[i] / zoom -
                            5 * (ahtoothnum - i)),
                Offset(
                    headx + 4,
                    i == ahtoothnum - 1
                        ? beginy - baseKey.toothDepth[i] / zoom
                        : beginy -
                            baseKey.toothDepth[i] / zoom -
                            5 * (ahtoothnum - i)),
              ],
              paintcut..color = const Color(0xff666666));

          _showtext(
              canvas,
              baseKey.toothDepthName[i],
              Offset(
                  headx + 6,
                  beginy -
                      baseKey.toothDepth[i] / zoom -
                      5 * (ahtoothnum - i) -
                      6),
              10,
              const Color(0xff666666));

          //显示齿号
          for (var i = 0; i < tooth; i++) {
            if (i == cutsindex) {
              frontcolor = Colors.red;
            } else {
              frontcolor = const Color(0xff666666);
            }

            _showtext(
                canvas,
                baseKey.ahNums[i],
                Offset(headx - baseKey.toothSA[i] / zoom - 9, beginy + 18),
                18,
                frontcolor);
          }
        }

        // canvas.drawLine(
        //     Offset(headx, beginy + 5), Offset(headx, endy - 5), paintcut);
      }
      drawLocat(canvas, headx, beginy + 20, headx, endy - 20);
    }
  }

// 立铣外沟双边
  void drawSB4Key(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+

    B

    A
    ---------------------------
    
    */
    // Color frontcolor = const Color(0xff666666);
    double beginx = 50;
    double beginy = 140; //代表肩膀宽度为1000丝
    double endy = beginy - 1000 / zoom; //代表肩膀宽度为1000丝
    double headx;
    double length;
    double locatx = beginx + 30; //肩膀位置x方向
    double locaty;
    int atooth = baseKey.sideAtooth;
    int btooth = baseKey.sideBtooth;
    List<Offset> post = [];
    // List<Offset> post2 = [];
    // Rect rect;
    if (baseKey.locat == 0) {
      // length = baseKey.toothSA[tooth - 1] / zoom; //
      // double beginx = 50;
      // double beginy = 140; //代表肩膀宽度为1000丝
      length = ((baseKey.toothSA[atooth - 1] > baseKey.toothSB[btooth - 1])
                  ? baseKey.toothSA[atooth - 1]
                  : baseKey.toothSB[btooth - 1]) /
              zoom +
          baseKey.wide / zoom; //有一个尖头
      beginx = (_wide - length) / 2;
      endy = (_hight - baseKey.wide / zoom) / 2;
      beginy = endy + baseKey.wide / zoom;
      headx = beginx + length;
      locatx = beginx + 20;
      locaty = beginy + 10;
      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀

      post.add(Offset(beginx, locaty));
      post.add(Offset(locatx, locaty));
      post.add(Offset(locatx, beginy));

      for (var i = 0; i < btooth; i++) {
        post.add(Offset(locatx + baseKey.toothSB[i] / zoom - 2,
            baseKey.bhNum[i] / zoom + endy));
        post.add(Offset(locatx + baseKey.toothSB[i] / zoom + 2,
            baseKey.bhNum[i] / zoom + endy));
      }
      //  post.add(Offset(headx - baseKey.wide / zoom / 2, beginy));
      post.add(Offset(headx, beginy - baseKey.wide / zoom / 2));
      //post.add(Offset(headx - baseKey.wide / zoom / 2, endy));
      for (var i = atooth - 1; i >= 0; i--) {
        post.add(Offset(locatx + baseKey.toothSA[i] / zoom + 2,
            beginy - baseKey.ahNum[i] / zoom));
        post.add(Offset(locatx + baseKey.toothSA[i] / zoom - 2,
            beginy - baseKey.ahNum[i] / zoom));
      }

      post.add(Offset(locatx, endy));
      post.add(Offset(locatx, endy - 10));
      post.add(Offset(beginx, endy - 10));
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
      int hnum = baseKey.toothDepth.length;
      for (var i = 0; i < hnum; i++) {
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(locatx, baseKey.toothDepth[i] / zoom + endy),
              Offset(headx + 6 - 6 * (hnum - 1 - i).toDouble(),
                  baseKey.toothDepth[i] / zoom + endy),
              Offset(
                  headx + 6 - 6 * (hnum - 1 - i).toDouble(),
                  i == hnum - 1 - i
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom +
                          5 * (hnum - 1 - i) +
                          endy),
              Offset(
                  headx + 6,
                  i == hnum - 1
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom +
                          5 * (hnum - 1 - i) +
                          endy),
            ],
            paintcut..color = const Color(0xff666666));

        //绘制上面的齿深线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(locatx, beginy - baseKey.toothDepth[i] / zoom),
              Offset(headx + 6 - 6 * (hnum - 1 - i).toDouble(),
                  beginy - baseKey.toothDepth[i] / zoom),
              Offset(
                  headx + 6 - 6 * (hnum - 1 - i).toDouble(),
                  i == hnum - 1
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy -
                          baseKey.toothDepth[i] / zoom -
                          5 * (hnum - 1 - i)),
              Offset(
                  headx + 6,
                  i == hnum - 1
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy -
                          baseKey.toothDepth[i] / zoom -
                          5 * (hnum - 1 - i)),
            ],
            paintcut..color = const Color(0xff666666));
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(headx + 6,
                baseKey.toothDepth[i] / zoom - 5 * i + 3 * hnum + endy),
            10,
            const Color(0xff666666));
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(headx + 6,
                beginy - baseKey.toothDepth[i] / zoom + 5 * i - 5 * hnum),
            10,
            const Color(0xff666666));
        // canvas.drawLine(
        //     Offset(locatx, beginy + 5), Offset(locatx, endy - 5), paintcut);
      }
      //显示齿号
      ////print("cutsindex:$cutsindex");
      for (var i = 0; i < btooth; i++) {
        _showtext(
            canvas,
            baseKey.bhNums[i],
            Offset(locatx + baseKey.toothSB[i] / zoom - 9, beginy + 18),
            18,
            i == cutsindex - atooth ? Colors.red : const Color(0xff666666));
      }
      for (var i = 0; i < atooth; i++) {
        _showtext(
            canvas,
            baseKey.ahNums[i],
            Offset(locatx + baseKey.toothSA[i] / zoom - 9, endy - 18),
            18,
            i == cutsindex ? Colors.red : const Color(0xff666666));
      }
      drawLocat(canvas, locatx, beginy + 20, locatx, endy - 20);
    } else {
      //对头
      // length = baseKey.toothSA[tooth - 1] / zoom; //
      // double beginx = 50;
      // double beginy = 140; //代表肩膀宽度为1000丝
      length = baseKey.toothSA[0] / zoom + baseKey.wide / zoom / 2; //有一个尖头
      beginx = (_wide - length) / 2;
      endy = (_hight - baseKey.wide / zoom) / 2;
      beginy = endy + baseKey.wide / zoom;
      headx = beginx + length;

      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀
      post.add(Offset(beginx, beginy));
      post.add(Offset(
          headx -
              baseKey.toothSB[0] / zoom -
              2 -
              (beginy - (baseKey.bhNum[0] / zoom + endy)),
          beginy));
      for (var i = 0; i < btooth; i++) {
        post.add(Offset(headx - baseKey.toothSB[i] / zoom - 2,
            baseKey.bhNum[i] / zoom + endy));
        post.add(Offset(headx - baseKey.toothSB[i] / zoom + 2,
            baseKey.bhNum[i] / zoom + endy));
      }
      //  post.add(Offset(headx - baseKey.wide / zoom / 2, beginy));
      post.add(Offset(headx, beginy - baseKey.wide / zoom / 2));
      //post.add(Offset(headx - baseKey.wide / zoom / 2, endy));
      for (var i = atooth - 1; i >= 0; i--) {
        post.add(Offset(headx - baseKey.toothSA[i] / zoom + 2,
            beginy - baseKey.ahNum[i] / zoom));
        post.add(Offset(headx - baseKey.toothSA[i] / zoom - 2,
            beginy - baseKey.ahNum[i] / zoom));
      }
      post.add(Offset(
          headx -
              baseKey.toothSA[0] / zoom -
              2 -
              (beginy - baseKey.ahNum[0] / zoom - endy),
          endy));
      post.add(Offset(beginx, endy));
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
      int hnum = baseKey.toothDepth.length;
      for (var i = 0; i < hnum; i++) {
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(locatx, baseKey.toothDepth[i] / zoom + endy),
              Offset(headx + 6 - 6 * (hnum - 1 - i).toDouble(),
                  baseKey.toothDepth[i] / zoom + endy),
              Offset(
                  headx + 6 - 6 * (hnum - 1 - i).toDouble(),
                  i == hnum - 1 - i
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom +
                          5 * (hnum - 1 - i) +
                          endy),
              Offset(
                  headx + 6,
                  i == hnum - 1
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom +
                          5 * (hnum - 1 - i) +
                          endy),
            ],
            paintcut..color = const Color(0xff666666));

        //绘制上面的齿深线
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(locatx, beginy - baseKey.toothDepth[i] / zoom),
              Offset(headx + 6 - 6 * (hnum - 1 - i).toDouble(),
                  beginy - baseKey.toothDepth[i] / zoom),
              Offset(
                  headx + 6 - 6 * (hnum - 1 - i).toDouble(),
                  i == hnum - 1
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy -
                          baseKey.toothDepth[i] / zoom -
                          5 * (hnum - 1 - i)),
              Offset(
                  headx + 6,
                  i == hnum - 1
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy -
                          baseKey.toothDepth[i] / zoom -
                          5 * (hnum - 1 - i)),
            ],
            paintcut..color = const Color(0xff666666));
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(headx + 6,
                baseKey.toothDepth[i] / zoom - 5 * i + 3 * hnum + endy),
            10,
            const Color(0xff666666));
        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(headx + 6,
                beginy - baseKey.toothDepth[i] / zoom + 5 * i - 5 * hnum),
            10,
            const Color(0xff666666));
      }
      //显示齿号

      for (var i = 0; i < btooth; i++) {
        _showtext(
            canvas,
            baseKey.bhNums[i],
            Offset(headx - baseKey.toothSB[i] / zoom - 9, beginy + 18),
            18,
            i == cutsindex - atooth ? Colors.red : const Color(0xff666666));
      }
      for (var i = 0; i < atooth; i++) {
        _showtext(
            canvas,
            baseKey.ahNums[i],
            Offset(headx - baseKey.toothSA[i] / zoom - 9, endy - 18),
            18,
            i == cutsindex ? Colors.red : const Color(0xff666666));
      }
      drawLocat(canvas, headx, beginy + 20, headx, endy - 20);
    }
  }

//FO21
  void drawSB7Key(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+

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

    ---------------------------
    
    */
    Color frontcolor = const Color(0xff666666);
    //zoom = 6;

    double cX = (_wide - baseKey.toothSA[0] / zoom) / 2;
    double cY = (_hight - baseKey.wide / zoom) / 2 + baseKey.wide / zoom;
    double aX = cX - 50;
    double aY = cY - 10;
    double bX = cX;
    double bY = aY;
    double dX = cX + baseKey.toothSA[0] / zoom + 20;
    double dY = cY;
    double fX = dX;
    double fY = dY - baseKey.wide / zoom;
    double gX = cX;
    double gY = fY;
    double hX = gX;
    double hY = gY + 10;
    // double iX = gX;
    // double iY = aX;

    int tooth = baseKey.toothSA.length;
    List<Offset> post = [];
    // List<Offset> post2 = [];
    // Rect rect;
    {
      // length = baseKey.toothSA[tooth - 1] / zoom; //
      // double beginx = 50;
      // double beginy = 140; //代表肩膀宽度为1000丝
      // length =
      //     baseKey.toothSA[0] / zoom + baseKey.wide / zoom / 2; //有一个尖头
      // beginx = (_wide - length) / 2;
      // endy = (_hight - baseKey.wide / zoom) / 2;
      // beginy = endy + baseKey.wide / zoom;
      // headx = beginx + length;

      //肩膀画法
      //判断对齐方式 对肩膀
      //根据齿号生成轨迹
      //先画肩膀
      post.add(Offset(aX, aY));
      post.add(Offset(bX, bY));
      post.add(Offset(cX, cY));
      for (var i = 0; i < tooth; i++) {
        post.add(Offset(dX - baseKey.toothSA[i] / zoom - 2,
            cY - baseKey.ahNum[i] / 20 / zoom));
        post.add(Offset(dX - baseKey.toothSA[i] / zoom + 2,
            cY - baseKey.ahNum[i] / 20 / zoom));
      }
      post.add(Offset(dX, dY));
      post.add(Offset(fX, fY));

      for (var i = tooth - 1; i >= 0; i--) {
        post.add(Offset(dX - baseKey.toothSA[i] / zoom + 2,
            baseKey.ahNum[i] / 20 / zoom + fY));
        post.add(Offset(dX - baseKey.toothSA[i] / zoom - 2,
            baseKey.ahNum[i] / 20 / zoom + fY));
      }
      post.add(Offset(gX, gY));
      post.add(Offset(hX, hY));
      post.add(Offset(aX, hY));
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));

      //显示齿号
      for (var i = 0; i < tooth; i++) {
        if (i == cutsindex) {
          frontcolor = Colors.red;
        } else {
          frontcolor = const Color(0xff666666);
        }
        _showtext(
            canvas,
            baseKey.ahNums[i],
            Offset(dX - baseKey.toothSA[i] / zoom - 9, gY - 18),
            18,
            frontcolor);
        _showtext(
            canvas,
            baseKey.ahNums[i],
            Offset(dX - baseKey.toothSA[i] / zoom - 9, cY + 18),
            18,
            frontcolor);
      }
    }
  }

//绘图立铣内沟单边 4轨迹
  void drawSB13Key(Canvas canvas) {
    /* 画布方向 左上角为零点
    ---------------------------
    (0,0) ->x+
    ↓
    y+



    ---------------------------
    
    */
    zoom = 9;
    Color frontcolor = const Color(0xff666666);
    double beginx = 50;
    double beginy = 140; //代表肩膀宽度为1000丝
    double endy = beginy - 1000 / zoom; //代表肩膀宽度为1000丝
    double headx;
    double length;
    // double locatx = beginx + 30; //肩膀位置x方向
    //double locaty;
    int tooth = baseKey.toothSA.length;
    List<Offset> post = [];
    List<Offset> post2 = [];
    Rect rect;
    {
      length = baseKey.toothSA[0] / zoom + 20;
      beginx = (_wide - length) / 2;
      endy = (_hight - baseKey.wide / zoom) / 2;
      beginy = endy + baseKey.wide / zoom;
      headx = beginx + length;
      // beginx = 50;
      // endy = 40;
      // headx = beginx + baseKey.toothSA[0] / zoom + 10;
      // beginy = (40 + baseKey.wide / zoom).toDouble(); //起始点Y的坐标

      //根据齿号生成轨迹

      post.add(Offset(beginx, beginy));
      post.add(Offset(headx, beginy));
      //先画一边的齿号 准备钥匙数据
      for (var i = tooth - 1; i >= 0; i--) {
        post.add(Offset(headx - baseKey.toothSA[i] / zoom + 2,
            beginy - baseKey.bhNum[i] / zoom));
        post.add(Offset(headx - baseKey.toothSA[i] / zoom - 2,
            beginy - baseKey.bhNum[i] / zoom));
      }
      //在画另一边的齿号
      for (var i = 0; i < tooth; i++) {
        post2.add(Offset(headx - baseKey.toothSA[i] / zoom - 2,
            endy + baseKey.ahNum[i] / zoom));
        post2.add(Offset(headx - baseKey.toothSA[i] / zoom + 2,
            endy + baseKey.ahNum[i] / zoom));
      }
      //画钥匙的另一边
      post2.add(Offset(headx,
          ((beginy - endy) / 2 - baseKey.wide / zoom / 2 + endy).toDouble()));
      post2.add(Offset(beginx, endy));

      //画钥匙轮廓
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post,
          paintline..color = const Color(0xff384c70));
      //画钥匙另一边
      canvas.drawPoints(

          ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
          PointMode.polygon, //首尾相连
          //PointMode.lines, //两两相连
          //PointMode.points,//画点
          post2,
          paintline..color = const Color(0xff384c70));
      //画尾部的圆心
      rect = Rect.fromCircle(
          center:
              Offset(post2[0].dx, (post[post.length - 1].dy + post2[0].dy) / 2),
          radius: baseKey.groove / zoom / 2);
      canvas.drawArc(rect, 2 * pi / 4, 2 * pi / 2, false, paintline);

      //绘制齿深线
      //每个字体的大小都是12*12所以 共计需要的区域为12*12*齿深的个数
      //例如HU66 12*12*4

      //上齿
      //var j = baseKey.toothDepth.length - 1;
      for (var i = 5; i < baseKey.toothDepth.length; i++) {
        //   j = j - i;
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(beginx, baseKey.toothDepth[i] / zoom + endy),
              Offset(headx + 18 - 6 * (i - 5).toDouble(),
                  baseKey.toothDepth[i] / zoom + endy),
              Offset(
                  headx + 18 - 6 * (i - 5).toDouble(),
                  i == 5
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom + endy - 6),
              Offset(
                  headx + 30,
                  i == 5
                      ? baseKey.toothDepth[i] / zoom + endy
                      : baseKey.toothDepth[i] / zoom + endy - 6),
            ],
            paintcut..color = const Color(0xff666666));

        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(i == 9 ? headx + 30 + 18 : headx + 30 + 6,
                baseKey.toothDepth[i] / zoom + endy - 6 - 6),
            12,
            const Color(0xff666666));
      }
      //下齿号
      //画齿深线条

      for (var i = 0; i < baseKey.toothDepth.length / 2; i++) {
        canvas.drawPoints(

            ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
            PointMode.polygon, //首尾相连
            //PointMode.lines, //两两相连
            //PointMode.points,//画点
            [
              Offset(beginx, beginy - baseKey.toothDepth[i] / zoom),
              Offset(headx + 6 * i.toDouble(),
                  beginy - baseKey.toothDepth[i] / zoom),
              Offset(
                  headx + 6 * i.toDouble(),
                  i == baseKey.toothDepth.length / 2 - 1
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy - baseKey.toothDepth[i] / zoom + 6),
              Offset(
                  headx + 30,
                  i == baseKey.toothDepth.length / 2 - 1
                      ? beginy - baseKey.toothDepth[i] / zoom
                      : beginy - baseKey.toothDepth[i] / zoom + 6),
            ],
            paintcut..color = const Color(0xff666666));

        _showtext(
            canvas,
            baseKey.toothDepthName[i],
            Offset(
                i == 1 ? headx + 30 + 16 : headx + 30 + 6,
                i == baseKey.toothDepth.length / 2 - 1
                    ? beginy - baseKey.toothDepth[i] / zoom - 6
                    : beginy - baseKey.toothDepth[i] / zoom + 5 - 6),
            12,
            const Color(0xff666666));
      }

      //画定位线
      // canvas.drawLine(
      //     Offset(headx, beginy + 5), Offset(headx, endy - 5), paintcut);
      //显示齿号
      for (var i = 0; i < tooth; i++) {
        if (i == cutsindex) {
          frontcolor = Colors.red;
        } else {
          frontcolor = const Color(0xff666666);
        }
        _showtext(
            canvas,
            baseKey.ahNums[i],
            Offset(headx - baseKey.toothSA[i] / zoom - 9, endy - 18),
            18,
            frontcolor);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // print("画布高度");
    // print(size.height);
    // print("画布宽度");
    // print(size.width);
    _wide = size.width;
    _hight = size.height;
    zoom = (baseKey.wide ~/ (_hight - 150));
    var zoom2 = 0;
    if (baseKey.locat == 0) {
      zoom2 =
          ((baseKey.toothSA[baseKey.cuts - 1] + baseKey.wide) ~/ (_wide - 150));
    } else {
      zoom2 = ((baseKey.toothSA[0] + baseKey.wide) ~/ (_wide - 150));
    }
    zoom = zoom > zoom2 ? zoom : zoom2;
    debugPrint("zoom:$zoom");
    if (zoom < 12) zoom = 12;
    switch (baseKey.keyClass) {
      case 0: //平铣双边

        drawSB0Key(canvas);
        break;
      case 1: //平铣单边
        drawSB1Key(canvas);
        break;
      case 2: //立铣内沟双边
        // //print("立铣内沟双边");
        drawSB2Key(canvas);
        break;
      case 3: //立铣外沟单边
        drawSB3Key(canvas);
        break;
      case 4: //立铣外沟双边
        drawSB4Key(canvas);
        break;
      case 5: //立铣内沟单边
        drawSB5Key(canvas);
        break;
      case 6:
        break;
      case 7: //fo21:
        drawSB7Key(canvas);
        break;
      case 8:
        break;
      case 13:
        drawSB13Key(canvas);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
