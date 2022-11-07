//加工测试钥匙
import 'package:flutter/material.dart';

class TestKeyPage extends StatelessWidget {
  const TestKeyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0XFF6E66AA),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Image.asset(
          "image/tank/tank.png",
          scale: 2.0,
        ),
      ),
      body: const TestKey(),
    );
  }
}

class TestKey extends StatefulWidget {
  const TestKey({Key? key}) : super(key: key);

  @override
  State<TestKey> createState() => _TestKeyState();
}

class _TestKeyState extends State<TestKey> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
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
            child: const Text("立铣胚测试钥匙"),
            onPressed: () {
              Navigator.pushNamed(context, "/testkeylist",
                  arguments: {"type": 2});
            },
          ),
        ),
        Container(
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
            child: const Text("平铣胚测试钥匙"),
            onPressed: () {
              Navigator.pushNamed(context, "/testkeylist",
                  arguments: {"type": 2});
            },
          ),
        ),
      ],
    );
  }
}
