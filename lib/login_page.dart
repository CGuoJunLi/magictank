//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:magictank/appdata.dart';

import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';

import 'package:magictank/http/api.dart';

import 'package:magictank/userappbar.dart';

import 'package:sn_progress_dialog/progress_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userAppBar(context),
      body: const UserLogin(),
    );
  }
}

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  // TextEditingController inputaccountText = TextEditingController();
  // TextEditingController inputpwText = TextEditingController();
  bool checkautologinstate = true;
  bool readstate = false;
  RegExp accountRegExp = RegExp(r'[A-Za-z0-9_]+'); //数字和和字母组成
  RegExp pwRegExp = RegExp(r'[A-Za-z0-9]+'); //数字和和字母组成
  String inputaccountText = '';
  String inputpwText = '';
  late ProgressDialog pd;
  late FocusNode _focusNode1;
  // late FocusNode _focusNode2;
  @override
  void initState() {
    _focusNode1 = FocusNode();
    // _focusNode2 = FocusNode();
    _focusNode1.unfocus();
    // _focusNode2.unfocus();
    pd = ProgressDialog(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 320.w,
            height: 48.h,
            child: Center(
              child: Text(
                S.of(context).login,
                style: TextStyle(fontSize: 19.sp),
              ),
            ),
          ),
          SizedBox(
            width: 320.w,
            height: 17.h,
            child: Row(
              children: [
                Text(S.of(context).user + ":"),
                const Expanded(
                  child: SizedBox(),
                ),
                TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: Text(
                      S.of(context).register,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xff50c5c4),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            width: 320.w,
            height: 31.h,
            child: TextField(
              // controller: inputaccountText,
              //focusNode: _focusNode1,
              decoration: InputDecoration(
                  hintText: S.of(context).inputuser,
                  contentPadding: EdgeInsets.zero),
              showCursor: true,
              enableInteractiveSelection: false,
              keyboardType: TextInputType.visiblePassword,
              inputFormatters: [
                LengthLimitingTextInputFormatter(16),
                FilteringTextInputFormatter(accountRegExp, allow: true),
              ],
              onChanged: (value) {
                ///禁止联想输入
                ///禁止非英文输入（不要用inputFormatters:[WhitelistingTextInputFormatter(xxx)]，空格输入，最后一个字符删除等有问题）；
                ///判断是否输入完成(达到输入上限)
                ///
                // if (englishRegExp.hasMatch(value)) {
                //   setState(() {
                //     inputaccountText.selection =
                //         TextSelection.collapsed(offset: value.length);
                //     inputaccountText.text = value;
                //   });
                // }
                setState(() {
                  inputaccountText = value;
                });
                //  ////print();
                ////print(value);
              },
              onSubmitted: (value) {
                //如果是回车键隐藏键盘,则开始搜索齿号
              },
            ),
          ),
          SizedBox(
            height: 43.h,
          ),
          SizedBox(
            width: 320.w,
            height: 17.h,
            child: Row(
              children: [
                Text(S.of(context).pw + ":"),
                const Expanded(child: SizedBox()),
                TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgetpwd');
                    },
                    child: Text(
                      S.of(context).forgetpw,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xff50c5c4),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            width: 320.w,
            height: 31.h,
            child: TextField(
              focusNode: _focusNode1,
              decoration: InputDecoration(
                  hintText: S.of(context).inputpw,
                  contentPadding: EdgeInsets.zero),
              obscureText: true,
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
                  inputpwText = value;
                });
                ////print(value);
              },
              onSubmitted: (value) {
                if (inputaccountText.length > 3 && inputpwText.length > 3) {
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
          SizedBox(
            height: 29.h,
          ),
          SizedBox(
            width: 320.w,
            child: Row(
              children: [
                Text(S.of(context).autologin),
                Checkbox(
                    value: checkautologinstate,
                    activeColor: const Color(0xff50c5c4),
                    onChanged: (value) {
                      setState(() {
                        checkautologinstate = value!;
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
                  onPressed: () async {
                    _focusNode1.unfocus();
                    // _focusNode2.unfocus();
                    if (inputaccountText.length > 3 && inputpwText.length > 3) {
                      pd.show(max: 100, msg: S.of(context).logining);
                      var temp = await Api.login(
                          {"account": inputaccountText, "pwd": inputpwText});
                      debugPrint("$temp");
                      if (temp["state"]) {
                        temp["autologin"] = checkautologinstate;
                        ////print(temp["autologin"]);
                        temp["loginstate"] = true;

                        await appData.upgradeAppData(temp);
                        pd.close();
                        //context.read<AppProvid>().upgradeuserinfo(temp);
                        Navigator.pop(context);
                      } else {
                        pd.close();
                        showDialog(
                            context: context,
                            builder: (c) {
                              return MyTextDialog(S.of(context).loginerror);
                            });
                      }
                      ////print(temp);
                    } else {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return MyTextDialog(S.of(context).logintip);
                          });
                    }
                  },
                  child: Text(S.of(context).login))),
          const Expanded(child: SizedBox()),
          // SizedBox(
          //   width: 320.w,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(S.of(context).agreed),
          //       TextButton(
          //         onPressed: () {
          //           Navigator.pushNamed(context, "/showprivacy");
          //         },
          //         child: Text(
          //           S.of(context).privacy,
          //           style: const TextStyle(
          //             color: Color(0xff50c5c4),
          //           ),
          //         ),
          //       ),
          //       Checkbox(
          //           value: appData.agreeprivacy,
          //           activeColor: const Color(0xff50c5c4),
          //           onChanged: (value) {
          //             setState(() {
          //               appData.agreeprivacy = value!;

          //               if (!appData.agreeprivacy) {
          //                 showDialog(
          //                     context: context,
          //                     builder: (c) {
          //                       return MyTextDialog(
          //                         "你必须同意隐私服务才能继续使用APP",
          //                         button1: "退出",
          //                         button2: "同意",
          //                       );
          //                     }).then((value) {
          //                   if (value) {
          //                     appData.agreeprivacy = true;

          //                     appData.upgradeAppData(
          //                         {"agreeprivacy": appData.agreeprivacy});
          //                     setState(() {});
          //                   } else {
          //                     SystemNavigator.pop();
          //                   }
          //                 });
          //               }
          //               appData.upgradeAppData(
          //                   {"agreeprivacy": appData.agreeprivacy});
          //               setState(() {});
          //             });
          //           }),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
