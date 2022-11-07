import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/userappbar.dart';

class UnlockToolsList extends StatefulWidget {
  const UnlockToolsList({Key? key}) : super(key: key);

  @override
  State<UnlockToolsList> createState() => _UnlockToolsListState();
}

class _UnlockToolsListState extends State<UnlockToolsList> {
  int currentindex = -1;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> getKeyList() {
    List<Widget> temp = [];
    for (var i = 0; i < appData.readCodeList.length; i++) {
      temp.add(
        Container(
          width: double.maxFinite,
          height: 43.h,
          color: currentindex != i ? Colors.white : const Color(0xff384c70),
          child: TextButton(
            onPressed: () {
              currentindex = i;

              Navigator.pushNamed(context, "/unlocktools",
                  arguments: appData.readCodeList[i]);
            },
            child: Text(
              appData.readCodeList[i]["cnkeyname"],
              style: TextStyle(
                  color: currentindex == i
                      ? Colors.white
                      : const Color(0xff384c70)),
            ),
          ),
        ),
      );
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(
        const AssetImage("image/tank/readtools/reader_code_va2tool.png"),
        context);
    precacheImage(
        const AssetImage("image/tank/readtools/reader_code_key.png"), context);
    precacheImage(
        const AssetImage("image/tank/readtools/icon/reade_code_lock.png"),
        context);
    precacheImage(
        const AssetImage("image/tank/readtools/icon/reade_code_left.png"),
        context);
    precacheImage(
        const AssetImage("image/tank/readtools/icon/reade_code_right.png"),
        context);
    precacheImage(
        const AssetImage("image/tank/readtools/icon/reade_code_up.png"),
        context);
    precacheImage(
        const AssetImage("image/tank/readtools/icon/reade_code_down.png"),
        context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userTankBar(context),
      body: ListView(children: getKeyList()),
    );
  }
}
