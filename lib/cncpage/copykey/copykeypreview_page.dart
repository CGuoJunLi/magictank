import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
//import 'package:magictank/cncpage/createkeYdata.dart';

class CopyPainter extends CustomPainter {
  Map keydata;
  int zoom = 12; //缩放倍数
  List<int> ahNum = [];
  List<int> bhNum = [];
  late double _wide;
  late double _hight;

  CopyPainter(
    this.keydata,
    this.ahNum,
    this.bhNum,
  );

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

  // _showtext(Canvas canvas, String string, Offset offset, double frontsize,
  //     Color frontcolor) {
  //   var teXtPainter = TextPainter(
  //     text: TextSpan(
  //         text: string,
  //         style: TextStyle(color: frontcolor, fontSize: frontsize)),
  //     textDirection: TextDirection.rtl,
  //     textWidthBasis: TextWidthBasis.longestLine,
  //     maxLines: 2,
  //   )..layout();

  //   teXtPainter.paint(canvas, offset);
  // }

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
    //Color frontcolor = Colors.blue;
    int tooth = ahNum.length;
    int keYlength = ahNum.length * 20; //钥匙长度
    double aX = (_wide - keYlength / zoom) / 2 - 20;
    double aY = _hight / 2 + ahNum[0] / zoom + 20;
    double bX = (_wide - keYlength / zoom) / 2;
    double bY = _hight / 2 + ahNum[0] / zoom + 20;
    double cX = (_wide - keYlength / zoom) / 2;
    double cY = _hight / 2 + ahNum[0] / zoom;
    double eX = cX + keYlength / zoom;
    double eY = _hight / 2;
    double gX = cX;
    double gY = _hight / 2 - bhNum[0] / zoom;
    double hX = gX;
    double hY = gY - 20;
    double iX = hX - 20;
    double iY = hY;

