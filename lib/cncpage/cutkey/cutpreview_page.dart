import 'package:flutter/material.dart';
import 'package:magictank/generated/l10n.dart';

import 'canvas.dart';

class CutPreviewPage extends StatefulWidget {
  final Map keydata;
  final List<int> ahNum;
  final List<int> bhNum;
  final List<String> ahNums;
  final List<String> bhNums;
  const CutPreviewPage(
      this.keydata, this.ahNum, this.bhNum, this.ahNums, this.bhNums,
      {Key? key})
      : super(key: key);

  @override
  State<CutPreviewPage> createState() => _CutPreviewPageState();
}

class _CutPreviewPageState extends State<CutPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 300,
          height: 400,
          color: Colors.white,
          child: Column(
            children: [
              Text(S.of(context).copykeypreview),
              const Divider(),
              Expanded(
                child: Center(
                  child: CustomPaint(
                    //willChange: true,
                    size: const Size(double.maxFinite, double.maxFinite),
                    painter: FlutterPainter(0, model: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
