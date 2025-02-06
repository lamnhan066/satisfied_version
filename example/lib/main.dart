import 'package:flutter/material.dart';
import 'package:satisfied_version/satisfied_version.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Play With Satisfied Version',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  String? _error1;
  String? _error2;
  String _result = '';

  void _updateResult() {
    _error1 = null;
    _error2 = null;
    _result = '';

    String value1;
    String value2;

    try {
      value1 = _controller1.text;
      VersionComparator(SatisfiedCondition.removeCondition(value1));
    } on FormatException catch (e) {
      setState(() {
        _error1 = e.message;
      });
      return;
    }

    try {
      value2 = _controller2.text;
      VersionComparator(SatisfiedCondition.removeCondition(value2));
    } on FormatException catch (e) {
      _error2 = e.message;
      setState(() {});
      return;
    }

    try {
      final isSatisfied = SatisfiedVersion.string(value1, value2);
      _result = isSatisfied ? "Satisfied" : "Not satisfied";
    } on FormatException catch (e) {
      _result = e.message;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Play With The Satisfied Version')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _controller1,
              decoration: const InputDecoration(
                labelText: 'Version (Ex: "1.0.0", "1.2.3",...)',
              ),
              onChanged: (_) => _updateResult(),
              validator: (_) => _error1,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            TextFormField(
              controller: _controller2,
              decoration: const InputDecoration(
                labelText: 'Compare With (Ex: ">=1.0.0", "<1.2.3",...)',
              ),
              onChanged: (_) => _updateResult(),
              validator: (_) => _error2,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),
            Text(_result),
          ],
        ),
      ),
    );
  }
}
