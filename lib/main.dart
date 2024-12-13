import 'package:Mimir/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Mimir/bot_list.dart';
import 'package:Mimir/code_message.dart';
import 'package:Mimir/gpt4_message.dart';
import 'package:Mimir/gpt4_ori_message.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:Mimir/solar_message.dart';
import 'package:Mimir/solar_pro_message.dart';
import 'package:Mimir/gpt4_o1_preview_message.dart';
import 'chat_message.dart';
import 'chats.dart';
import 'image_message.dart';
import 'image_ori_message.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MessageService()),
        ChangeNotifierProvider(create: (context) => ImageService()),
        ChangeNotifierProvider(create: (context) => ImageServiceOri()),
        ChangeNotifierProvider(create: (context) => GPT4MessageService()),
        ChangeNotifierProvider(create: (context) => GPT4OriMessageService()),
        ChangeNotifierProvider(
            create: (context) => GPT4o1PreviewMessageService()),
        ChangeNotifierProvider(create: (context) => SOLARMessageService()),
        ChangeNotifierProvider(create: (context) => SOLARPROMessageService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Mimir',
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                label: Text(
                  style: TextStyle(color: Colors.black),
                  'ID',
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                label: Text(
                  style: TextStyle(color: Colors.black),
                  'Password',
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                String id = _idController.text;
                String password = _passwordController.text;
                // 여기에 로그인 처리 로직 추가
                if (id == 'admin' && password == '8888') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BotList(),
                    ),
                  );
                }
                print('ID: $id, Password: $password');
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String id = _idController.text;
                String password = _passwordController.text;
                // 여기에 로그인 처리 로직 추가
                if (id == 'admin' && password == '8888') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BotList(),
                    ),
                  );
                }
                print('ID: $id, Password: $password');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.black, width: 1),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shadowColor: Colors.blue,
                elevation: 0,
              ).copyWith(
                overlayColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.blue.withOpacity(0.3);
                  }
                  return null;
                }),
              ),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
