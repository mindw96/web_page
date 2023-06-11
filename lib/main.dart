import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:i_gpt/bot_list.dart';
import 'package:i_gpt/code_message.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'chat_message.dart';
import 'chats.dart';
import 'image_message.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MessageService()),
        ChangeNotifierProvider(create: (context) => ImageService()),
        ChangeNotifierProvider(create: (context) => CodeService()),
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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        BotList(),
        ChatList(),
      ].elementAt(bottomNavIndex),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 34.0),
        child: BottomBarDefault(
          items: [
            TabItem(
              icon: Icons.home,
            ),
            TabItem(
              icon: Icons.chat_bubble_outline,
            ),
          ],
          backgroundColor: Colors.transparent,
          color: Colors.black,
          colorSelected: Colors.blue,
          indexSelected: bottomNavIndex,
          onTap: (index) => setState(() {
            bottomNavIndex = index;
          }),
        ),
      ),
    );
  }
}
