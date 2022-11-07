import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/http/api.dart';
import 'package:magictank/userappbar.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'appdata.dart';
import 'dialogshow/dialogpage.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userAppBar(context),
      body: const Register(),
    );
  }
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  RegExp accountRegExp = RegExp(r'[A-Za-z0-9_]+'); //数字和和字母组成
  RegExp pwRegExp = RegExp(r'[A-Za-z0-9]+'); //数字和和字母组成
  RegExp vericodeRegExp = RegExp(r'[0-9]+'); //数字和和字母组成

  String inputaccountText = '';
  String input1pwText = '';
  String input2pwText = '';
  bool showpw = true;
  late ProgressDialog pd;
  bool checkautologinstate = true;
  bool checkagreestate = true;
  Timer? timer;
  int count = 60;
  bool sendcodestate = false;
  String inputcode = "";
  String receivecode = "";
  int language = 0;
  @override
  void initState() {
    pd = ProgressDialog(context: context);
    super.initState();
  }

  void startTime() async {
    //设置启动图生效时间

    // 空等1秒之后再计时
    timer = Timer.periodic(const Duration(milliseconds: 1000), (v) {
      count--;
      if (count == 0) {
        count = 60;
        timer!.cancel();
        sendcodestate = false;
      }
      setState(() {});
    });
  }

  List<DropdownMenuItem<int>> phonehead() {
    List<DropdownMenuItem<int>> temp = [];
    for (var i = 0; i < supportphone.length; i++) {
      temp.add(
        DropdownMenuItem(child: Text(supportphone[i]), value: i),
      );
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          SizedBox(
            width: 320.w,
            height: 48.h,
            child: Center(
              child: Text(
                S.of(context).newregister,
                style: TextStyle(fontSize: 19.sp),
              ),
            ),
          ),
          SizedBox(
            width: 320.w,
            height: 17.h,
            child: Text(
              S.of(context).newuser,
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          SizedBox(
              width: 320.w,
              height: 31,
              child: Row(
                children: [
                  DropdownButton(
                    //autofocus: true,
                    icon: const Icon(Icons.arrow_drop_down_sharp,
                        color: Colors.white),
                    underline: const SizedBox(),
                    value: language,
                    items: phonehead(),
                    onChanged: (value) {
                      language = value as int;
                      setState(() {});
                    },
                  ),
                  Expanded(
                    child: TextField(
                      // controller: inputaccountText,
                      decoration: InputDecoration(
                          hintText: S.of(context).inputuser,
                          contentPadding: EdgeInsets.zero),
                      showCursor: true,
                      enableInteractiveSelection: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        //  LengthLimitingTextInputFormatter(16),
                        //  WhitelistingTextInputFormatter(accountRegExp),
                        FilteringTextInputFormatter(vericodeRegExp,
                            allow: true),
                      ],
                      onChanged: (value) {
                        inputaccountText = value;
                      },
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: 14.h,
          ),
          SizedBox(
            width: 320.w,
            height: 17.h,
            child: Text(
              S.of(context).pw,
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          SizedBox(
            width: 320.w,
            height: 31.h,
            child: TextField(
              decoration: InputDecoration(
                  hintText: S.of(context).inputpw,
                  contentPadding: EdgeInsets.zero),
              obscureText: !showpw,
              keyboardType: TextInputType.visiblePassword,
              showCursor: true,
              enableInteractiveSelection: false,
              inputFormatters: [
                LengthLimitingTextInputFormatter(18),
                //  WhitelistingTextInputFormatter(pwRegExp),
                FilteringTextInputFormatter(pwRegExp, allow: true),
              ],
              onChanged: (value) {
                ///禁止联想输入
                ///禁止非英文输入（不要用inputFormatters:[WhitelistingTextInputFormatter(xxx)]，空格输入，最后一个字符删除等有问题）；
                ///判断是否输入完成(达到输入上限)
                // inputWordCompleted();
                setState(() {
                  input1pwText = value;
                });
                ////print(value);
              },
            ),
          ),
          SizedBox(
            height: 14.h,
          ),
          SizedBox(
            width: 320.w,
            height: 17.h,
            child: Text(
              S.of(context).inputpwagain,
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          SizedBox(
            width: 320.w,
            height: 31.h,
            child: TextField(
              decoration: InputDecoration(
                  hintText: S.of(context).inputpwagain,
                  contentPadding: EdgeInsets.zero),
              obscureText: !showpw,
              keyboardType: TextInputType.visiblePassword,
              showCursor: true,
              enableInteractiveSelection: false,
              inputFormatters: [
                LengthLimitingTextInputFormatter(18),
                //WhitelistingTextInputFormatter(pwRegExp),
                FilteringTextInputFormatter(pwRegExp, allow: true),
              ],
              onChanged: (value) {
                ///禁止联想输入
                ///禁止非英文输入（不要用inputFormatters:[WhitelistingTextInputFormatter(xxx)]，空格输入，最后一个字符删除等有问题）；
                ///判断是否输入完成(达到输入上限)
                // inputWordCompleted();
                setState(() {
                  input2pwText = value;
                });
                ////print(value);
              },
            ),
          ),
          SizedBox(
            height: 14.h,
          ),
          SizedBox(
            width: 320.w,
            height: 17.h,
            child: Text(
              S.of(context).inputvercode,
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          SizedBox(
              width: 320.w,
              height: 31.h,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: S.of(context).inputpwagain,
                          contentPadding: EdgeInsets.zero),
                      keyboardType: TextInputType.number,
                      showCursor: true,
                      enableInteractiveSelection: false,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                        //WhitelistingTextInputFormatter(pwRegExp),
                        FilteringTextInputFormatter(vericodeRegExp,
                            allow: true),
                      ],
                      onChanged: (value) {
                        ///禁止联想输入
                        ///禁止非英文输入（不要用inputFormatters:[WhitelistingTextInputFormatter(xxx)]，空格输入，最后一个字符删除等有问题）；
                        ///判断是否输入完成(达到输入上限)
                        // inputWordCompleted();
                        setState(() {
                          inputcode = value;
                        });
                        ////print(value);
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (!sendcodestate) {
                          if (inputaccountText != "") {
                            sendcodestate = true;
                            startTime();
                            if (language != 0) {
                              inputaccountText =
                                  supportphone[language].toString() +
                                      inputaccountText;
                            }
                            var res = await Api.sendcode({
                              "phone": inputaccountText,
                              "language": language
                            });
                            if (res["state"]) {
                              receivecode = res["code"];
                            } else {
                              Fluttertoast.showToast(msg: res["msg"]);
                            }
                            Fluttertoast.showToast(
                                msg: S.of(context).vercodesendok);
                          } else {
                            Fluttertoast.showToast(
                                msg: S.of(context).inputphonenum);
                          }
                        }
                      },
                      child: SizedBox(
                        width: 80.w,
                        child: Center(
                          child: Text(sendcodestate
                              ? "$count"
                              : S.of(context).getvercode),
                        ),
                      ))
                ],
              )),
          SizedBox(
            width: 320.w,
            child: Row(
              children: [
                Text(S.of(context).showpw),
                Checkbox(
                    value: showpw,
                    activeColor: const Color(0xff50c5c4),
                    onChanged: (value) {
                      setState(() {
                        showpw = value!;
                      });
                    }),
                const Expanded(child: SizedBox()),
                Text(S.of(context).autologin),
                Checkbox(
                    value: appData.autologin,
                    activeColor: const Color(0xff50c5c4),
                    onChanged: (value) {
                      setState(() {
                        appData.autologin = value!;
                        appData
                            .upgradeAppData({"autologin": appData.autologin});
                      });
                    }),
              ],
            ),
          ),
          SizedBox(
            width: 320.w,
            child: ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff50c5c4))),
              child: Text(S.of(context).register),
              onPressed: () async {
                if (inputaccountText.length > 3 && input1pwText.length > 3) {
                  if (input1pwText == input2pwText) {
                    if (checkagreestate) {
                      if (inputcode != receivecode) {
                        Fluttertoast.showToast(msg: "验证码错误,请检查");
                      } else {
                        pd.show(max: 100, msg: S.of(context).logining);
                        var temp = await Api.create(
                            {"account": inputaccountText, "pwd": input1pwText});
                        if (temp["state"]) {
                          var temp = await Api.getuserinfo({
                            "account": inputaccountText,
                            "pwd": input1pwText
                          });
                          ////print(temp);
                          temp["autologin"] = checkautologinstate;
                          temp["loginstate"] = true;
                          temp["qqnumber"] = "";
                          temp["bluetoothname"] = "";
                          appData.upgradeAppData(temp);
                          pd.close();
                          Navigator.pushReplacementNamed(context, "/",
                              arguments: {"indexpage": 0});
                        } else {
                          pd.close();
                          showDialog(
                              context: context,
                              builder: (c) {
                                return MyTextDialog(
                                    S.of(context).registererror);
                              });
                        }
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return MyTextDialog(S.of(context).needagreed);
                          });
                    }
                  } else {
                    ////print(input1pwText);
                    ////print(input2pwText);
                    showDialog(
                        context: context,
                        builder: (c) {
                          return MyTextDialog(S.of(context).pwnotmatch);
                        });
                  }
                  // ////print(temp);
                } else {
                  showDialog(
                      context: context,
                      builder: (c) {
                        return MyTextDialog(S.of(context).logintip);
                      });
                }
              },
            ),
          ),
          const Expanded(child: SizedBox()),
          // SizedBox(
          //   width: 320.w,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(S.of(context).agreed),
          //       TextButton(
          //         onPressed: () {},
          //         child: Text(
          //           S.of(context).privacy,
          //           style: const TextStyle(color: Color(0xff50c5c4)),
          //         ),
          //       ),
          //       Checkbox(
          //           value: checkagreestate,
          //           activeColor: const Color(0xff50c5c4),
          //           onChanged: (value) {
          //             checkagreestate = value!;
          //           })
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
