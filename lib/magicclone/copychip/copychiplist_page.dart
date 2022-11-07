import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/magicclone/chipclass/progresschip.dart';
import 'package:magictank/userappbar.dart';

class CopyChipListPage extends StatefulWidget {
  const CopyChipListPage({Key? key}) : super(key: key);

  @override
  _CopyChipListPageState createState() => _CopyChipListPageState();
}

class _CopyChipListPageState extends State<CopyChipListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userCloneBar(context),
      body: const CopyPageList(),
    );
  }
}

class CopyPageList extends StatefulWidget {
  const CopyPageList({Key? key}) : super(key: key);

  @override
  _CopyPageListState createState() => _CopyPageListState();
}

class _CopyPageListState extends State<CopyPageList> {
  List chiplistdata = [];
  @override
  void initState() {
    chiplistdata = List.from(progressChip.supportchiplist);
    super.initState();
  }

  List<Widget> chiplist() {
    List<Widget> temp = [];

    for (var i = 0; i < chiplistdata.length; i++) {
      // temp.add(ListTile(
      //   leading: Image.asset(chiplistdata[i]["picname"]),
      //   title: Text(chiplistdata[i]["name"]),
      //   onTap: () {
      //     //测试
      //     Navigator.pushNamed(context, '/copychipinstructions', arguments: {
      //       "name": chiplistdata[i]["name"],
      //       "id": chiplistdata[i]["id"]
      //     });
      //   },
      // ));
      // temp.add(Divider(
      //   height: 3,
      // ));
      temp.add(Container(
          height: 40.h,
          width: double.maxFinite,
          margin: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: TextButton(
            child: Row(
              children: [
                SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: Image.asset(
                    chiplistdata[i]["picname"],
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  chiplistdata[i]["name"],
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            onPressed: () {
              progressChip.chipnamebyte =
                  List.from(chiplistdata[i]["chipnamebyte"]);
              Navigator.pushNamed(context, '/copychipinstructions',
                  arguments: chiplistdata[i]);
            },
          )));
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
          width: double.maxFinite,
          child: Center(
            child: Text(
              S.of(context).chipcopy,
              style: TextStyle(
                fontSize: 30.sp,
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: 20.h,
        // ),
        Expanded(
          child: ListView(
            children: chiplist(),
          ),
        ),
      ],
    );
  }
}
