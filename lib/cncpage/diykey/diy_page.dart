import 'package:flutter/material.dart';
import 'package:magictank/generated/l10n.dart';
import 'package:magictank/userappbar.dart';

class DiyPage extends StatelessWidget {
  const DiyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userTankBar(context),
      body: const Diy(),
    );
  }
}

class Diy extends StatefulWidget {
  const Diy({Key? key}) : super(key: key);

  @override
  State<Diy> createState() => _DiyState();
}

class _DiyState extends State<Diy> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 100.0,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(
                width: 3,
                color: Colors.grey,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            child: TextButton(
              child: Text(S.of(context).measurekey),
              onPressed: () {
                Navigator.pushNamed(context, '/diykeystep');
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(
                width: 3,
                color: Colors.grey,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            height: 100.0,
            child: TextButton(
              child: Text(S.of(context).smartcreatekey),
              onPressed: () {
                Navigator.pushNamed(context, "/smartdiy");
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
