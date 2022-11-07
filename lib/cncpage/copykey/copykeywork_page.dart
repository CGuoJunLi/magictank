import 'package:flutter/material.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

class CopyKeyWorkPage extends StatefulWidget {
  const CopyKeyWorkPage({Key? key}) : super(key: key);

  @override
  _CopyKeyWorkPageState createState() => _CopyKeyWorkPageState();
}

class _CopyKeyWorkPageState extends State<CopyKeyWorkPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (c) {
              return MyTextDialog(
                S.of(context).suspending,
                button2: S.of(context).continuebt,
                model: 1,
              );
            });
        return false;
      },
      child: Scaffold(
        appBar: userTankBar(context),
        body: const CopyKeyWork(),
      ),
    );
  }
}

class CopyKeyWork extends StatefulWidget {
  const CopyKeyWork({Key? key}) : super(key: key);

  @override
  _CopyKeyWorkState createState() => _CopyKeyWorkState();
}

class _CopyKeyWorkState extends State<CopyKeyWork> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Stack(
          children: [
            Align(
              child: Image.asset(
                "image/loading.gif",
                fit: BoxFit.cover,
              ),
              alignment: Alignment.center,
            ),
            const Align(
              child: Text(
                "100%",
                style: TextStyle(fontSize: 20),
              ),
              alignment: Alignment.center,
            ),
          ],
        )),
        Expanded(
          child: Center(
            child: TextButton(
              child: Text(S.of(context).suspend),
              onPressed: () {
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
                  } else //停止
                  {
                    Navigator.pop(context);
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
