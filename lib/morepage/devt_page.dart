import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/userappbar.dart';

class DEVTPage extends StatefulWidget {
  const DEVTPage({Key? key}) : super(key: key);

  @override
  State<DEVTPage> createState() => _DEVTPageState();
}

class _DEVTPageState extends State<DEVTPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    "*请输入标题",
                    style: TextStyle(color: Color(0xff384c70)),
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 30.r,
                    margin: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5.r)),
                    child: const TextField(
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const Text(
                    "*请简单描述一下内容(100个字以内)",
                    style: TextStyle(color: Color(0xff384c70)),
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 300.r,
                    margin: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5.r)),
                    child: const TextField(
                      maxLength: 100,
                      maxLines: 200,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const Text(
                    "*联系方式(电话请加区号)",
                    style: TextStyle(color: Color(0xff384c70)),
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 30.r,
                    margin: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5.r)),
                    child: const TextField(
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text("选择附件")),
                ],
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xff384c70)),
                    minimumSize: MaterialStateProperty.all(
                        Size(double.maxFinite, 40.r))),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (c) {
                        return const MyTextDialog("提交成功,我们会在1~3个工作日之内与你取得联系!");
                      });
                },
                child: const Text("提交")),
          ],
        ),
      ),
    );
  }
}
