import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

class UnlockToolsList extends StatefulWidget {
  const UnlockToolsList({Key? key}) : super(key: key);

  @override
  State<UnlockToolsList> createState() => _UnlockToolsListState();
}

class _UnlockToolsListState extends State<UnlockToolsList> {
  int currentindex = -1;
  List orignllist = [];
  List showlist = [];
  @override
  void initState() {
    orignllist = List.from(appData.readCodeList);
    showlist = List.from(appData.readCodeList);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> getKeyList() {
    List<Widget> temp = [];
    for (var i = 0; i < showlist.length; i++) {
      temp.add(
        Container(
          width: double.maxFinite,
          height: 43.h,
          color: currentindex != i ? Colors.white : const Color(0xff384c70),
          child: TextButton(
            onPressed: () {
              currentindex = i;

              Navigator.pushNamed(context, "/unlocktools",
                  arguments: showlist[i]);
            },
            child: Text(
              showlist[i]["cnkeyname"],
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

  void _search(String text) {
    showlist = [];
    if (text.isEmpty) {
      //debugPrint("空");
      showlist = List.from(orignllist);
    } else {
      List list = orignllist.where((v) {
        if ((v["cnkeyname"] + v["enkeyname"])
            .toLowerCase()
            .contains(text.toLowerCase())) {
          print(v["cnkeyname"] + v["enkeyname"]);
          print(text);
          return true;
        } else {
          return false;
        }
      }).toList();
      print(list);
      showlist = List.from(list);
    }

    setState(() {});
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
        body: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 28.h,
              margin: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      //   inputFormatters: [
                      //  //RegExp accountRegExp = RegExp(r'[A-Za-z0-9_]+'); //数字和和字母组成
                      //     FilteringTextInputFormatter(accountRegExp, allow: true),
                      //   ],
                      onChanged: (instring) {
                        _search(instring);
                      },
                      style: TextStyle(fontSize: 12.sp),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.search,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14.0)),
                          borderSide: BorderSide(color: Color(0xff384c70)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14.0)),
                          borderSide: BorderSide(color: Color(0xff384c70)),
                        ),
                        hintText: S.of(context).inputkeyname,
                        contentPadding: const EdgeInsets.only(bottom: 0),
                        hintStyle: TextStyle(fontSize: 12.sp),
                        // border: OutlineInputBorder(
                        //   borderRadius: const BorderRadius.all(
                        //     Radius.circular(4.0),
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(children: getKeyList()),
            )
          ],
        ));
  }
}
