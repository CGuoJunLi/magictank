import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

class SpeekPage extends StatefulWidget {
  const SpeekPage({Key? key}) : super(key: key);

  @override
  State<SpeekPage> createState() => _SpeekPageState();
}

class _SpeekPageState extends State<SpeekPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: userAppBar(context),
      body: ListView(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                Text(S.of(context).voicespeed +
                    ":${(appData.setSpeechRate * 100).toInt()}"),
                Expanded(child: Container()),
                CupertinoSlider(
                  value: appData.setSpeechRate,
                  onChanged: (value) {
                    appData.setSpeechRate = value;
                    debugPrint("$value");
                    appData.upgradeAppData({"SpeechRate": value});
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                Text(S.of(context).voicehight +
                    ":${(appData.setPitch * 100).toInt()}"),
                Expanded(child: Container()),
                CupertinoSlider(
                  min: 0.5,
                  max: 2.0,
                  value: appData.setPitch,
                  onChanged: (value) {
                    appData.setPitch = value;
                    debugPrint("$value");
                    appData.upgradeAppData({"Pitch": value});
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: OutlinedButton(
              child: Text(S.of(context).example),
              onPressed: () {
                appData.speakText("Welcome to e-clone");
              },
            ),
          )
        ],
      ),
    );
  }
}
