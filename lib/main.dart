import 'package:i_gpt/bot_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'chat_message.dart';
import 'image_message.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MessageService()),
        ChangeNotifierProvider(create: ((context) => ImageService())),
      ],
      child: ChatApp(),
    ),
  );
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BotList(),
    );
  }
}