    List<Offset> post = [];
    //List<Offset> post2 = [];
    //Rect rect;
    if (keydata["locat"] == 0) {
      // length = keYdata["toothSA"][tooth - 1] / zoom; //
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
        post.add(Offset(cX + i * 20 / zoom - 2, eY + ahNum[i] / zoom));
        post.add(Offset(cX + i * 20 / zoom + 2, eY + ahNum[i] / zoom));
      }
      //  post.add(Offset(headx - keYdata["wide"] / zoom / 2, beginy));
      post.add(Offset(eX, eY));
      //post.add(Offset(headx - keYdata["wide"] / zoom / 2, endy));
      int j = 0;
      for (var i = tooth - 1; i >= 0; i--) {
        post.add(Offset(eX - j * 20 / zoom + 2, eY - bhNum[i] / zoom));
        post.add(Offset(eX - j * 20 / zoom - 2, eY - bhNum[i] / zoom));
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
      // length = keYdata["toothSA"][tooth - 1] / zoom; //
      // double beginx = 50;
      // double beginy = 140; //代表肩膀宽度为1000丝

      post.add(Offset(cX, cY));

      for (var i = 0; i < tooth; i++) {
        post.add(Offset(cX + i * 20 / zoom - 2, eY + ahNum[i] / zoom));
        post.add(Offset(cX + i * 20 / zoom + 2, eY + ahNum[i] / zoom));
      }
      //  post.add(Offset(headx - keYdata["wide"] / zoom / 2, beginy));
      post.add(Offset(eX, eY));
      //post.add(Offset(headx - keYdata["wide"] / zoom / 2, endy));
      // for (var i = tooth - 1; i >= 0; i--) {
      //   post.add(Offset(eX - i * 20 / zoom + 2, eY - bhNum[i] / zoom));
      //   post.add(Offset(eX - i * 20 / zoom - 2, eY - bhNum[i] / zoom));
      // }
      for (var i = tooth - 1; i >= 0; i--) {
        post.add(Offset(cX + i * 20 / zoom - 2, eY - bhNum[i] / zoom));
        post.add(Offset(cX + i * 20 / zoom + 2, eY - bhNum[i] / zoom));
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
    // double aX;
    //double aY;
    // double bX;
    // double bY;
    double cX;
    double cY;
    // double eX;
    double eY;
    double gX;
    //double gY;
    //double hX;
    // double hY;
    // double iX;
    //double iY;
    if (keydata["side"] == 0) {
      tooth = ahNum.length;
      keYlength = ahNum.length * 20; //钥匙长度
      // aX = (_wide - keYlength / zoom) / 2 - 20;
      // aY = _hight / 2 + ahNum[0] / zoom + 20;
      // bX = (_wide - keYlength / zoom) / 2;
      //  bY = _hight / 2 + ahNum[0] / zoom + 20;
      cX = (_wide - keYlength / zoom) / 2;
      cY = _hight / 2 + ahNum[0] / zoom;
      //  eX = cX + keYlength / zoom;
      eY = _hight / 2;
      gX = cX;
      //  gY = _hight / 2 - ahNum[0] / zoom;
      //  hX = gX;
      //  hY = gY - 20;
      //  iX = hX - 20;
      // iY = hY;
    } else {
      tooth = bhNum.length;
      keYlength = bhNum.length * 20; //钥匙长度
      // aX = (_wide - keYlength / zoom) / 2 - 20;
      // aY = _hight / 2 + bhNum[0] / zoom + 20;
      // bX = (_wide - keYlength / zoom) / 2;
      //  bY = _hight / 2 + bhNum[0] / zoom + 20;
      cX = (_wide - keYlength / zoom) / 2;
      cY = _hight / 2 + bhNum[0] / zoom;
      // eX = cX + keYlength / zoom;
      eY = _hight / 2;
      gX = cX;
      // gY = _hight / 2 - bhNum[0] / zoom;
      // hX = gX;
      // hY = gY - 20;
      // iX = hX - 20;
      //iY = hY;
    }
    List<Offset> post = [];
    // List<Offset> post2 = [];
    // Rect rect;

    // length = keYdata["toothSA"][tooth - 1] / zoom; //
    // double beginx = 50;
    // double beginy = 140; //代表肩膀宽度为1000丝
    if (keydata["side"] == 0) {
      post.add(Offset(cX, cY));

      for (var i = 0; i < tooth; i++) {
        post.add(Offset(cX + i * 20 / zoom - 2, eY + ahNum[i] / zoom));
        post.add(Offset(cX + i * 20 / zoom + 2, eY + ahNum[i] / zoom));
      }
      post.add(Offset(gX, eY + ahNum[tooth - 1] / zoom));
    } else {
      for (var i = 0; i < tooth; i++) {
        post.add(Offset(cX + i * 20 / zoom - 2, eY - bhNum[i] / zoom));
        post.add(Offset(cX + i * 20 / zoom + 2, eY - bhNum[i] / zoom));
      }
      post.add(Offset(cX, eY + bhNum[tooth - 1] / zoom));
    }
    canvas.drawPoints(

        ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
        PointMode.polygon, //首尾相连
        //PointMode.lines, //两两相连
        //PointMode.points,//画点
        post,
        paintline..color = Colors.blueAccent);
  }

//绘图立铣内沟
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
    int tooth = ahNum.length;
    int keYlength = ahNum.length * 20; //钥匙长度
    //double aX = (_wide - keYlength / zoom) / 2 - 20;
    // double aY = _hight / 2 + ahNum[0] / zoom + 20;
    // double bX = (_wide - keYlength / zoom) / 2;
    // double bY = _hight / 2 + ahNum[0] / zoom + 20;
    double cX = (_wide - keYlength / zoom) / 2;
    double cY = _hight / 2 + ahNum[0] / zoom;
    // double eX = cX + keYlength / zoom;
    // double eY = _hight / 2;
    double gX = cX;
    double gY = cY - (ahNum[0] + bhNum[0] + 300) / zoom;
    // double hX = gX;
    // double hY = gY - 20;
    //double iX = hX - 20;
    // double iY = hY;

    List<Offset> post = [];
    List<Offset> post2 = [];
    Rect rect;

    // length = keYdata["toothSA"][tooth - 1] / zoom; //
    // double beginx = 50;
    // double beginy = 140; //代表肩膀宽度为1000丝

    for (var i = 0; i < tooth; i++) {
      post.add(Offset(cX + i * 20 / zoom - 2, cY - ahNum[i] / zoom));
      post.add(Offset(cX + i * 20 / zoom + 2, cY - ahNum[i] / zoom));
    }
    post.add(Offset(cX + (tooth - 1) * 20 / zoom + 2, cY));
    post.add(Offset(cX, cY));
    canvas.drawPoints(

        ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
        PointMode.polygon, //首尾相连
        //PointMode.lines, //两两相连
        //PointMode.points,//画点
        post,
        paintline..color = Colors.blueAccent);

    for (var i = 0; i < tooth; i++) {
      post2.add(Offset(cX + i * 20 / zoom - 2, gY + bhNum[i] / zoom));
      post2.add(Offset(cX + i * 20 / zoom + 2, gY + bhNum[i] / zoom));
    }
    post2.add(Offset(cX + (tooth - 1) * 20 / zoom + 2, gY));
    post2.add(Offset(gX, gY));
    canvas.drawPoints(

        ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
        PointMode.polygon, //首尾相连
        //PointMode.lines, //两两相连
        //PointMode.points,//画点
        post2,
        paintline..color = Colors.blueAccent);

    if (keydata["class"] == 5) {
      rect = Rect.fromCircle(
          center: Offset(post2[0].dx, (post[0].dy + post2[0].dy) / 2),
          radius: 300 / zoom / 2);
      canvas.drawArc(rect, 2 * pi / 4, 2 * pi / 2, false, paintline);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint("画布高度");
    ////print(size.height);
    // debugPrint("画布宽度");
    // //print(size.width);
    _wide = size.width;
    _hight = size.height;
    switch (keydata["class"]) {
      case 0: //平铣双边
        drawSB0KeY(canvas);
        break;
      case 1: //平铣单边
        // //print(ahNum);
        ////print(bhNum);
        ////print(keYdata["side"]);
        ////print(keYdata["locat"]);
        ////print(ahNum.length);
        ////print(bhNum.length);
        drawSB3KeY(canvas);
        break;
      case 2: //立铣内沟双边
        debugPrint("立铣内沟双边");
        drawSB5KeY(canvas);
        break;
      case 3: //立铣外沟单边
        debugPrint("立铣外沟单边");
        // //print(ahNum);
        // //print(bhNum);
        // //print(keYdata["side"]);
        // //print(keYdata["locat"]);
        // //print(ahNum.length);
        // //print(bhNum.length);
        drawSB3KeY(canvas);
        break;
      case 4: //立铣外沟双边
        drawSB0KeY(canvas);
        break;
      case 5: //立铣内沟单边
        drawSB5KeY(canvas);
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
