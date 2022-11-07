import 'package:flutter/material.dart';

import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

import '../main.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userAppBar(context),
      body: const SeleLanguage(),
    );
  }
}

class SeleLanguage extends StatefulWidget {
  const SeleLanguage({Key? key}) : super(key: key);

  @override
  _SeleLanguageState createState() => _SeleLanguageState();
}

class _SeleLanguageState extends State<SeleLanguage> {
  List<Map> language = [
    {"language": "简体中文", "languageCode": "zh", "countryCode": "CN"},
    {"language": "English", "languageCode": "en", "countryCode": "US"}
  ];

  Widget languagetitle(context, int index) {
    ////print(locales!.languageCode);

    return ListTile(
      title: Text(language[index]["language"]),
      trailing: locales!.languageCode == language[index]["languageCode"]
          ? const Icon(
              Icons.check,
              color: Colors.green,
            )
          : null,
      onTap: () {
        setState(() {
          locales = Locale(language[index]["languageCode"], "");
          S.delegate.load(locales!);
          ////print(locales);
          Navigator.of(context).pop();
          Navigator.pushNamed(context, '/');
        });

        // S.delegate.load(_locale);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: language.length,
        itemBuilder: (BuildContext context, index) {
          return languagetitle(context, index);
        });
  }
}
