import 'package:mimir/gpt4_ori_screen.dart';
import 'package:mimir/image_ori_screen.dart';
import 'package:mimir/solar_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

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
                    ),
                  ),
                  subtitle: Text(
                    '대화 내용 요약',
                    style: textTheme.bodyLarge!.copyWith(
                        color: lightTheme.colorScheme.onPrimaryContainer),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => GPT4OriScreen(),
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
                      style: textTheme.bodyMedium!,
                    ),
                  ),
                  subtitle: Text(
                    '대화 내용 요약',
                    style: textTheme.bodyLarge!.copyWith(
                        color: lightTheme.colorScheme.onPrimaryContainer),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => ImageScreenOri(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/solar_logo.png',
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    'SOLAR',
                    style: textTheme.bodyMedium!,
                  ),
                  subtitle: Text(
                    '대화 내용 요약',
                    style: textTheme.bodyLarge!.copyWith(
                        color: lightTheme.colorScheme.onPrimaryContainer),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => SOLARScreen(),
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
