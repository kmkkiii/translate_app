import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Translate App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _textEditController = TextEditingController();

  Future<void> _translate(String sentence) async {
    final url = Uri.parse("https:..labs.goo.ne.jp/api/hiragana");
    final headers = {"Content-Type": "application/json"};
    final body = json.encode({
      "app_id":
          "6c53467f505f10f6c816643d5bfdb9155a88b1f39344c66601b20c09d8378473",
      "sentence": sentence,
      "output_type": "hiragana"
    });
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    final responseJson = json.decode(response.body) as Map<String, dynamic>;
    debugPrint(responseJson["converted"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Translate App")),
        body: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _textEditController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "文章を入力してください",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "文章が入力されていません";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    final formState = _formKey.currentState!;
                    if (!formState.validate()) {
                      return;
                    }
                    debugPrint("text = ${_textEditController.text}");
                  },
                  child: const Text("変換"))
            ])));
  }

  // メモリリークのリスクを回避
  @override
  void dispose() {
    _textEditController.dispose();
    super.dispose();
  }
}
