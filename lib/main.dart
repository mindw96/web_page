// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mimir/bot_list.dart';
import 'package:mimir/gpt4_message.dart';
import 'package:mimir/gpt4_ori_message.dart';
import 'package:mimir/solar_message.dart';
import 'package:mimir/solar_pro_message.dart';
import 'package:mimir/gpt4_o1_preview_message.dart';
import 'package:mimir/gemini_1.5_flash_message.dart';
import 'chat_message.dart';
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
        ChangeNotifierProvider(
            create: (context) => GeminiFlashMessageService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

  LoginScreen({super.key});

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
            Center(
              child: SizedBox(
                width: 250,
                child: TextField(
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
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 250,
                child: TextField(
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
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: Text('로그인 실패'),
                              content: Text('ID 또는 비밀번호가 일치하지 않습니다.'),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      overlayColor: Colors.blue),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    '확인',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            );
                          });
                      _passwordController.clear();
                    }
                    print('ID: $id, Password: $password');
                  },
                ),
              ),
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
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text('로그인 실패'),
                          content: Text('ID 또는 비밀번호가 일치하지 않습니다.'),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  overlayColor: Colors.blue),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                '확인',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        );
                      });
                  _passwordController.clear();
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
                overlayColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.blue.withValues(alpha: 0.3);
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
