import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';
import 'code_screen.dart';
import 'image_screen.dart';

class ChatList extends StatefulWidget {
  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Color selectedColor = Theme.of(context).primaryColor;
    ThemeData lightTheme = ThemeData(
      colorSchemeSeed: selectedColor,
      brightness: Brightness.light,
    );
    ThemeData darkTheme = ThemeData(
      colorSchemeSeed: selectedColor,
      brightness: Brightness.dark,
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          '',
          style: textTheme.displaySmall!
              .copyWith(color: lightTheme.colorScheme.primary),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Image.asset(
                    'assets/images/ChatGPT_logo.png',
                    width: 40,
                    height: 40,
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: 'Chat GPT',
                      style: textTheme.bodyMedium!,
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Korean Ver.',
                          style: textTheme.bodySmall!.copyWith(
                              color: lightTheme.colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    '대화 내용 요약 들어갈 곳',
                    style: textTheme.bodyLarge!.copyWith(
                        color: lightTheme.colorScheme.onPrimaryContainer),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => ChatScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/ChatGPT_logo.png',
                    width: 40,
                    height: 40,
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: 'Dall-E',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Korean Ver.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    '영어로 번역해서 이미지를 생성해주는 AI 입니다.',
                    style: TextStyle(fontSize: 12.0),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => ImageScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/ChatGPT_logo.png',
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    'Code Helper',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  subtitle: Text(
                    '코드를 작성해주는 AI 입니다.',
                    style: TextStyle(fontSize: 12.0),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => CodeScreen(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
