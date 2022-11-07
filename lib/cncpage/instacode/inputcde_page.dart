import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:magictank/http/api.dart';
import '../../main.dart';

class InputCodePage extends StatefulWidget {
  final Map arguments;
  const InputCodePage(this.arguments, {Key? key}) : super(key: key);

  @override
  _InputCodePageState createState() => _InputCodePageState();
}

class _InputCodePageState extends State<InputCodePage> {
  final _username = TextEditingController();
  var focusNode = FocusNode();
  RegExp englishRegExp = RegExp(r'(^[a-zA-Z]*$)');
  String inputText = '';
  late ProgressDialog pd;

  @override
  void initState() {
    pd = ProgressDialog(context: context);

    _username.text = "初始值";
    dismissKeyboard();
    super.initState();
  }

  showKeyboard() {
    focusNode.requestFocus();
  }

  dismissKeyboard() {
    focusNode.unfocus();
  }

  Widget getTextField() {
    // var currentModel = currentItem();
    return SizedBox(
        width: 321.w,
        height: 25.h,
        child: TextField(
            //  focusNode: focusNode,
            //字体透明
            showCursor: true,
            enableInteractiveSelection: false,
            keyboardType: TextInputType.visiblePassword,
            style: TextStyle(fontSize: 15.sp),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: S.of(context).searchcodetip,
              contentPadding: EdgeInsets.all(8.h),
              hintStyle: TextStyle(fontSize: 15.sp),
            ),
            onChanged: (value) {
              inputText = value;

              ///禁止联想输入
              ///禁止非英文输入（不要用inputFormatters:[WhitelistingTextInputFormatter(xxx)]，空格输入，最后一个字符删除等有问题）；
              ///判断是否输入完成(达到输入上限)
              // inputWordCompleted();
            },
            onSubmitted: (value) {
              //如果是回车键隐藏键盘,则开始搜索齿号\
              inputText = value;
              debugPrint("输入完毕" + value);
            }));
  }

  Future<void> getKeyList() async {
    try {
      var result = await Api.getBitting(
          "language=${(locales!.languageCode == "zh" ? "0" : "1")}&carid=${widget.arguments["carid"]}&code=$inputText");
      if (pd.isOpen()) {
        pd.close();
      }

      Navigator.pushNamed(context, "/getcodelist", arguments: {
        "data": result,
        "carname": widget.arguments["carname"],
      });
    } catch (e) {
      Fluttertoast.showToast(msg: S.of(context).connectnetservererror);
      if (pd.isOpen()) {
        pd.close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userTankBar(context),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 11.w),
            height: 48.h,
            width: double.maxFinite,
            child: Text(
              widget.arguments["carname"],
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 5.h,
            color: const Color(0xffdde2ea),
          ),
          Container(
            height: 15.h,
            width: double.maxFinite,
            margin: EdgeInsets.only(left: 11.w, top: 12.h),
            child: Text(
              S.of(context).alllost,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15.sp,
              ),
            ),
          ),
          SizedBox(
            height: 77.h,
          ),
          getTextField(),
          SizedBox(
            height: 22.h,
          ),
          SizedBox(
            width: 100.w,
            height: 30.h,
            child: OutlinedButton(
              style: ButtonStyle(
                // backgroundColor: MaterialStateProperty.all(
                //   const Color(0xff384c70),
                // ),
                side: MaterialStateProperty.all(
                  const BorderSide(color: Color(0xff384c70)),
                ),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
              ),
              child: Text(S.of(context).searchbt),
              onPressed: () {
                //  setState(() {});
                if (inputText == "") {
                  Fluttertoast.showToast(msg: S.of(context).searchcodetip);
                } else {
                  pd.show(max: 100, msg: S.of(context).searching);
                  getKeyList();
                }
              },
            ),
          ),
          SizedBox(
            height: 29.h,
          ),
          Container(
            width: 320.w,
            height: 210.h,
            decoration: BoxDecoration(
                color: const Color(0XFF384c70),
                borderRadius: BorderRadius.circular(15.w)),
            child: const Text("示例说明"),
          ),
        ],
      ),
    );
  }
}
