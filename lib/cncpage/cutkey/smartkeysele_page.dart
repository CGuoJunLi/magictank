//选择钥匙是否是智能卡
import 'package:flutter/material.dart';
import 'package:magictank/generated/l10n.dart';

class SeleSmartKeyPage extends StatefulWidget {
  const SeleSmartKeyPage({Key? key}) : super(key: key);

  @override
  State<SeleSmartKeyPage> createState() => _SeleSmartKeyPageState();
}

class _SeleSmartKeyPageState extends State<SeleSmartKeyPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Center(
          child: Container(
            // color: Colors.white,
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              children: [
                SizedBox(
                  height: 24,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(S.of(context).selebt),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Center(
                    child: ListView(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, 1);
                            },
                            child: Text(S.of(context).standardkey)),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, 2);
                            },
                            child: Text(S.of(context).smartkey)),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context, 0);
                              // return false;
                            },
                            child: Text(S.of(context).cancel),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
