import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget myContainer(double w, double h, double colorh, String title,
    String imagePath, EdgeInsetsGeometry padding,
    {bool assetimage = false}) {
  return Container(
    width: w,
    height: h,
    margin: padding, //外边距
    decoration: BoxDecoration(
        color: const Color(0xff384c70),
        borderRadius: BorderRadius.circular(13.0)),
    child: Column(
      children: [
        SizedBox(
          height: colorh,
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 13.sp),
            ),
          ),
        ),
        Expanded(
            child: Container(
          width: double.maxFinite,
          color: Colors.white,
          child: assetimage
              ? Image.asset(
                  imagePath,
                  //  fit: BoxFit.cover,
                )
              : Image.file(
                  File(imagePath),
                  // fit: BoxFit.cover,
                ),
        ))
      ],
    ),
  );
}

//eclone
Widget myContainerBox(
    double w, double h, double colorh, String title, Widget body,
    {bool assetimage = false, EdgeInsetsGeometry padding = EdgeInsets.zero}) {
  return Container(
    width: w,
    height: h,
    margin: padding,
    decoration: BoxDecoration(
        color: const Color(0xff50c5c4),
        borderRadius: BorderRadius.circular(13.0)),
    child: Column(
      children: [
        SizedBox(
          height: colorh,
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 13.sp),
            ),
          ),
        ),
        Expanded(
            child: Container(
          width: double.maxFinite,
          color: Colors.white,
          child: body,
        ))
      ],
    ),
  );
}
