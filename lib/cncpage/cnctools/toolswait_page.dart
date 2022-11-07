import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/cncpage/bluecmd/cmd.dart';
import 'package:magictank/cncpage/bluecmd/sendcmd.dart';
import 'package:magictank/cncpage/bluecmd/share_manganger.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

import '../../alleventbus.dart';
import '../../appdata.dart';

class ToolsWaitPage extends StatefulWidget {
  final Map arguments;
  const ToolsWaitPage(this.arguments, {Key? key}) : super(key: key);

  @override
  _ToolsWaitPageState createState() => _ToolsWaitPageState();
}

class _ToolsWaitPageState extends State<ToolsWaitPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (getCncBtState()) {
          Fluttertoast.showToast(msg: S.of(context).working);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: userTankBar(context),
        body: Toolswait(widget.arguments),
      ),
    );
  }
}

class Toolswait extends StatefulWidget {
  final Map arguments;
  const Toolswait(this.arguments, {Key? key}) : super(key: key);

  @override
  _ToolswaitState createState() => _ToolswaitState();
}

class _ToolswaitState extends State<Toolswait> {
  int no = 0;

  @override
  void initState() {
    appData.errorreturn = true;
    eventBus.on<TipEvent>().listen(
      (TipEvent event) {
        Navigator.pushReplacementNamed(context, '/toolsshow', arguments: {
          "no": event.no,
          "page": event.page,
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Stack(
          children: [
            Align(
              child: SizedBox(
                width: 200.r,
                height: 200.r,
                child: CircularProgressIndicator(
                    strokeWidth: 15.w, color: const Color(0xff384c70)),
              ),
              alignment: Alignment.center,
            ),
            Align(
              child: Container(
                width: 110.r,
                height: 110.r,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(55.w)),
                child: TextButton(
                  onPressed: () {
                    sendCmd([cncBtSmd.pause, 0, 0]);
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (c) {
                          return MyTextDialog(
                            S.of(context).suspending,
                            button1: S.of(context).stop,
                            button1color: Colors.red,
                            button2: S.of(context).continuebt,
                            button2color: Colors.green,
                            model: 1,
                          );
                        }).then((value) {
                      if (value) //继续
                      {
                        sendCmd([cncBtSmd.resume, 0, 0]);
                      } else //停止
                      {
                        sendCmd([cncBtSmd.stop, 0, 0]);
                      }
                    });
                  },
                  child: Text(
                    S.of(context).suspend,
                    style: TextStyle(color: Colors.white, fontSize: 30.sp),
                  ),
                ),
              ),
              alignment: Alignment.center,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 50.h),
                child: Text(
                  S.of(context).working,
                  style: TextStyle(fontSize: 17.sp),
                ),
              ),
            ),
          ],
        )),
      ],
    );
  }
}
